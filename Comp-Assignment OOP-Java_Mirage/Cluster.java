/*
    (Header)
    Assignment 1 Part 1
    Course Code: CSI2120 (Programming Paradigms)
    Student Name: Mirage Mohammad
    Student Number: 300080185

 */
import java.util.ArrayList;
import java.util.List;

public class Cluster {
    private List<GPSCoord> Nodes;
    private int clusterID;
    private double numberOfValues = 0.0;

    //Constructor for the cluster class
    public Cluster(int clusterNumber){
        this.Nodes = new ArrayList<>();
        this.clusterID = clusterNumber;

    }
    //adds a new cluster
    public void addNode(GPSCoord node){
        this.Nodes.add(node);
        this.numberOfValues ++;
    }

    //calculates the average for the latitude
    public double calculateLatitude(){
        double sumOfLatitude = 0.0;

        for(GPSCoord i : this.Nodes){
            sumOfLatitude += i.getLatitude();
        }
        return sumOfLatitude/this.numberOfValues;
    }
    //calculates the average for the longitude
    public double calculateLongitude(){
        double sumOfLongitude = 0.0;
        for(GPSCoord i: this.Nodes){
            sumOfLongitude += i.getLongitude();
        }
        return sumOfLongitude/this.numberOfValues;
    }
    //getter for the cluster label/id
    public int getClusterID(){
        return clusterID;
    }

    public List<GPSCoord> getNodes(){
        return Nodes;
 }

}
