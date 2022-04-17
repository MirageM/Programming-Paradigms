#lang scheme
(require racket/trace)
;;Mirage Lab 10 (CSI2120)
; Exercise 1: Building Lists (uses cons to build the list)
(cons 3 (cons 4 '()))
(cons 1 (cons 2 (cons 3 null)))
(cons 'a (cons (cons 'b (cons 'c '())) '()))
(cons 1 '())
(cons 2 (cons (cons 3 (cons (cons 4 '()) '())) '()))


; Exercise 2: List Entries
(define L '(1 2 3 4 5))
(define LL '(1 (2 3 4) (5)))
;;;Combine calls car and cdr to get the element 2, 3, 4 and 5 from the list L (4 solutions).
;;(cdr L)
;;(cdr (cdr L))
;;(cdddr L)
;;(cadr L)  <- ANSWER
;;(caddr L) <- ANSWER
;;(cadddr L) <- ANSWER
;;(car (cdr (cdr (cdr (cdr L))))) <- ANSWER
;Combine calls car and cdr to get the element 2 and 5 from the list LL (2 solutions).
;;(cdr LL)
;;(caadr LL)  <- ANSWER
;;(cddr LL)
;;(caaddr LL) <- ANSWER


;Exercise 3: Integer Range (the function takes two indices, i, k and produces the
;integers between i and k including i and k)
(define (range s e)
  (cond
    [(> s e) 'range_error]
    [(= s e) (cons e '())]
    [#t (cons s (range (+ s 1) e))]))
;; (range 1 3)
;; (cons 1 ( cons 2 (cons 3 '())))
;; (range 1 9)

;Exercise 4: Sum of Squares Digit (calculates the sum of square digits)
(define (sosd N)
  (if (number? N)
      (if (>= N 10)
          (+ ((lambda (x) (* x x)) (modulo N 10)) (sosd (quotient N 10)))
          (* N N))
      '()))
;;(sosd 2)
;;(sosd 22)
;;(sosd 33)
;;(sosd 44)
;lambda -> anonymous function
;modulo -> turns the remainder (modulo 22 10)


;Exercise 5: Every k-th element (the function takes a list and an number selecting every kt element
;Start the counting at 1)
(define (drop L k)
  (if (not(list? L)) 'list_error
      (drop-helper L k 1))
  )

(define (drop-helper L k c)
  (cond
    [(null? L) '()]
    [(= c k) (drop-helper (cdr L) k 1)]
    [#t (cons (car L) (drop-helper (cdr L) k (+ c 1)))]))

;;(drop '(a b c d e f g h i k) 3)
(trace drop-helper)

