package main

import (
    "github.com/samalba/dockerclient"
    "github.com/ant0ine/go-json-rest/rest"
    "net/http"
    "log"
    "os"
    "os/signal"
    "syscall"
)

// Log callback for dockerclient
func eventCallback(e *dockerclient.Event, ec chan error, args ...interface{}) {
    log.Println(e)
}

var (
    docker *dockerclient.DockerClient
)

func waitForInterrupt() {
    sigChan := make(chan os.Signal, 1)
    signal.Notify(sigChan, os.Interrupt, syscall.SIGTERM, syscall.SIGQUIT)
    for _ = range sigChan {
        docker.StopAllMonitorEvents()
        os.Exit(0)
    }
}

func main() {
    //
    // Connect to docker
    //
    //dockercli, err := dockerclient.NewDockerClient(os.Getenv("DOCKER_HOST"), nil)
    dockercli, err := dockerclient.NewDockerClient("unix:///var/run/docker.sock", nil)
    if err != nil {
        log.Fatal(err)
    }
    docker = dockercli
    docker.StartMonitorEvents(eventCallback, nil)
    //waitForInterrupt()

    api := rest.NewApi()
    api.Use(rest.DefaultDevStack...)

    //
    // API Routes
    //
    router, err := rest.MakeRouter(
        rest.Get("/docker", func(w rest.ResponseWriter, req *rest.Request) {
            //w.WriteJson(map[string]string{"Body": "Hello World!"})
            w.WriteJson(map[string]string{"Body": "Hello World!"})
        }),
    )
    if err != nil {
            log.Fatal(err)
    }
    api.SetApp(router)

    //
    // Serve and process callbacks 
    //
    http.Handle("/api/", http.StripPrefix("/api", api.MakeHandler()))
    http.Handle("/static/", http.StripPrefix("/static", http.FileServer(http.Dir("."))))
    log.Fatal(http.ListenAndServe(":8080", api.MakeHandler()))
}
