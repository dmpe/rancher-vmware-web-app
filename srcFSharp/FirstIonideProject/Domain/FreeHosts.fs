namespace FirstIonideProject.Domain

open System
open System.Collections.Generic
open MySqlConnector

type FreeHosts =
    struct
      val host_id: int
      val host_name: string

      new(host_id, host_name) = { host_id = host_id; host_name = host_name }
    end
    
    
    member this.returnFreeHosts(myCon: MySqlConnection) =
        let ls = List<FreeHosts>()
        myCon.Open()
        Console.Write("Starting DB Query")
        let cmd = new MySqlCommand("SELECT host_id, host_name FROM api.free_hostnames LIMIT @num;", myCon)
        cmd.Parameters.AddWithValue("@num", this.host_id) |> ignore
        using (cmd.ExecuteReader()) (fun reader ->
            while reader.Read() do
                ls.Add(FreeHosts(Convert.ToInt32(reader.["host_id"]), reader.["host_name"].ToString()))
        )           
        ls
