package main

import (
	"bufio"
	"fmt"
	"log"
	"net/http"
	"os"
	"strings"
)

var defaultAddress string = "localhost"
var defaultPort string = "8321"
var address string
var htmlTemplate = `<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mods Updater Server</title>
</head>
<body>
    <h1>Backend for MMU(Minecraft Mods Updater)</h1>
    <p>To download mods manually, open http://this-server-ip:port/mods.zip</p>
	<p>Put your mods to html folder in archive mods.zip (!!.zip!!)
</body>
</html>`

func main() {

	makeFilesystem()
	addr, err := readServerConfig("conf/server.conf")
	if err != nil {
		log.Fatal(err)
	} else {
		address = addr
	}
	startHttpServer()
}

func startHttpServer() {
	// http.HandleFunc("/index/", handleIndex)
	// http.HandleFunc("/mods/", handleMods)

	fmt.Println("Server listening on", address, "...")
	http.ListenAndServe(defaultAddress+":"+defaultPort, http.FileServer(http.Dir("./html")))

}

func makeFilesystem() {
	if checkIfExist("html") {
		fmt.Printf("Directory html exist\n")
		if checkIfExist("html/index.html") {
			fmt.Printf("file index.html exist.\n")
		} else {
			fmt.Printf("file index.html not exist, creating...\n")
			file, err := os.Create("html/index.html")
			if err != nil {
				log.Fatal(err)
			} else {
				fmt.Printf("writing template to file...\n")
				file.Write([]byte(htmlTemplate))
			}
		}
	} else {
		fmt.Printf("dir html not exist,creating...\n")
		os.Mkdir("html", 0700)
		if checkIfExist("html/index.html") {
			fmt.Printf("file index.html exist\n")
		} else {
			fmt.Printf("file index.html not exist, creating...\n")
			file, err := os.Create("html/index.html")
			if err != nil {
				log.Fatal(err)
			} else {
				fmt.Printf("writing template to file...\n")
				file.Write([]byte(htmlTemplate))
				file.Close()
			}

		}
	}
	if checkIfExist("conf") {
		if checkIfExist("conf/server.conf") {
		} else {
			fmt.Printf("file server.conf not exist, creating...\n")
			file, err := os.Create("conf/server.conf")
			if err != nil {
				log.Fatal(err)
			} else {
				file.WriteString(defaultAddress + "\n")
				file.WriteString(defaultPort)
			}
		}
	} else {
		os.Mkdir("conf", 0700)
		if checkIfExist("conf/server.conf") {
		} else {
			fmt.Printf("file server.conf not exist, creating...\n")
			file, err := os.Create("conf/server.conf")
			if err != nil {
				log.Fatal(err)
			} else {
				file.WriteString(defaultAddress + "\n")
				file.WriteString(defaultPort)
			}
		}
	}
}

func readServerConfig(filename string) (string, error) {
	file, err := os.Open(filename)
	if err != nil {
		return "", err
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	var lines []string

	for scanner.Scan() {
		lines = append(lines, scanner.Text())
	}

	if err := scanner.Err(); err != nil {
		return "", err
	}

	if len(lines) != 2 {
		return "", fmt.Errorf("server.conf should contain exactly two lines")
	}

	ip := strings.TrimSpace(lines[0])
	port := strings.TrimSpace(lines[1])

	return fmt.Sprintf("%s:%s", ip, port), nil
}

func checkIfExist(path string) (ifExist bool) {
	if _, err := os.Stat(path); !os.IsNotExist(err) {
		return true
	} else {
		return false
	}
}

// func handleIndex(w http.ResponseWriter, r *http.Request) {
// 	http.ServeFile(w, r, "index.html")
// }

// func handleMods(w http.ResponseWriter, r *http.Request) {
// 	http.ServeFile(w, r, "mods.zip")
// }
