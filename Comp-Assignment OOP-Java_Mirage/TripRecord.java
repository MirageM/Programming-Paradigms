/*
    (Header)
    Assignment 1 Part 1
    Course Code: CSI2120 (Programming Paradigms)
    Student Name: Mirage Mohammad
    Student Number: 300080185

 */

public class TripRecord {
    //This class was not needed for part 1
    private String pickup_DateTime;
    private GPSCoord pickup_Location;
    private GPSCoord dropoff_Location;
    private double trip_Distance;

    public TripRecord(String pickup_DateTime, GPSCoord pickup_Location, GPSCoord dropoff_Location, double trip_Distance){
        this.pickup_DateTime = pickup_DateTime;
        this.pickup_Location = pickup_Location;
        this.dropoff_Location = dropoff_Location;
        this.trip_Distance = trip_Distance;
    }

}
