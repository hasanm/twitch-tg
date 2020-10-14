(in-package #:twitch-tg)
(require :cl-who)
(require :hunchentoot)
(require :parenscript)
(require :cl-ppcre)

;; Web server 
(defvar *acceptor* nil)
(defvar *the-queue* nil)


(defun my-push (s)
  (let ()
    (setf *the-queue* (reverse (cons s (reverse *the-queue*))))))

(defun my-pop (n)
  (let ((new-list *the-queue*))
    (loop for item in new-list 
       for i from 1 to n         
       do (pop *the-queue*))))

(defun start-server (port)
  ;; (stop-server)
  (start (setf *acceptor*
               (make-instance 'easy-acceptor
                              :port port))))


(defun stop-server ()
  (when *acceptor*
    (stop *acceptor*)))



(define-easy-handler (get-list :uri "/get-list") ()
  (let ((out))
    
    (loop for item in *the-queue*
       for c from 1
       do (let ()
            (setf out (concatenate 'string out (format nil " ~a) ~a" c item)))))

    (format nil "TG Queue :~a~%" out)))


(define-easy-handler (add-to-list :uri "/add-list") (name)
  (let ()
    (if (and name
             (< (length name) 15)
             (> (length name) 1)
             (cl-ppcre:scan "[a-zA-Z0-9._%+-]" name))
        (let ()
          (my-push (quri:url-encode name))
          (format nil "Added~%"))
        (format nil "~%"))))


(define-easy-handler (reset-list :uri "/reset-list") ()
  (setf *the-queue* nil)
  (format nil "~%"))


(define-easy-handler (pop-list :uri "/pop-list") (n)
  (let () 
    (if (and n
           (= (length n) 1)
           (cl-ppcre:scan "[1-9]" n))
      (let ((m (parse-integer n)))
        (my-pop m)))
      (format nil "~%")))



;; (start-server 9090)
