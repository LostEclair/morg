;;; morg.asd
;;;
;;; SPDX-License-Identifier: MIT
;;;
;;; Copyright (C) 2026 LostEclair

(asdf:defsystem #:morg
  :description "A basic application."
  :author "LostEclair"
  :license "MIT"
  :version "0.1.0"
  :depends-on (#:uiop
               #:taglib)
  :components ((:module "src"
                :components ((:file "package")
                             (:file "const" :depends-on ("package"))
                             (:file "console" :depends-on ("package"))
                             (:file "files" :depends-on ("package"
                                                         "const"))
                             (:file "organizer" :depends-on ("package"
                                                             "files"
                                                             "const"
                                                             "console"))
                             (:file "main" :depends-on ("package"
                                                        "files"
                                                        "organizer")))))
  :build-pathname #.(format nil "morg-~A" (uiop:implementation-identifier))
  :build-operation program-op
  :entry-point "morg:main")
