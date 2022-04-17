//Exercise 2: Go Channel Basics
//Mirage

package main

import (
	"fmt"
	"strconv"
	"time"
)

var i int

//Declaring channel
func makeCakeAndSend(cs chan string) {
	i = i + 1
	cakeName := "Strawberry Cake " + strconv.Itoa(i)
	fmt.Println("Make a cake and sending ...", cakeName)
	cs <- cakeName //Sending a strawberry cake

}

//Declaring channel
func receiveCakeAndPack(cs chan string) {
	s := <-cs //get whatever cake is on the channel
	fmt.Println("Packing received cake: ", s)
}

func main() {
	cs := make(chan string)
	for i := 0; i < 3; i++ {
		go makeCakeAndSend(cs)
		go receiveCakeAndPack(cs)

		//Sleep for a while so that program doen't exit
		//immediately and output

		time.Sleep(1 * 1e9)
	}
}
