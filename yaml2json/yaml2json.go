package main

import (
	"fmt"
	"github.com/ghodss/yaml"
	"io/ioutil"
	"log"
	"os"
)

func main() {
	log.SetFlags(log.LstdFlags | log.Lshortfile)
	file := os.Args[1]
	dat, err := ioutil.ReadFile(file)
	if err != nil {
		log.Fatal(err)
	}

	json, err := yaml.YAMLToJSON(dat)
	if err != nil {
		log.Fatal(err)
	}
	fmt.Print(string(json))
}
