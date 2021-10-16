namespace FirstIonideProject.Controllers

open System
open System.Runtime.InteropServices
open Microsoft.AspNetCore.Mvc
open Microsoft.Extensions.Logging
open FirstIonideProject.Domain
open FirstIonideProject.Filters

[<Produces("application/json")>]
[<ApiController>]
[<Auth>] // Self made check for key authorization
[<Route("[controller]")>]
[<ProducesResponseType(200)>]
[<ProducesResponseType(401)>]
[<ProducesResponseType(404)>]
/// <summary>
/// Return Cluster association either by name or ID
/// </summary>
type ClusterAssocController(logger: ILogger<ClusterAssocController>) =
    inherit ControllerBase()
    
    ///<summary>
    /// Retrieves a specific node association to the cluster by unique id
    ///</summary>
    ///<remarks>Awesomeness!</remarks>
    ///<param name="id" example="123">The product id</param>
    [<HttpGet("id/{id}")>]
    member _.GetID(id: int) =
        let rng = id
        rng

    ///<summary>
    /// Retrieves a specific node association to the cluster by unique id
    ///</summary>
    ///<remarks>Awesomeness!</remarks>
    ///<param name="name" example="123">The product name</param>
    [<HttpGet("name/{name}")>]
    member _.GetName(name: string) =
        let rng = name
        rng
