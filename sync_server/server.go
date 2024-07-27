package main

import (
	"encoding/json"
	"fmt"
	"os"

	"github.com/gofiber/fiber/v2"
)

type Documents struct {
	Contents           string `json:"contents"`
	Title              string `json:"title"`
	Hash               string `json:"hash"`
	TimeOfModification string `json:"time_of_modification"`
}

func main() {
	r := fiber.New()
	r.Get("/pull", func(c *fiber.Ctx) error {
		content, fileErr := os.ReadFile("noobdocs.json")
		var objmap map[string]Documents
		if fileErr != nil {
			fmt.Println(fileErr)
		}
		marshalErr := json.Unmarshal(content, &objmap)
		if marshalErr != nil {
			fmt.Println(marshalErr)
		}
		return c.JSON(fiber.Map{
			"documents": objmap,
		})
	})
	r.Post("/push", func(c *fiber.Ctx) error {
		var bodyString = string(c.Body())
		file, err := os.Create("noobdocs.json")
		if err != nil {
			fmt.Println(err)
		}
		defer file.Close()
		file.WriteString(bodyString)

		return c.SendString("Database received")
	})

	err := r.Listen("192.168.1.78:8567")
	fmt.Println(err)
}
