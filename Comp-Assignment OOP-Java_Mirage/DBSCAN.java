/*
    (Header)
    Assignment 1 Part 1
    Course Code: CSI2120 (Programming Paradigms)
    Student Name: Mirage Mohammad
    Student Number: 300080185
    I have used the DBSCAN algorithm from this powerpoint located on slide 12
    Author name of the DBScan algorithm : Jing Gao
    Reference: https://cse.buffalo.edu/~jing/cse601/fa13/materials/clustering_density.pdf
    I also have made used of the pseucode given in the instructions of assignment 1

 */

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class DBSCAN {

    private int minPts;
    private double eps;

    public DBSCAN(int minPts, double eps){
        this.minPts = minPts;
        this.eps = eps;
    }
    //Imports the excel file (yellow_tripdata_2009-01-15_1hour_clean.csv or any other csv files)
    public List<GPSCoord> importCSVFile(String fileName) throws IOException{
        List<GPSCoord> voyages = new ArrayList<GPSCoord>();
        BufferedReader  bufferedReader = new BufferedReader(new FileReader(fileName));
        bufferedReader.readLine();
        String lines_rows;

        //checks if each line is not equal to null
        while((lines_rows = bufferedReader.readLine())!= null){
            String[] data = lines_rows.split(",");
            voyages.add(new GPSCoord(Double.valueOf(data[9]), Double.valueOf(data[8])));

        }
        bufferedReader.close();
        return voyages;
    }

    //Computes the distance between two coordinates (points)
    public double calculateDistance(GPSCoord point1, GPSCoord point2){
        double deltaLatitude = point2.getLatitude() - point1.getLatitude();
        double deltaLongitude = point2.getLongitude() - point1.getLongitude();
        double result = Math.sqrt(Math.pow(deltaLatitude, 2) + Math.pow(deltaLongitude, 2));
        return result;

    }


    public void expandCluster(GPSCoord P, GPSCoord NeighborPts, int C, double eps, int MinPts){
        double addToClusterLat = calculateDistance(P, NeighborPts);
        C = 0;
        eps = 0.0001;
        MinPts = 5;
    }


    //Scans for the points in the database and computes the distance and checks the epsilon
    public List<GPSCoord> RangeQuery(List<GPSCoord> TripList, GPSCoord q, double epsilon){
        List<GPSCoord> neighbourPts = new ArrayList<>();
        for(GPSCoord p: TripList){
            if( p == q){
                continue;
            }
            if(calculateDistance(q, p) <= epsilon && p != q){
                neighbourPts.add(p);
            }
        }
        return neighbourPts;
    }
}
