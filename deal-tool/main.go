package main

import (
	"flag"
	"fmt"
  "io/ioutil"
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
	dealfile = flag.String("dealfile", "", "dealfile") // f023013

	dataCidRE  = regexp.MustCompile("Data CID .*:")
	durationRE = regexp.MustCompile("Deal duration .*:")
	minerRE    = regexp.MustCompile("Miner Address .*:")
	acceptRE   = regexp.MustCompile("Accept .*:")
	priceRE    = regexp.MustCompile("Total price: ~([0-9.]+) FIL")
	finalResultRE    = regexp.MustCompile("Final result .*") // Bogus match
	dealCidRE    = regexp.MustCompile("Deal CID:.*(bafy.*)\x1b")
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
	finalResult, _, _ := e.Expect(finalResultRE, timeout)
	fmt.Println(term.Greenf("Final result: %s\n", finalResult))
	if price > 0.05 {
		os.Exit(1)
	}
	dealCID := dealCidRE.FindStringSubmatch(finalResult)[1] + "\n"
	fmt.Println(term.Greenf("Deal CID: %s\n", dealCID))
  err = ioutil.WriteFile(*dealfile, []byte(dealCID), 0644)
	if err != nil {
		log.Fatal(err)
	}
  fmt.Printf("Wrote %v to %v\n", dealCID, *dealfile)
}
