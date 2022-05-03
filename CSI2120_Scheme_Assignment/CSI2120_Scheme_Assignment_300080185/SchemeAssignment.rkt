#lang scheme
(require racket/trace)
;CSI2120 Programming Paradigm Assignment 6
;Scheme Assignment (lowest-exponent, find-abundant, make-string-list)
;Student: Mirage Mohammad

;Question 1
;Helper function for lowest-exponent
(define (lowest-exponent-helper base bound expt exponent)
  (cond
    ((>= (expt base exponent) bound) exponent)
    (else
     (lowest-exponent-helper base bound expt (+ exponent 1))
     )
    )
  )
;lowest-exponent(integer >= one), targets the natural number n (bound)
;lowest-exponent returns the lowest positive integer(exponent) for: base^exponent >= bound
(define (lowest-exponent base bound)
  (define exponentiation 1)
  (cond
    ((>= (expt base exponentiation) bound) exponentiation)
    (else (+ exponentiation 1)
          (lowest-exponent-helper base bound expt exponentiation))
    )
  )

;;Function calls (lowest-exponent)
(trace lowest-exponent)
(lowest-exponent 3 27)
(lowest-exponent 3 28)


;Question 2
;all-divisor returns a list of all the divisors of n
(define (all-divisor n thresh)
  (cond ((< thresh 1) '())
        ((= 0 (remainder n thresh)) (cons thresh (all-divisor n ( - thresh 1))))
        (else (all-divisor n (- thresh 1)))
        )
  )

;takes the sum of 1, 2, 3, 4, 6, 8, 12, 24 which is 60              
(define (sum elementList)
  (cond
    ((null? elementList) 0)
    (else (+ (car elementList) (sum (cdr elementList))))
    )
  )
;is-abundant checks if a postive integer n is abundant by checking if the summation of all the divisors of n are greater than 2n
(define (is-abundant n)
  (cond
    ((> (sum(all-divisor n n)) (* 2 n)) #t)
    ((= (sum(all-divisor n n)) (* 2 n)) #f)
    ((< (sum(all-divisor n n)) (* 2 n)) #f)
    )
  )
;find-abundant takes a parameter of a postive number and produces a list of all abundant numbers no greater than (find-abundant 25)
;returns a list (24 20 18 12)
(define (find-abundant n)
  (cond
    ((< n 1) '())
    ((is-abundant n) (cons n (find-abundant (- n 1))))
    (else (find-abundant (- n 1)))
    )
  )

;;Function calls (find-abundant)
(trace find-abundant)
(find-abundant 25)



;Question 3
;make-string-list(naturalNumber) -> (a list of strings)
;returns a list of strings where the first string in the list is "n seconds", the second string is "(n-1) seconds", the third string is "1 second", the last string is "Finished"

(define (make-string-list naturalNumber)
  (cond
    ((= naturalNumber 1) '("1 second" "Finished")) ;Natural number n has a value of 1: returns the third string "1 second" and the last string "Finished"
    ((< naturalNumber 1) '()) ;Natural number n is less than 1: doesn't execute
    ((> naturalNumber 1) (cons (string-append (number->string naturalNumber) " seconds") (make-string-list (- naturalNumber 1)))) ;Natural number n is greater than 1: returns "n seconds" and "(n-1) seconds"
    )
  )

;;Function calls (make-string-list)
(trace make-string-list)
(make-string-list 3)