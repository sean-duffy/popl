(define noun-list (list 'dog 'cat 'student 'professor 'book 'computer))
(define verb-list (list 'ran 'ate 'slept 'drank 'exploded 'decomposed))
(define adjective-list (list 'red 'slow 'dead 'pungent 'over-paid 'drunk))
(define adverb-list (list 'quickly 'slowly 'wickedly 'majestically))

(define (sentence)
  (append (append (list (an-adjective)) (noun-phrase)) (verb-phrase)))

(define (pick-random lst)
  (list-ref lst (random (length lst))))

(define (a-noun)
  (pick-random noun-list))

(define (a-verb)
  (pick-random verb-list))

(define (an-adjective)
  (pick-random adjective-list))

(define (an-adverb)
  (pick-random adverb-list))

(define (either a b)
  (if (= (random 2) 0) (a) (b)))

(define (noun-phrase)
  (either 
    (lambda () (list (a-noun)))
    (lambda () (append (list (an-adjective)) (noun-phrase)))))

(define (verb-phrase)
    (either
        (lambda () (list (a-verb)))
        (lambda () (list (a-verb) (an-adverb)))))
