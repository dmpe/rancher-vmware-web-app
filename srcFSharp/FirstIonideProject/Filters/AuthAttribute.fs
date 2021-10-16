namespace FirstIonideProject.Filters

open Microsoft.AspNetCore.Mvc
open Microsoft.AspNetCore.Mvc.Filters
open System
open System.Linq
open Microsoft.Extensions.Configuration
open Microsoft.Extensions.DependencyInjection
open System.Net.Http

[<AttributeUsage(AttributeTargets.Class)>]
type AuthAttribute() =
    inherit Attribute()

    interface IAuthorizationFilter with

        member this.OnAuthorization(context: AuthorizationFilterContext) =

            let apiKeyFromHeaders =
                context.HttpContext.Request.Headers.["Authorization"]

            let apiKeyFromAppsettings =
                context.HttpContext.RequestServices.GetRequiredService<IConfiguration>()
                        
            let apiKeyApp =
                apiKeyFromAppsettings.GetValue("SwaggerUI:token:tkn")

            if not (apiKeyFromHeaders.Any()) then
                context.Result <- NotFoundResult()
           
            if not (String.Equals(apiKeyFromHeaders, apiKeyApp)) then
                let conRes =
                    ContentResult(
                        Content = "API Key is not correct.",
                        ContentType = "text/plain; charset=utf-8",
                        StatusCode = 401
                    )

                context.Result <- conRes
