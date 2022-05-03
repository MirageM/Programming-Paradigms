// Assignment 1 Caesar Cipher
// Question 1
// Winter 2022
// Mirage Mohammad
// 300080185
// Golang
package main

import (
	"fmt"
	"strings"
)

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

	fmt.Println("--- Question 1 --- \n")
	fmt.Println(CaesarCipher("I love CS!", 5))
	/*
			Write the CaesarCipher(m string, shift int) string function that accepts a
			message and returns the encrypted message. [6]
			fmt.Println(CaesarCipher("I love CS!", 5))
		 	NQTAJHX
	*/
}
