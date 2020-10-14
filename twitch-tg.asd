(asdf:defsystem #:twitch-tg
  :serial t
  :depends-on (#:cl-ppcre #:alexandria
                          #:cl-who
                          #:hunchentoot
                          #:parenscript
                          #:quri)
  :components ((:file "package")
               (:file "twitch-tg")))
