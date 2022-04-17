//Exercise 1: Basic Methods
//Mirage
package main

import (
	"fmt"
)

type dog struct {
	name   string
	race   string
	female bool
}

func (d *dog) rename(nn string) {
	d.name = nn
	return
}

func (d *dog) print() {
	fem := "female"
	if !d.female {
		fem = "male"
	}
	fmt.Printf("Dog %s is a %s and %s.\n",
		d.name, d.race, fem)
	return
}

func main() {
	fido := dog{"Fido", "Poodle", false}
	fido.print()
	fido.rename("Cocotte")
	fido.print()
	fido = dog{"Husky", "Husky", true}
	fido.print()
}
