(load "load.lisp")

#+(or ccl clisp)
(ql:quickload "trivial-dump-core")

#+sbcl
(sb-ext:save-lisp-and-die "sc" :compression 9 :executable t :toplevel 'scrypt::main :save-runtime-options t)

#+(or ccl clisp)
(trivial-dump-core:save-executable "scrypt" #'scrypt::main)

#+lispworks
(deliver 'scrypt::main "scrypt" 1 :multiprocessing t :keep-eval t)
