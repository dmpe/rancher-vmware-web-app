namespace FirstIonideProject.Infra

open System
open MySqlConnector

type public MariaDBADO(dbConS: string) =

    // https://fsharpforfunandprofit.com/posts/classes/
    // immutable
    member this.dbCon =
        new MySqlConnection(dbConS)

    interface IDisposable with

        member this.Dispose() =
            this.dbCon.Close()
