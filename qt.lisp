(ql:quickload :qt)
(in-package :qt)
(named-readtables:in-readtable :qt)

(defclass hello-name-app ()
  ((name-edit :accessor name-edit)
   (name-button :accessor name-button)
   (name-label :accessor name-label))

  (:metaclass qt-class)
  (:qt-superclass "QWidget")
  (:slots ("show-name()" show-name)))

(defmethod initialize-instance :after
  ((instance hello-name-app) &key)
   (new instance)
   (init-ui instance))

(defmethod init-ui ((instance hello-name-app))
  (#_setGeometry instance 400 400 300 200)
  (#_setWindowTitle instance "Scrypt:")
  (setf (name-edit instance) (#_new QLineEdit "" instance)
	(name-button instance) (#_new QPushButton "Scrypt!" instance)
	(name-label instance) (#_new QLabel "" instance))
  (let ((box (#_new QVBoxLayout instance)))
    (#_addWidget box (#_new QLabel "Password: ?" instance) 0 0)
    (#_addWidget box (name-edit instance))
    (#_addWidget box (name-button instance))
    (#_addWidget box (name-label instance))
    (#_addStretch box 1)
    (#_setLayout instance box))
  (#_setMinimumWidth (name-label instance) 270)
  (connect (name-button instance) "clicked()" instance "show-name()"))

(defmethod show-name ((instance hello-name-app))
  (let ((name (#_text (name-edit instance))))
    (#_setText (name-label instance) (if name
				       (concatenate 'string "Hello, "
					 (princ-to-string name))
				       "ERROR"))))

(make-qapplication)
(with-main-window (window (make-instance 'hello-name-app)))
