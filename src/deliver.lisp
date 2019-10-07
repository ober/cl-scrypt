(load "load.lisp")

#+(or ccl clisp)
(ql:quickload "trivial-dump-core")

#+sbcl
(sb-ext:save-lisp-and-die "../dist/sbcl/scrypt" :compression 5 :executable t :toplevel 'cl-scrypt::main :save-runtime-options t)
;;cat deliver.lisp|sbcl --dynamic-space-size 2GB --disable-debugger

#+(or ccl clisp)
(trivial-dump-core:save-executable "scrypt" #'cl-scrypt::main)

#+lispworks
(deliver 'cl-scrypt::main
         "../dist/lispworks/scrypt"
         0
         :keep-package-manipulation t
         :multiprocessing t
         :keep-eval t
         :keep-fasl-dump t
         :keep-editor nil
         :keep-foreign-symbols t
         :keep-function-name t
         :keep-gc-cursor t
         :keep-keyword-names t
         :keep-lisp-reader t
         :keep-macros t
         :keep-modules t
         :keep-top-level t
         :license-info nil
         :keep-walker t
         :KEEP-PRETTY-PRINTER t)

#+allegro
(progn
  (let ((lfiles '("pkgdcl.lisp" "main.lisp" "cl-scrypt.lisp")))
    (mapcar #'compile-file lfiles)
    (generate-executable "scrypt"
                         '("pkgdcl.fasl" "main.fasl" "cl-scrypt.fasl")
                         :show-window :shownoactivate
                         :system-dlls-path "system-dlls/"
                         :temporary-directory #P"/tmp/"
                         :purify t
                         :verbose nil
                         :discard-compiler nil
                         :discard-local-name-info t
                         :discard-source-file-info t
                         :discard-xref-info t
                         :ignore-command-line-arguments t
                         :include-compiler t
                         :include-composer nil
                         :include-debugger t
                         :include-devel-env nil
                         :include-ide nil
                         :runtime :partners
                         :suppress-allegro-cl-banner t
                         :print-startup-message nil
                         :newspace 16777216
                         :oldspace 33554432)))
