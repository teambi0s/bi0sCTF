package main

import (
	"log"
	"net/http"
	"strconv"
	"time"
)

const (
	SERVER_IP = ""
)

func logReq(w http.ResponseWriter, r *http.Request) {
	query := r.URL.Query()
	for key, value := range query {
		log.Printf("%s: %s\n", key, value)
	}
	w.Write([]byte("OK"))
}

func block(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "text/html")
	http.ServeFile(w, r, "index.html")
}

func sleep(w http.ResponseWriter, r *http.Request) {
	time.Sleep(24 * time.Hour * 365)
}

func handleRequests() {
	http.HandleFunc("/block", block)
	http.HandleFunc("/sleep", sleep)
	http.HandleFunc("/log", logReq)

	for i := 1; i <= 256; i++ {
		go http.ListenAndServe(":"+strconv.Itoa(28000+i), nil)
	}
	log.Fatal(http.ListenAndServe(":28000", nil))
}

func main() {
	handleRequests()
}
