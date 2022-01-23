//Exercise 3: Go Basics: Structs and Pointers
//Student Mirage
package main

import "fmt"

//Structure Person
type Person struct {
	lastName  string
	firstName string
	iD        int
}

func inPerson(p *Person, lastiD int) (nextiD int, err error) {
	nextiD = lastiD
	//Enter The Person Last Name
	fmt.Println("Last name: ")
	_, err = fmt.Scanf("%s\n", &p.lastName)
	if err != nil {
		return
	}

	//Enter The First Name
	fmt.Println("First name: ")
	_, err = fmt.Scanf("%s\n", &p.firstName)
	if err != nil {
		return
	}

	nextiD += 1
	p.iD = nextiD
	return

}

func printPerson(p Person) {
	fmt.Printf("%10.d\t%s\t%s\n", p.iD, p.firstName, p.lastName)
}

func main() {
	nextId := 101
	for {
		var (
			p   Person
			err error
		)
		nextId, err = inPerson(&p, nextId)
		if err != nil {
			fmt.Println("Invalid entry ... exiting")
			break
		}
		printPerson(p)
	}
}
