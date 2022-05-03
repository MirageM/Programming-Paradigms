// Project CSI2120/CSI2520
// Comprehension Assignment Go (My Map)
// Winter 2022
// Mirage Mohammad
// 300080185
// Golang

package main

import (
	"encoding/csv"
	"fmt"
	"io"
	"math"
	"os"
	"runtime"
	"strconv"
	"sync"
	"time"
)

type GPScoord struct {
	lat  float64
	long float64
}

type LabelledGPScoord struct {
	GPScoord
	ID    int // point ID
	Label int // cluster ID
}

//Job
type Job struct {
	slice   []LabelledGPScoord
	minPts  int
	epsilon float64
	offset  int
}

/*
N=2 and 4 consumer threads
N=4 and 4 consumer threads
N=4 and 10 consumer threads
N=10 and 4 consumer threads
N=10 and 10 consumer threads
N=10 and 50 consumer threads
N=20 and 10 consumer threads
N=20 and 50 consumer threads
N=20 and 200 consumer threads
*/
//const C int = 2

const numberOfPartitions int = 20 //N
const numberOfConsumers int = 10  //C
const MinPts int = 5
const eps float64 = 0.0003
const filename string = "yellow_tripdata_2009-01-15_9h_21h_clean.csv"

//DBscan and Concurrency
//Main execution
func main() {

	start := time.Now()

	gps, minPt, maxPt := readCSVFile(filename)
	fmt.Printf("Number of points: %d\n", len(gps))

	minPt = GPScoord{40.7, -74.}
	maxPt = GPScoord{40.8, -73.93}

	// geographical limits
	fmt.Printf("SW:(%f , %f)\n", minPt.lat, minPt.long)
	fmt.Printf("NE:(%f , %f) \n\n", maxPt.lat, maxPt.long)

	// Parallel DBSCAN STEP 1.
	incx := (maxPt.long - minPt.long) / float64(numberOfPartitions)
	incy := (maxPt.lat - minPt.lat) / float64(numberOfPartitions)

	var grid [numberOfPartitions][numberOfPartitions][]LabelledGPScoord // a grid of GPScoord slices

	// Create the partition
	// triple loop! not very efficient, but easier to understand

	partitionSize := 0
	for j := 0; j < numberOfPartitions; j++ {
		for i := 0; i < numberOfPartitions; i++ {

			for _, pt := range gps {

				// is it inside the expanded grid cell
				if (pt.long >= minPt.long+float64(i)*incx-eps) && (pt.long < minPt.long+float64(i+1)*incx+eps) && (pt.lat >= minPt.lat+float64(j)*incy-eps) && (pt.lat < minPt.lat+float64(j+1)*incy+eps) {

					grid[i][j] = append(grid[i][j], pt) // add the point to this slide
					partitionSize++
				}
			}
		}
	}

	// ***
	// This is the non-concurrent procedural version
	// It should be replaced by a producer thread that produces jobs (partition to be clustered)
	// And by consumer threads that clusters partitions

	// Parallel DBSCAN STEP 2.
	// Apply DBSCAN on each partition
	//Send jobs to a channel

	jobThreads := make(chan Job)

	//Mutex synchronization
	var mutexLock sync.WaitGroup
	mutexLock.Add(numberOfConsumers)

	for i := 1; i <= numberOfConsumers; i++ {
		go producerConsumer(jobThreads, &mutexLock)
	}

	for j := 0; j < numberOfPartitions; j++ {
		for i := 0; i < numberOfPartitions; i++ {
			//assuming there are less than 1000 000 clusters per partition
			jobThreads <- Job{grid[i][j], MinPts, eps, i*10000000 + j*1000000}
		}
	}
	close(jobThreads)

	//wait for consumer threads to finish terminating
	mutexLock.Wait()
	// Parallel DBSCAN step 3.
	// merge clusters
	// *DO NOT PROGRAM THIS STEP

	end := time.Now()
	fmt.Printf("\nExecution time: %s of %d points\n", end.Sub(start), partitionSize)
	fmt.Printf("Number of CPUs: %d", runtime.NumCPU())
	fmt.Println(" ")

}

//function consumes where one consumer is done with one job
func producerConsumer(jobThreads chan Job, done *sync.WaitGroup) {
	for {
		i, next := <-jobThreads
		//once one job is done the consumer goes to the next job
		if next {
			DBscan(i.slice, i.minPts, i.epsilon, i.offset)
		} else {
			done.Done()
			return
		}
	}
}

func calculateDistance(point1 LabelledGPScoord, point2 LabelledGPScoord) float64 {
	deltaLatitude := point2.GPScoord.lat - point1.GPScoord.lat
	deltaLongitude := point2.GPScoord.long - point1.GPScoord.long
	var result float64 = math.Sqrt(math.Pow(deltaLatitude, 2) + math.Pow(deltaLongitude, 2))
	return result
}

