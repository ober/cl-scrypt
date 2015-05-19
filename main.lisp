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

(defun usage (app)
  (format t "Usage: ~A <encrypt|decrypt|gen-new-iv> <input file> <passphrase> <output file>" app))

;;(defvar *mykey* "foo")

(defun get-key-cli ()
  (format t "Password Please: ~%")
  (read-line))

#+lispworks
(defun get-key-gui ()
  (capi:prompt-for-string "Password Please:"))

#+sbcl
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

(defun main ()
  (let* ((args (argv))
	 (verb (nth 0 args)))
    (cond
      ((equal "se" verb) (my-encrypt-file (nth 1 args)))
      ((equal "sd" verb) (my-decrypt-file (nth 1 args)))
      (t (format t "Usage: s[de] file~%se: encrypts file~%sd: decrypts file" )))))
