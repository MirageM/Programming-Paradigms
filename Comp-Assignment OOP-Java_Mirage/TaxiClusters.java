/*
    (Header)
    Assignment 1 Part 1
    Course Code: CSI2120 (Programming Paradigms)
    Student Name: Mirage Mohammad
    Student Number: 300080185

 */

import java.util.Scanner;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.io.PrintWriter;
import java.io.File;


public class TaxiClusters {

    public static void main(String[] args) throws IOException {
        //Cluster Counter
        int C = 0;
        /*
        String fileName = args[0];
        int minPts = Integer.parseInt(args[1]);
        double eps = Double.parseDouble(args[2]);
        */
        //Takes the input of the filename, minimum threshold, epsilon
        Scanner inputf = new Scanner(System.in);
        System.out.println("Enter the file name :");
        String fileName = inputf.nextLine();
        Scanner inputm = new Scanner(System.in);
        System.out.println("Enter the value for minimum point: ");
        int minPts = inputm.nextInt();
        Scanner inpute = new Scanner(System.in);
        System.out.println("Enter the value for epsilon: ");
        double eps = inpute.nextDouble();

        //Calling the DBSCAN algorithm
        DBSCAN algorithm = new DBSCAN(minPts, eps);
        //Creates a new array list of clusters
        List <Cluster> myClusters = new ArrayList<>();
        //Extracts the nodes from the csv file
        List <GPSCoord> myNodes = algorithm.importCSVFile(fileName);
        //Previously process all the nodes
        for (GPSCoord coordinate : myNodes){
            if(coordinate.getClusterID() != 0){
                continue;
            }
            //Finds the neighbours
            List <GPSCoord> neighbourPts = algorithm.RangeQuery(myNodes, coordinate, eps);
            if(neighbourPts.size() < minPts){
                coordinate.setClusterID(-1);
            }else{
                C ++;
                Cluster cluster = new Cluster(C);
                coordinate.setClusterID(C);
                cluster.addNode(coordinate);
                List <GPSCoord> seedSet = new ArrayList<> (neighbourPts);
            //Processing every seed point
            for (int index = 0; index < seedSet.size(); index++){
                GPSCoord pointQ = seedSet.get(index);
                if(pointQ.getClusterID() == 0){
                    pointQ.setClusterID(C);
                    cluster.addNode(pointQ);
                    List<GPSCoord> pointQNeighbours = algorithm.RangeQuery(myNodes, pointQ, eps);

                    if (pointQNeighbours.size() >= minPts){
                        for (GPSCoord iterator : pointQNeighbours){
                            if(!(seedSet.contains(iterator))){
                                seedSet.add(iterator);
                            }
                        }
                    }
                }
                else if(pointQ.getClusterID() == 1){
                    pointQ.setClusterID(C);
                    cluster.addNode(pointQ);
                }

            }
            myClusters.add(cluster);

            }

        }
        try {
            //Creates an excel document with the outputs
            PrintWriter pw = new PrintWriter(new File("miragesoutput.csv"));
            StringBuilder sb = new StringBuilder();

            sb.append("Custer ID");
            sb.append(",");
            sb.append("Longitude");
            sb.append(",");
            sb.append("Latitude");
            sb.append(",");
            sb.append("Number of points");
            sb.append("\r\n");
            pw.write(sb.toString());
            //Loops through all the clusters
            for (Cluster cluster : myClusters) {
                sb = new StringBuilder();
                sb.append(cluster.getClusterID());
                sb.append(",");
                sb.append(cluster.calculateLongitude());
                sb.append(",");
                sb.append(cluster.calculateLatitude());
                sb.append(",");
                sb.append(cluster.getNodes().size());
                sb.append("\r\n");
                pw.write(sb.toString());
            }
            pw.close();
            pw.flush();
            System.out.println("Success:  An excel document of the cluster outputs has been created ");

        }catch(Exception e){
            System.err.println(("Error: Please input a filename followed by an integer and double "));
        }


    }
}
