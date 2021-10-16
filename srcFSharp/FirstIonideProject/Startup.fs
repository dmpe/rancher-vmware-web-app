namespace FirstIonideProject

open System
open System.Collections.Generic
open System.IO
open Microsoft.AspNetCore.Builder
open Microsoft.AspNetCore.Hosting
open Microsoft.Extensions.Configuration
open Microsoft.Extensions.DependencyInjection
open Microsoft.Extensions.Hosting
open Microsoft.OpenApi.Models
open Swashbuckle.AspNetCore.Filters
open System.Reflection
open FirstIonideProject.Infra

type Startup(configuration: IConfiguration) =
    member _.Configuration = configuration

    member _.ConfigureServices(services: IServiceCollection) =
        services.AddMvc() |> ignore

        services.AddSwaggerGen
            (fun swagDoc ->
                swagDoc.EnableAnnotations()
                let filePath = Path.Combine(AppContext.BaseDirectory, "FirstIonideProject.xml")
                swagDoc.IncludeXmlComments(filePath, true)
                
                let info = OpenApiInfo()
                info.Title <- "Kubernetes Rancher and VMware API"
                info.Version <- "v1"
                info.Description <- "A simple example ASP.NET Core Web API"
                info.TermsOfService <- Uri("https://example.com/terms")
                info.Contact <- OpenApiContact(
                    Name = "John Malc",
                    Email = "test@google.com",
                    Url = Uri("https://github.com/dmpe")
                )
                info.License <- OpenApiLicense(
                    Name = "MIT",
                    Url = Uri("https://choosealicense.com/licenses/mit/")
                )
                swagDoc.SwaggerDoc("v1", info)

                swagDoc.OperationFilter<AddHeaderOperationFilter>(
                    "correlationId",
                    "Correlation Id for the request",
                    false
                )

                swagDoc.OperationFilter<AddResponseHeadersFilter>()
                swagDoc.OperationFilter<AppendAuthorizeToSummaryOperationFilter>()
                swagDoc.OperationFilter<SecurityRequirementsOperationFilter>()

                let openDict = Dictionary<string, string>()
                openDict.Add("openid", "OpenID Data")
                openDict.Add("profile", "Profile Data")

                swagDoc.AddSecurityDefinition(
                    "oauth2",
                    OpenApiSecurityScheme(
                        Description = "Redirect to Keycloak",
                        In = ParameterLocation.Header,
                        Name = "Authorization",
                        Type = SecuritySchemeType.OAuth2,
                        Flows =
                            OpenApiOAuthFlows(
                                Implicit =
                                    OpenApiOAuthFlow(
                                        AuthorizationUrl =
                                            Uri(configuration.GetValue("SwaggerUI:keycloak:auth_abs"), UriKind.Absolute),
                                        Scopes = openDict
                                    )
                            )
                    )
                )

                let openApiReferenceOauth2 =
                    OpenApiReference(Type = ReferenceType.SecurityScheme, Id = "oauth2")

                let schemeOauth2 =
                    OpenApiSecurityScheme(Reference = openApiReferenceOauth2)

                let secReqOauth2 = OpenApiSecurityRequirement()
                secReqOauth2.[schemeOauth2] <- List<string>()
                swagDoc.AddSecurityRequirement(secReqOauth2)

                swagDoc.AddSecurityDefinition(
                    "Bearer",
                    OpenApiSecurityScheme(
                        Description = "Requires Bearer Token",
                        In = ParameterLocation.Header,
                        Name = "Authorization",
                        Type = SecuritySchemeType.ApiKey,
                        Scheme = "bearer"
                    )
                )

                let openApiReference =
                    OpenApiReference(Type = ReferenceType.SecurityScheme, Id = "Bearer")

                let scheme =
                    OpenApiSecurityScheme(Reference = openApiReference)

                let secReq = OpenApiSecurityRequirement()
                secReq.[scheme] <- List<string>()
                swagDoc.AddSecurityRequirement(secReq)
            )
        |> ignore

        services.AddSession() |> ignore

        services.AddSwaggerExamplesFromAssemblies(Assembly.GetEntryAssembly())
        |> ignore
        
        services.AddTransient<MariaDBADO>(fun i -> new MariaDBADO(configuration.GetValue("ConnectionStrings:Default"))) |> ignore

        services.AddControllers() |> ignore


    member _.Configure(app: IApplicationBuilder, env: IWebHostEnvironment) =

        let myd = Dictionary<string, string>()
        let rnd = Guid.NewGuid()
        myd.Add("nonce", rnd.ToString())

        if (env.IsDevelopment()) then
            app.UseDeveloperExceptionPage() |> ignore

        app
            .UseHttpsRedirection()
            .UseRouting()
            .UseSwagger()
            .UseSwaggerUI(fun swagEnd ->
                swagEnd.SwaggerEndpoint("v1/swagger.json", "v1")
                |> ignore

                swagEnd.OAuthClientId(configuration.GetValue("SwaggerUI:keycloak:auth_name"))
                swagEnd.OAuthClientSecret(configuration.GetValue("SwaggerUI:keycloak:auth_secret"))
                swagEnd.OAuthRealm("master")
                swagEnd.OAuthAppName(configuration.GetValue("SwaggerUI:keycloak:auth_name"))
                swagEnd.OAuthScopeSeparator(" ")
                swagEnd.OAuthAdditionalQueryStringParams(myd)
                swagEnd.OAuthUseBasicAuthenticationWithAccessCodeGrant())
            .UseAuthorization()
            .UseEndpoints(fun endpoints -> endpoints.MapControllers() |> ignore)
        |> ignore
