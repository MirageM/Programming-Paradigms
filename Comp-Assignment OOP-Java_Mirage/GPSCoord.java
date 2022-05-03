/*
    (Header)
    Assignment 1 Part 1
    Course Code: CSI2120 (Programming Paradigms)
    Student Name: Mirage Mohammad
    Student Number: 300080185

 */

public class GPSCoord {
    //Encapsulation Class
    private double latitude;
    private double longitude;
    private int clusterID;

    //GPSCoordination Constructor
    public GPSCoord(double latitude, double longitude){
        this.latitude = latitude;
        this.longitude = longitude;
        this.clusterID = 0;
    }
    //Getter of the latitude
    public double getLatitude(){
        return this.latitude;
    }
    //Setter of the latitude
    public void setLatitude(double newLatitude){
        latitude = newLatitude;
    }
    //getter of the longitude
    public double getLongitude(){
        return this.longitude;
    }
    //setter of the longitude
    public void setLongitude(double newLongitude){
        this.longitude = newLongitude;
    }
    //getter of the cluster ID
    public int getClusterID(){
        return clusterID;
    }
    //setter if the cluster ID
    public void setClusterID(int newClusterID){
        clusterID = newClusterID;
    }



}
