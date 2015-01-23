#lang eopl
(require "syntax.scm")
(require "semantics.scm")
(require "data-structures.scm")
(require "driver.scm")
;;
;
; CORE
;
(define ten   "10")               ;; 10
(define true  "zero?(0)")         ;; #t
(define nope! "zero?(10)")        ;; #f
(define Hmm?  "zero?(zero?(0))")  ;; semantic error
(define HmHm!  "-( 2, zero?(2))") ;; semantic error
(define e1 ;; 3
    "if zero?( -( 2, 3) ) then 4 else -( 4, -(2,1))")
(define if1  ;; 2    
     "if zero?(1) then 10 else if zero?(1) then 1 else 2")
(define if2 ;; 398    
     "if zero?(1) then 10 else -( 400, if zero?(1) then 1 else 2)")
;
; ** Add more tests ***
(define if3 ;; 1
     "if zero?(-(5, 2)) then 0 else 1"
     )
(define break "$")                    ;; error
(define eq1 "equal?(1, 1)")           ;; #t
(define eq2 "equal?(1, 2)")           ;; #f
(define less1 "less?(2, 5)")          ;; #t
(define greater1 "greater?(20, 10)")  ;; #t
(define plus1 "+(1, 2)")              ;; 3
(define times1 "*(2, 5)")             ;; 10
(define divide "/(6, 2)")             ;; 3
(define minus "-(50, 25)")            ;; 25
(define let1 "let a = -(5, 3) in a")  ;; 2
(define let2 "let x = 5 in x")        ;; 5
(define let3 "let y = +(3, 3) in zero?(y)") ;; #f
(define cond1 "cond { zero?(2) ==> 1 } { zero?(0) ==> 5 } end") ;; 5
(define cond2 "cond { greater?(0, 1) ==> 0 } end") ;; error
(define print1 "-(20, print(+(3, 2)))")
(define lst1 "cons(1, [])")                        ;; (1)
(define lst2 "car(cons(1, cons(2, cons(3, []))))") ;; 1
(define lst3 "cdr(cons(1, cons(2, cons(3, []))))") ;; (2 3)
(define lst4 "null?(cons(1, cons(2, [])))")        ;; #f
(define lst5 "null?([])")                          ;; #t       