//Scans for the points in the database and computes the distance and checks the epsilon
func RangeQuery(coords []LabelledGPScoord, q *LabelledGPScoord, epsilon float64) (neighboursPts []LabelledGPScoord) {
	//make(type, length, capacity)

	// parallel loop

	for i, _ := range coords {
		curr := &(coords[i])
		if calculateDistance(*curr, *q) <= epsilon {
			neighboursPts = append(neighboursPts, *curr)
		}
	}
	return neighboursPts
}

// Applies DBSCAN algorithm on LabelledGPScoord points
// LabelledGPScoord: the slice of LabelledGPScoord points
// MinPts, eps: parameters for the DBSCAN algorithm
// offset: label of first cluster (also used to identify the cluster)
// returns number of clusters found
func DBscan(coords []LabelledGPScoord, MinPts int, eps float64, offset int) (nclusters int) {
	//maps the data into overlapping partitions
	nclusters = 0       //cluster counter
	clusterID := offset //cluster id

	myCoordinationMap := make(map[int]int) //traces all indexes of all the coordinate points
	for i, pt := range coords {
		myCoordinationMap[pt.ID] = i
	}

	for i := 0; i < len(coords); i++ {
		//retreiving the current record
		var currentRecord = &(coords[i])
		//finds the neighbours and calls the rangequery function
		var myNeighbours []LabelledGPScoord = RangeQuery(coords, currentRecord, eps)
		if len(myNeighbours) < MinPts {
			currentRecord.Label = -1
			continue
		}

		if currentRecord.Label != 0 {
			continue
		}

		nclusters = nclusters + 1
		clusterID = clusterID + 1
		currentRecord.Label = clusterID

		//Initializing seed set
		seedSet := make([]LabelledGPScoord, len(myNeighbours), len(myNeighbours))
		//processing the seeds
		for _, mPt := range myNeighbours {
			if mPt.ID == currentRecord.ID {
				continue
			}
			seedSet = append(seedSet, mPt)
		}

		//iterating through each seed set
		for j := 0; j < len(seedSet); j++ {
			q := &(seedSet[j])
			if q.Label == -1 {
				q.Label = clusterID
				coords[myCoordinationMap[q.ID]].Label = clusterID
			}
			if q.Label != 0 {
				continue
			}
			//merges two clusers since one cluster can cover more than one partition
			q.Label = clusterID
			coords[myCoordinationMap[q.ID]].Label = clusterID
			pointQNeighbours := RangeQuery(coords, q, eps)
			if len(pointQNeighbours) >= MinPts {
				//union for the set seed
				unionSeed := make(map[LabelledGPScoord]bool)

				for _, nPt := range seedSet {
					unionSeed[nPt] = true
				}

				for _, nPt := range pointQNeighbours {
					_, exist := unionSeed[nPt]
					if !exist {
						seedSet = append(seedSet, nPt)
					}
				}
			}
		}
	}

	// End of DBscan function
	// Printing the result (do not remove)
	fmt.Printf("Partition %10d : [%4d,%6d]\n", offset, nclusters, len(coords))

	return nclusters
}

// reads a csv file of trip records and returns a slice of the LabelledGPScoord of the pickup locations
// and the minimum and maximum GPS coordinates
func readCSVFile(filename string) (coords []LabelledGPScoord, minPt GPScoord, maxPt GPScoord) {

	coords = make([]LabelledGPScoord, 0, 5000)

	// open csv file
	src, err := os.Open(filename)
	defer src.Close()
	if err != nil {
		panic("File not found...")
	}

	// read and skip first line
	r := csv.NewReader(src)
	record, err := r.Read()
	if err != nil {
		panic("Empty file...")
	}

	minPt.long = 1000000.
	minPt.lat = 1000000.
	maxPt.long = -1000000.
	maxPt.lat = -1000000.

	var n int = 0

	for {
		// read line
		record, err = r.Read()

		// end of file?
		if err == io.EOF {
			break
		}

		if err != nil {
			panic("Invalid file format...")
		}

		// get lattitude
		lat, err := strconv.ParseFloat(record[9], 64)
		if err != nil {
			panic("Data format error (lat)...")
		}

		// is corner point?
		if lat > maxPt.lat {
			maxPt.lat = lat
		}
		if lat < minPt.lat {
			minPt.lat = lat
		}

		// get longitude
		long, err := strconv.ParseFloat(record[8], 64)
		if err != nil {
			panic("Data format error (long)...")
		}

		// is corner point?
		if long > maxPt.long {
			maxPt.long = long
		}

		if long < minPt.long {
			minPt.long = long
		}

		// add point to the slice
		n++
		pt := GPScoord{lat, long}
		coords = append(coords, LabelledGPScoord{pt, n, 0})
	}

	return coords, minPt, maxPt
}
