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

type Config struct {
	SecurityToken string `json:"security_token"`
	Ip            string `json:"ip"`
	Port          string `json:"port"`
}

func main() {
	config, configErr := loadConfig()
	if configErr != nil {
		fmt.Println("Error while loading configuration file")
		return
	}

	r := fiber.New()
	r.Get("/pull", func(c *fiber.Ctx) error {
		if c.Get("Security-Token") != config.SecurityToken {
			return c.SendStatus(401)
		}

		content, fileErr := os.ReadFile("noobdocs.json")
		var objmap map[string]Documents
		if fileErr != nil {
			fmt.Println(fileErr)
			return c.SendStatus(500)
		}

		marshalErr := json.Unmarshal(content, &objmap)
		if marshalErr != nil {
			fmt.Println(marshalErr)
			return c.SendStatus(500)
		}

		return c.JSON(fiber.Map{
			"documents": objmap,
		})
	})
	r.Post("/push", func(c *fiber.Ctx) error {
		if c.Get("Security-Token") != config.SecurityToken {
			return c.SendStatus(401)
		}

		var bodyString = string(c.Body())
		file, err := os.Create("noobdocs.json")
		if err != nil {
			fmt.Println(err)
			return c.SendStatus(500)
		}
		defer file.Close()
		file.WriteString(bodyString)

		return c.SendStatus(200)
	})

	err := r.Listen(config.Ip + ":" + config.Port)
	fmt.Println(err)
}

func loadConfig() (*Config, error) {
	var config = new(Config)
	content, fileErr := os.ReadFile("config.json")
	if fileErr != nil {
		fmt.Println(fileErr)
		return nil, fileErr
	}
	jsonMarshallErr := json.Unmarshal(content, &config)
	if jsonMarshallErr != nil {
		fmt.Println(jsonMarshallErr)
		return nil, jsonMarshallErr
	}
	return config, nil
}
