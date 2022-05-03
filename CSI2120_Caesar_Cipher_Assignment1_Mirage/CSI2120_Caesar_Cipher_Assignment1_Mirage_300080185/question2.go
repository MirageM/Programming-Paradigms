// Assignment 1 Caesar Cipher
// Question 2
// Winter 2022
// Mirage Mohammad
// 300080185
// Golang
package main

import (
	"fmt"
	"strings"
)

//CaesarCipherList shifts each letter of the messages
//Shifting original message to a later letter in the alphabet
//All the messages get encrypted and each letter is send into a channel
func CaesarCipherList(messages []string, shift int, ch chan string) {
	//Iterates each message
	for _, message := range messages {
		//Stores the encrypted message in the channel
		ch <- CaesarCipher(message, shift)
	}

}

//CaesarCipher is an ancient crytographic scheme
//The function takes in a message and shifts each letter while encrypting the message
func CaesarCipher(message string, shift int) string {
	//Consumes string (message) and a natural number (shift) that is less than 26
	//Takes each byte
	sliceResult := make([]byte, 0)
	//Converts message to all upper case letters
	message = strings.ToUpper(message)

	for i := 0; i < len(message); i++ {
		//Checks if the current character in the alphabet between A and Z using Ascii
		if 'A' <= message[i] && 'Z' >= message[i] {
			//encrypts the current character
			currEncryptedChar := ((int(message[i])+shift-65)%26 + 65)
			//Appends the encrypted byte into the slice
			sliceResult = append(sliceResult, byte(currEncryptedChar))
		}
	}
	//Returns the slice
	return string(sliceResult)
}

//Main function
func main() {
	// List of messages
	messages := []string{"Csi2520", "Csi2120", "3 Paradigms",
		"Go is 1st", "Prolog is 2nd", "Scheme is 3rd",
		"uottawa.ca", "csi/elg/ceg/seg", "800 King Edward"}
	// Creates a channel of string slices
	ch := make(chan string, len(messages))

	//Calls the go function CaesarCipherList
	//Uses a concurrent function to process a list of messages
	go CaesarCipherList(messages[:], 2, ch) // send channels
	fmt.Println("--- Question 2 --- \n")
	fmt.Println("Le résultat produit devrait être comme suit :\nThe result will look as follows : \n ")
	//Synchronization
	for i := 0; i < len(messages); i++ {
		//<- operator passes the value from a channel to a reference
		value, _ := <-ch
		fmt.Println(value) //Prints the value after goroutine is done
	}
	fmt.Println(" ")
	/*
		The result will look as follows:
		EUK
		EUK
		RCTCFKIOU
		IQKUUV
		RTQNQIKUPF
		UEJGOGKUTF
		WQVVCYCEC
		EUKGNIEGIUGI
		MKPIGFYCTF
	*/
}
