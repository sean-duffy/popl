(define (visit-doctor name)
  (begin
    (displayln (list 'hello name))
    (displayln '(what seems to be the trouble?))
    (doctor-driver-loop name (list))))

(define (doctor-driver-loop name history)
  (begin
    (newline)
    (display '**)
    (let ((user-response (read)))
      (if (equal? user-response '(goodbye))
        (begin
          (displayln (list 'goodbye name))
          (displayln '(see you next week))
          (displayln history)
          )
        (begin
          (displayln (reply user-response history))
          (doctor-driver-loop name (append history (list user-response)))
          )))))

(define (reply user-response history)
  (if (fifty-fifty)
    (append (qualifier) (change-person user-response))
    (if (fifty-fifty) 
      (hedge)
      (append '(earlier you said that) (change-person (pick-random history)))
    )))

(define (fifty-fifty) (= (random 2) 0))

(define (qualifier)
  (pick-random 
    '((you seem to think)
      (you feel that)
      (why do you believe)
      (why do you say))))

(define (hedge)
  (pick-random
    '((please go on)
      (many people have the same sorts of feelings)
      (many of my patients have told me the same thing)
      (please continue)
      (oh no)
      )))

(define (replace pattern replacement lst)
  (cond ((null? lst) '())
        ((equal? (car lst) pattern)
                 (cons replacement
                       (replace pattern replacement (cdr lst)))
        )
        (else (cons (car lst)
                    (replace pattern replacement (cdr lst)))
        )))

(define (many-replace replacement-pairs lst)
    (if (null? replacement-pairs)
           lst
           (let ((pat-rep (car replacement-pairs)))
                  (replace (car pat-rep)
                           (cadr pat-rep)
                           (many-replace (cdr replacement-pairs)
                                         lst)))))

(define (change-person phrase)
  (many-replace '((i you) (me you) (am are) (my your)
                  (you i) (are am) (your my)) phrase))

(define (pick-random lst) (list-ref lst (random (length lst))))
