namespace FirstIonideProject.Controllers

open System.Runtime.InteropServices
open FirstIonideProject.Infra
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
/// Return free host VMs that can be created next
/// </summary>
type FreeHostsController(logger: ILogger<FreeHostsController>, db: MariaDBADO) =
    inherit ControllerBase()
    let db1 = db

    member this.Log = logger

    
    ///<summary>
    /// Return list of free host(s).
    ///</summary>
    ///<param name="no">Number of free hosts to return</param>
    ///<return>Array of free host objects</return>
    [<HttpGet("{no}")>]
    member _.Get([<Optional; DefaultParameterValue(1)>] no: int) =
        let hos = FreeHosts(no, "str")
        let lsOfHos= hos.returnFreeHosts(db1.dbCon)
        lsOfHos
   