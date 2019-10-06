(in-package :cl-scrypt)

(defun argv ()
  (or
   #+clisp (ext:argv)
   #+sbcl sb-ext:*posix-argv*
   #+abcl ext:*command-line-argument-list*
   #+clozure (ccl::command-line-arguments)
   #+gcl si:*command-args*
   #+ecl (loop for i from 0 below (si:argc) collect (si:argv i))
   #+cmu extensions:*command-line-strings*
   #+allegro (sys:command-line-arguments)
   #+lispworks sys:*line-arguments-list*
   nil))

;;(defvar *mykey* "foo")

(defun get-key-cli ()
  (format t "Password Please: ~%")
  (read-line))

#+lispworks
(defun get-key-gui ()
  (capi:prompt-for-string "Password Please:"))

#+(or sbcl allegro)
(defun get-key-gui ()
  (with-ltk ()
    (let* ((text-widget
	    (make-instance 'text :width 15 :height 2 :name "password"))
	   (b1 (make-instance 'button
			      :text "Scrypt IT!"
			      :command #'(lambda ()
					   (defvar *mykey* (text text-widget))
					   (setf *exit-mainloop* t)))))
      (pack text-widget)
      (pack b1))))

(defun get-key-from-user ()
  (defvar *mykey* (get-key-gui)))

(defun my-encrypt-file (sfile)
  (get-key-from-user)
  ;;(defvar *mykey* "foo")
  (with-open-file
      (out (format nil "~A.sc" sfile)
	   :direction :output
	   :if-does-not-exist :create
	   :if-exists :supersede
	   :element-type '(unsigned-byte 8))
    (cl-scrypt::encrypt-file sfile *mykey* out)))

(defun my-decrypt-file (sfile)
  (get-key-from-user)
  (with-open-file
      (out (subseq sfile 0 (- (length sfile) 3))
	   :direction :output
	   :if-does-not-exist :create
	   :if-exists :supersede
	   :element-type '(unsigned-byte 8))
    (cl-scrypt::decrypt-file sfile *mykey* out)))

#-allegro
(defun main ()
  (let* ((args (argv))
         (bin (nth 0 args))
         (verb (nth 1 args))
         (file (nth 2 args)))
    (format t "argv: ~a~%" args)
    (cond
      ((equal "-e" verb) (my-encrypt-file file))
      ((equal "-d" verb) (my-decrypt-file file))
      (t (usage)))))

(defun usage ()
  (format t "Usage: scrypt -[ed] file~%")
  (format t "Encrypt file: scrypt -e file~%")
  (format t "Decrypt file: scrypt -d file~%"))

#+allegro
(in-package :cl-user)

#+allegro
(defun main (bin verb cfile)
  (cond
    ((equal "-e" verb) (cl-scrypt::my-encrypt-file cfile))
    ((equal "-d" verb) (cl-scrypt::my-decrypt-file cfile))
    (t (cl-scrypt:usage))))
