//Exercise 4 Maps
//Student Mirage

package main

import "fmt"

//Suitable structure for the course
type Course struct {
	NStudents int
	Professor string
	Avg       float64
}

func main() {
	//Dynamic mapping
	m := make(map[string]Course)
	m["CSI2110"] = Course{186, "Lang", 79.5}
	m["CSI2120"] = Course{211, "Moura", 81.0}

	for k, v := range m {
		fmt.Printf("Course Code: %s\n", k)
		fmt.Printf("Number of students: %d\n", v.NStudents)
		fmt.Printf("Professor: %s\n", v.Professor)
		fmt.Printf("Average: %f\n\n", v.Avg)

	}

}
