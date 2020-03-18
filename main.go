package main

//go:generate sqlboiler --wipe psql

import (
	"context"
	"database/sql"
	"fmt"
	_ "github.com/lib/pq"
	"github.com/ustrugany/sqlboiler/models"
	"github.com/volatiletech/sqlboiler/boil"
	"github.com/volatiletech/sqlboiler/queries/qm"
	"log"
	"os"
)

func oldSchool(ctx context.Context, db *sql.DB) {
	rows, err := db.QueryContext(ctx, "select name from pilots")
	if err != nil {
		log.Fatal(err)
	}
	defer rows.Close()
	names := make([]string, 0)
	for rows.Next() {
		var name string
		if err := rows.Scan(&name); err != nil {
			// Check for a scan error.
			// Query rows will be closed with defer.
			log.Fatal(err)
		}
		names = append(names, name)
	}

	fmt.Printf("%v \n", names)
}

// doc https://github.com/volatiletech/sqlboiler#insert
func main() {
	ctx := context.Background()
	db, err := sql.Open(
	"postgres",
		fmt.Sprintf(
		`dbname=%s host=%s user=%s password=%s sslmode=%s`,
			os.Getenv("APP_POSTGRES_DB"),
			os.Getenv("APP_POSTGRES_HOST"),
			os.Getenv("APP_POSTGRES_USER"),
			os.Getenv("APP_POSTGRES_PASSWORD"),
			os.Getenv("APP_POSTGRES_SSLMODE"),
		),
	)
	if err != nil {
		panic(err)
	}

	err = db.Ping()
	if err != nil {
		panic(err)
	}

	oldSchool(ctx, db)

	p := &models.Pilot{ID: 5, Name:"Krzysiek"}
	err = p.Insert(ctx, db, boil.Infer())
	if err != nil {
		//panic(err)
	}
	fmt.Printf("%v \n", p)

	p, err = models.Pilots().One(ctx, db)
	if err != nil {
		panic(err)
	}
	fmt.Printf("%v \n", p)

	found, err := models.FindPilot(ctx, db, 3)
	if err != nil {
		panic(err)
	}
	fmt.Printf("%v \n", found)

	found.Name = "Kamil"
	count, err := found.Update(ctx, db, boil.Whitelist(models.PilotColumns.Name))
	if err != nil {
		panic(err)
	}
	fmt.Printf("%v updated \n", count)

	foundAgain, err := models.Pilots(qm.Where("name = ?", found.Name)).One(ctx, db)
	if err != nil {
		panic(err)
	}
	fmt.Printf("%v \n", foundAgain)

	foundAgainLanguages, err := foundAgain.Languages().All(ctx, db)
	if err != nil {
		panic(err)
	}

	for _, language := range foundAgainLanguages {
		fmt.Printf("%v \n", language)
	}
}