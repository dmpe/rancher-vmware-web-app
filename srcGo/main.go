package main

import (
    "io"
    "log"
    "net/http"
	"database/sql"
	"time"

	_ "github.com/go-sql-driver/mysql"
	# https://gitlab.com/qosenergy/squalus
)

func main() {



}

# https://echo.labstack.com/

func db_con() {

	db, err := sql.Open("mysql", "jm:benz@mariadb.default.svc.cluster.local:3306/api")
	if err != nil {
		panic(err)
	}
}
