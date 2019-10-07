(in-package :cl-scrypt)

(defun get-key-cli ()
  (format t "Password Please: ~%")
  (read-line))

#+lispworks
(defun get-key-gui ()
  (capi:prompt-for-string "Encryption Password:"))

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
(defun main (&rest args)
  (process-args args))

(defun process-args (argz)
  (let* ((args (or argz (uiop:raw-command-line-arguments)))
         (bin (nth 0 args))
         (verb (nth 1 args))
         (file (nth 2 args)))
    (format t "bin: ~a verb: ~a file:~a~%" bin verb file)
    (cond
      ((equal "-e" verb) (my-encrypt-file file))
      ((equal "-d" verb) (my-decrypt-file file))
      (t (usage)))))

(defun usage ()
  (format t "Usage: scrypt -[ed] file~%")
  (format t "Encrypt file: scrypt -e file~%")
  (format t "Decrypt file: scrypt -d file~%")
  (uiop:quit))


#+allegro
(in-package :cl-user)

#+allegro
(defun main (&rest args)
  (cl-scrypt::process-args args))
