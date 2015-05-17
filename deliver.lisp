(load "load.lisp")

#+(or ccl clisp)
(ql:quickload "trivial-dump-core")

#+sbcl
(sb-ext:save-lisp-and-die "sc" :compression 9 :executable t :toplevel 'cl-scrypt::main :save-runtime-options t)

#+(or ccl clisp)
(trivial-dump-core:save-executable "scrypt" #'cl-scrypt::main)

#+lispworks
(deliver 'cl-scrypt::main "sc" 1 :multiprocessing t :keep-eval t)
