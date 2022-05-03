#lang scheme
;CSI2120 Programming Paradigms Assignment 5
;Comprehensive Scheme Assignment MergeClusters
;Student: Mirage Mohammad

(require "import.scm")

;replaceIndex(list, index value) -> void
;replaces the given value in the desired index
(define (replaceIndex List index value)
  (if (null? List) List
      (cons
       (if (zero? index)
           value
           (car List))
       (replaceIndex (cdr List) (- index 1) value))))

;retrieveLastElement(list) -> lastElement
;retrieves the last element of the list
(define (retrieveLastElement List)
  (if (zero? (length (cdr List)))
      (car List)
      (retrieveLastElement (cdr List))))

;changingLabel(findElement, replaceElement, index line) -> void (setter)
;changes the label of one of the clusters
(define (changingLabel findElement replaceElement Index Line)
  (cond
    ((null? Line) '())
    ((= (last (car Line)) findElement)
     (cons (replaceIndex (car Line) Index replaceElement)
           (changingLabel findElement replaceElement Index (cdr Line))))
    ((not (= (last (car Line)) findElement))
     (cons (car Line)
           (changingLabel findElement replaceElement Index (cdr Line))))
    (else (changingLabel findElement replaceElement Index (cdr Line)))
    )
  )

;relabel(findElement, replaceElement, line) -> void
;relabels the points of the clusters with a new label
(define (relabel findElement replaceElement Line)
  (changingLabel findElement replaceElement 4 Line))

;intersectingPoints(list1, list2) -> boolean
;checks if the clusters contain same points then said to be intersecting points
(define (intersectingPoints List1 List2)
  (cond
    ((= (car (cdr List1)) (car (cdr List2))) #t)
    (else #f))
  )

;clusterListUnion(c, clusterList) -> union
;represents a list of union of points by comparing two clusters
(define (clusterListUnion C clusterList)
  (cond
    ((null? C) '())
    ((null? clusterList) C)
    ((not (existsInList (car clusterList) C)) (cons (car clusterList) (clusterListUnion C (cdr clusterList))))
    ((existsInList (car clusterList) C) (clusterListUnion C (cdr clusterList)))
    )
  )
;existsInList(list1, list2) -> boolean
;returns true if list1 is found in list2 which is a 2D list otherwise, returns false
(define (existsInList List1 List2)
  (cond
    ((null? List2) #f)
    ((intersectingPoints List1 (car List2)) #t)
    (else (existsInList List1 (cdr List2)))
    )
  )

;clusterListIntersection(clusterList, c) -> intersection
;represents a list of intersection of points by comparing two clusters
(define (clusterListIntersection ClusterList C)
  (cond
    ((null? ClusterList) '())
    ((existsInList (car ClusterList) C) (cons (car ClusterList) (clusterListIntersection (cdr ClusterList) C)))
    (else (clusterListIntersection (cdr ClusterList) C))
    )
  )

;matchClusterID(point1, point 2) -> boolean
;returns true if point1 and point2 have matching cluster id, otherwise false
(define (matchClusterID point1 point2)
  (eq?
   ;(car (cdr (cdr (cdr (cdr P1)))))
   (cadddr point1)
   ;(car (cdr (cdr (cdr (cdr P2)))))
   (cadddr point2)
   )
  )

;existsInCluster(point) -> boolean
;returns true if the points exist in the list, otherwise false
(define (existsInCluster Point List)
  (cond
    ((null? List) #f)
    ((matchClusterID Point (car List)) #t)
    (else (existsInCluster Point (cdr List)))
    )
  )

;cluster(point, list) -> points
;identifies the list of points in the same cluster
(define (cluster Point List)
  (cond
    ((null? List) '())
    ((matchClusterID Point (car List)) (cons (car List) (cluster Point (cdr List))))
    (else (cluster Point (cdr List)))
    )
  )

;createCluster(points, list, clusterlist) -> void (new cluster)
;creates a new 3D outer layer cluster consiting of multiple clusters
(define (createClusters Points List ClusterList)
  (cond
    ((null? List) ClusterList)
    ((existsInCluster (car List) Points) (createClusters Points (cdr List) ClusterList))
    (else
     (let
         ((cluster (cluster (car List) List)))
            (let
                ((LOutput (cons cluster ClusterList)))
                 (let
                     ((LLOutput (cons (car List) Points)))
                     (createClusters LLOutput (cdr List) LOutput)
                   )
              )
       )
     )
    )
  )

;labelExtract(intersectingPoints) -> list
;displays a new list of cluster labels          
(define (labelExtraction intersectingPoints)
  (cond
    ((null? intersectingPoints) '())
    (else (cons (car (cdr (cdr (cdr (cdr (car intersectingPoints)))))) (labelExtraction (cdr intersectingPoints))))
    )
  )
;relabelIntersection(labelC, intersectinglabels, clusterlist) -> void (relabels)
;iterates and relabels each intersection
(define (relabelIntersection LabelC intersectingLabels clusterList)
  (cond
    ((null? intersectingLabels) clusterList)
    (else
     (let
         ((RelabeledClusterList (relabel (car intersectingLabels) LabelC clusterList)))
           (relabelIntersection LabelC (cdr intersectingLabels) RelabeledClusterList))
     )
    )
  )

;relabelCluster(eachC, clusterlist) -> void (relabels)
;iterates and relabels each cluster in the local list of clusters
(define (relabelCluster eachC clusterList)
  (cond
    ((null? eachC) clusterList)
    (else
     (let
         ((Intersection (clusterListIntersection clusterList (car eachC))))
            (let
                ((RelabeledClusterList (relabelIntersection (car (cdr (cdr (cdr (cdr (car (car eachC))))))) (labelExtraction Intersection) clusterList)))
                  (let
                      ((UnionClusterList (clusterListUnion (car eachC) RelabeledClusterList)))
                      (relabelCluster (cdr eachC) UnionClusterList)
                    )
              )
       )
     )
    )
  )


;merges the intersecting clusters from adjacent partitions
;these clusters merge to constitute one large clusters covering more than one partition
(define (mergeClusters)
  (let
      ((database (import)))
        (let ((clusters (createClusters '() database '())))
          (relabelCluster clusters '()))
    )
  )


(define (readlist filename)
 (call-with-input-file filename
  (lambda (in)
    (read in))))


(define (import)
  (let ((p65 (readlist "partition65.scm"))
        (p74 (readlist "partition74.scm"))
        (p75 (readlist "partition75.scm"))
        (p76 (readlist "partition76.scm"))
        (p84 (readlist "partition84.scm"))
        (p85 (readlist "partition85.scm"))
        (p86 (readlist "partition86.scm")))
    (append p65 p74 p75 p76 p84 p85 p86)))

;resulting list saved in a text file
(define (saveList filename L)
(call-with-output-file filename
  (lambda (out)
    (write L out))))
;(saveList (mergeClusters (import)))
(saveList "clusters.txt" (mergeClusters))


;;All the Test Ouputs

;Definition of test (replaceIndex)
(display "Definition of test (replaceIndex): (replaceIndex (list 1 2 3 4) 3 5) ")
(replaceIndex (list 1 2 3 4) 3 5)

;Defintion of (retrieveLastElement)
(display "Defintion of (retrieveLastElement): (retrieveLastElement (list 1 2 3)) ")

(retrieveLastElement (list 1 2 3))
;Definition of test (changingLabel)
(display "Definition of test (changingLabel): (changingLabel 33 77 4 (list (list 65 1 2.2 3.1 33) (list 65 2 2.1 3.1 22) (list 65 3 2.5 3.1 33) (list 65 4 2.1 4.1 33) (list 65 5 4.1 3.1 30) (list 65 6 4.1 3.1 25))) ")
(changingLabel 33 77 4 (list (list 65 1 2.2 3.1 33) (list 65 2 2.1 3.1 22) (list 65 3 2.5 3.1 33) (list 65 4 2.1 4.1 33) (list 65 5 4.1 3.1 30) (list 65 6 4.1 3.1 25)))

;Defintion of test (relabel)
(display "Defintion of test (relabel): (relabel 33 77 (list (list 65 1 2.2 3.1 33) (list 74 2 2.1 3.1 22) (list 75 3 2.5 3.1 33) (list 84 4 2.1 4.1 33) (list 85 5 4.1 3.1 30) (list 85 6 4.1 3.1 25))) ")
(relabel 33 77 (list (list 65 1 2.2 3.1 33) (list 74 2 2.1 3.1 22) (list 75 3 2.5 3.1 33) (list 84 4 2.1 4.1 33) (list 85 5 4.1 3.1 30) (list 85 6 4.1 3.1 25)))

;Definition of test (intersectingPoints)
(display "Definition of test (intersectingPoints): (intersectingPoints (list 65 3 2.1 4.2 33) (list 67 3 2.2 3.3 22)) ")
(intersectingPoints (list 65 3 2.1 4.2 33) (list 67 3 2.2 3.3 22))

;Definition of test (existsInList)
(display "Definition of test (existsInList): (existsInList (list 1 2.2 3.1 33) (list (list 5 4.1 3.1 30) (list 1 2.2 3.1 33) (list 4 2.1 4.1 33))) ")
(existsInList (list 1 2.2 3.1 33) (list (list 5 4.1 3.1 30) (list 1 2.2 3.1 33) (list 4 2.1 4.1 33)))

;Definition of test (clusterListIntersection)
(display "Definition of test (clusterListIntersection): (clusterListIntersection (list (list 65 1 2.2 3.1 33) (list 65 2 2.1 3.1 22) (list 65 3 2.5 3.1 33)) (list (list 67 2 2.1 3.1 22) (list 67 3 2.5 3.1 33) (list 67 4 2.1 4.1 33) (list 67 5 4.1 3.1 30))) ")
(clusterListIntersection (list (list 65 1 2.2 3.1 33) (list 65 2 2.1 3.1 22) (list 65 3 2.5 3.1 33)) (list (list 67 2 2.1 3.1 22) (list 67 3 2.5 3.1 33) (list 67 4 2.1 4.1 33) (list 67 5 4.1 3.1 30)))
  
;Definition of test (clusterListUnion)
(display "Definition of test (clusterListUnion): (clusterListUnion (list (list 65 1 2.2 3.1 33) (list 65 2 2.1 3.1 22) (list 67 3 2.5 3.1 33) (list 67 4 2.1 4.1 33) (list 67 7 4.1 3.1 30)) (list (list 65 1 2.2 3.1 33) (list 65 2 2.1 3.1 22) (list 68 4 2.1 4.1 33) (list 68 6 4.1 3.1 30) (list 68 7 4.1 3.1 30) (list 68 8 2.1 4.1 33))) ")
(clusterListUnion (list (list 65 1 2.2 3.1 33) (list 65 2 2.1 3.1 22) (list 67 3 2.5 3.1 33) (list 67 4 2.1 4.1 33) (list 67 7 4.1 3.1 30)) (list (list 65 1 2.2 3.1 33) (list 65 2 2.1 3.1 22) (list 68 4 2.1 4.1 33) (list 68 6 4.1 3.1 30) (list 68 7 4.1 3.1 30) (list 68 8 2.1 4.1 33)))

;Definition of test (cluster)
(display "Definition of test (cluster): (cluster (list 65 7 4.1 3.1 30) (list (list 65 8 4.1 3.1 30) (list 65 2 2.1 3.1 30) (list 65 1 2.2 3.1 33) (list 65 3 2.5 3.1 33) (list 65 4 2.1 4.1 35))) ")
(cluster (list 65 7 4.1 3.1 30) (list (list 65 8 4.1 3.1 30) (list 65 2 2.1 3.1 30) (list 65 1 2.2 3.1 33) (list 65 3 2.5 3.1 33) (list 65 4 2.1 4.1 35)))

;Defintion of test (createClusters)
(display "Defintion of test (createClusters): (createClusters '() '(( 10 1 2.2 3.1 33) (10 2 2.1 3.1 22) (10 4 2.1 4.1 33) (10 7 4.1 3.1 30) (10 6 4.1 3.1 30)) '()) ")
(createClusters '() '(( 10 1 2.2 3.1 33) (10 2 2.1 3.1 22) (10 4 2.1 4.1 33) (10 7 4.1 3.1 30) (10 6 4.1 3.1 30)) '())

;Definition of test (labelExtraction)
(display "Definition of test (labelExtraction): (labelExtraction (list (list 65 7 4.1 3.1 30) (list 74 2 2.1 3.1 30) (list 74 1 2.2 3.1 33) (list 75 3 2.5 3.1 35))) ")
(labelExtraction (list (list 65 7 4.1 3.1 30) (list 74 2 2.1 3.1 30) (list 74 1 2.2 3.1 33) (list 75 3 2.5 3.1 35)))

;Defintion of test (relabelIntersection)
(display "Defintion of test (relabelIntersection): (relabelIntersection 38 (list 30 33 35) (list (list 65 7 4.1 3.1 30) (list 74 3 2.2 3.1 25) (list 74 2 2.1 3.1 30) (list 74 1 2.2 3.1 33) (list 75 3 2.5 3.1 35))) ")
(relabelIntersection 38 (list 30 33 35) (list (list 65 7 4.1 3.1 30) (list 74 3 2.2 3.1 25) (list 74 2 2.1 3.1 30) (list 74 1 2.2 3.1 33) (list 75 3 2.5 3.1 35)))

;Definition of test (relabelCluster)
(display "Definition of test (relabelCluster): (relabelCluster (list (list (list 65 1 4.1 3.1 30) (list 65 2 2.1 3.1 30)) (list (list 65 1 2.2 3.1 31) (list 65 3 2.1 3.1 31)) (list (list 65 4 4.1 3.1 32))) '()) ")
(relabelCluster (list (list (list 65 1 4.1 3.1 30) (list 65 2 2.1 3.1 30)) (list (list 65 1 2.2 3.1 31) (list 65 3 2.1 3.1 31)) (list (list 65 4 4.1 3.1 32))) '())


                                    