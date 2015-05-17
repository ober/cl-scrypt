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
  (format t "Usage: ~A <encrypt|decrypt|gen-new-iv> <input file> <passphrase> <output file>~%" app))

(defun get-key-from-user ()
  (format t "Key Please: ~%")
  (defvar *mykey* (read-line)))

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
	 (verb (nth 1 args)))
    (cond
      ((equal "encrypt" verb) (my-encrypt-file (nth 2 args)))
      ((equal "decrypt" verb) (my-decrypt-file (nth 2 args)))
      (t (format t "Usage: sc <encrypt|decrypt>" )))))
