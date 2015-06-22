(load "load.lisp")

#+(or ccl clisp)
(ql:quickload "trivial-dump-core")

#+sbcl
(sb-ext:save-lisp-and-die "sc" :compression 9 :executable t :toplevel 'cl-scrypt::main :save-runtime-options t)
;;cat deliver.lisp|sbcl --dynamic-space-size 2GB --disable-debugger

#+(or ccl clisp)
(trivial-dump-core:save-executable "scrypt" #'cl-scrypt::main)

#+lispworks
(deliver 'cl-scrypt::main "sc" 0 :multiprocessing t :keep-eval t)

#+allegro
(progn
  (let ((lfiles '("pkgdcl.lisp" "main.lisp" "cl-scrypt.lisp")))
    (mapcar #'compile-file lfiles)
    (generate-executable "sc" '("pkgdcl.fasl" "main.fasl" "cl-scrypt.fasl"))))
