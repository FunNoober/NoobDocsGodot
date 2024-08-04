package main

import (
	"crypto/sha256"
	"encoding/base64"
	"encoding/json"
	"fmt"
	"os"
	"strconv"
	"time"

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

type Metadata struct {
	MostRecentPush string   `json:"most_recent_push"`
	ListOfPushes   []string `json:"list_of_pushes"`
}

func main() {
	config, configErr := loadConfig()
	if configErr != nil {
		fmt.Println("Error while loading configuration file")
		return
	}
	metadata, metadataErr := loadMetadata()
	if metadataErr != nil {
		fmt.Println("Fatal error occurred while loading")
		return
	}

	r := fiber.New()
	r.Get("/pull", func(c *fiber.Ctx) error {
		if c.Get("Security-Token") != config.SecurityToken {
			return c.SendStatus(401)
		}

		content, fileErr := os.ReadFile("./documents/" + metadata.MostRecentPush + "_noobdocs.json")
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
		var curTime string = generateTimeHash()
		if _, err := os.Stat("documents"); os.IsNotExist(err) {
			mkdirErr := os.Mkdir("documents", 0666)
			if mkdirErr != nil {
				fmt.Println(mkdirErr)
				return c.SendStatus(500)
			}
		}
		file, err := os.Create("./documents/" + curTime + "_noobdocs.json")
		metadata.MostRecentPush = curTime
		metadata.ListOfPushes = append(metadata.ListOfPushes, curTime)
		saveMetadata(metadata)
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

func loadMetadata() (*Metadata, error) {
	var metadata = new(Metadata)
	content, fileErr := os.ReadFile("metadata.json")
	if fileErr != nil {
		var jsonString, _ = json.Marshal(metadata)
		os.WriteFile("metadata.json", jsonString, 0666)
		content, fileErr = os.ReadFile("metadata.json")
		if fileErr != nil {
			return nil, fileErr
		}
	}
	jsonMarshallErr := json.Unmarshal([]byte(string(content)), &metadata)
	if jsonMarshallErr != nil {
		fmt.Println(jsonMarshallErr)
		return nil, jsonMarshallErr
	}
	return metadata, nil
}

func saveMetadata(metadata *Metadata) {
	var jsonString, _ = json.Marshal(metadata)
	var err = os.WriteFile("metadata.json", jsonString, 0666)
	if err != nil {
		fmt.Println(err)
	}
}

func getUnixTimeAsInt() int {
	var current_time = time.Now().Unix()
	return int(current_time)
}

func generateTimeHash() string {
	var hasher = sha256.New()
	var current_time int = getUnixTimeAsInt()
	hasher.Write([]byte(string(strconv.Itoa(current_time))))
	var hash = base64.URLEncoding.EncodeToString(hasher.Sum(nil))
	return string(hash)
}
