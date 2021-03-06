;;; lwp: light weight process (see page 77)
(load "queue.ss")

(define lwp-queue (make-queue))
(define lwp
  (lambda (thunk)
    (putq! lwp-queue (list thunk))))

(define start
  (lambda ()
    (let ([p (getq lwp-queue)])
      (delq! lwp-queue)
      (p))))

(define pause
  (lambda ()
    (call/cc
     (lambda (k)
       (lwp (lambda () (k #f)))
       (start)))))

(define test
  (lambda ()
    (lwp (lambda () (let f () (pause) (display "h") (f))))
    (lwp (lambda () (let f () (pause) (display "e") (f))))
    (lwp (lambda () (let f () (pause) (display "y") (f))))
    (lwp (lambda () (let f () (pause) (display "!") (f))))
    (lwp (lambda () (let f () (pause) (newline) (f))))
;    (lwp (lambda () (display "exiting without calling pause")))
    (start)))
