package main

import (
	"flag"
	"fmt"
	"log"
	"os"
	"regexp"
	"strconv"
	"time"

	expect "github.com/google/goexpect"
	"github.com/google/goterm/term"
)

const (
	timeout = 10 * time.Minute
)

var (
	cid   = flag.String("cid", "", "cid")     // QmQagJpZKcxfDUQaH5a5WWPajqdWiX2fJyEQaQ6Tyu9nsx
	miner = flag.String("miner", "", "miner") // f023013

	dataCidRE  = regexp.MustCompile("Data CID .*:")
	durationRE = regexp.MustCompile("Deal duration .*:")
	minerRE    = regexp.MustCompile("Miner Address .*:")
	acceptRE   = regexp.MustCompile("Accept .*:")
	priceRE    = regexp.MustCompile("Total price: ~([0-9.]+) FIL")
)

// go run . -cid=QmQagJpZKcxfDUQaH5a5WWPajqdWiX2fJyEQaQ6Tyu9nsx -miner=f023013

func main() {
	flag.Parse()
	fmt.Println(term.Bluef("Lotus deal-tool"))
	fmt.Println("CID:", *cid)
	fmt.Println("Miner:", *miner)

	e, _, err := expect.Spawn("lotus client deal", -1, expect.Verbose(true),
		expect.VerboseWriter(os.Stdout))
	if err != nil {
		log.Fatal(err)
	}
	defer e.Close()

	e.Expect(dataCidRE, timeout)
	e.Send(*cid + "\n")
	e.Expect(durationRE, timeout)
	e.Send("180\n")
	e.Expect(minerRE, timeout)
	e.Send(*miner + "\n")
	result, _, _ := e.Expect(acceptRE, timeout)
	/*
		e.Send(*user + "\n")
		e.Expect(passRE, timeout)
		e.Send(*pass + "\n")
		e.Expect(promptRE, timeout)
		e.Send(*cmd + "\n")
		result, _, _ := e.Expect(promptRE, timeout)
		e.Send("exit\n")

		fmt.Println(term.Greenf("%s: result: %s\n", *cmd, result))
	*/
	fmt.Println(term.Greenf("result: %s\n", result))
	price, err := strconv.ParseFloat(priceRE.FindStringSubmatch(result)[1], 32)
	fmt.Printf("Price: %v\n", price)
	if price <= 0.05 {
		e.Send("yes\n")
	} else {
		e.Send("no\n")
	}
	finalOutput, _, _ := e.Expect(acceptRE, timeout)
	fmt.Println(term.Greenf("final output: %s\n", finalOutput))
	if price > 0.05 {
		os.Exit(1)
	}
}
