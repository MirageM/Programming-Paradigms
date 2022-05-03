#lang scheme
(define (readlist filename)
 (call-with-input-file filename
  (lambda (in)
    (read in))))

(define (import)
  (let ((p65 (readlist "/Users/mirage/Desktop/CSI2120_Comprehensive_Scheme_Assignment_MergeCluster/partition65.scm"))
        (p74 (readlist "/Users/mirage/Desktop/CSI2120_Comprehensive_Scheme_Assignment_MergeCluster/partition74.scm")) 
        (p75 (readlist "/Users/mirage/Desktop/CSI2120_Comprehensive_Scheme_Assignment_MergeCluster/partition75.scm")))
    (append p65 p74 p75)))