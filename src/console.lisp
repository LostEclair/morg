;;; console.lisp
;;;
;;; SPDX-License-Identifier: MIT
;;;
;;; Copyright (C) 2026 LostEclair

(in-package #:morg)

(defmacro message (&optional (formatting "") &rest arguments)
  "Print a formatted diagnostic line to *ERROR-OUTPUT*.
FORMATTING is a FORMAT's control string.
ARGUMENTS is the rest of elements, that is provided to FORMAT.
The line is prefix with a semicolon and ends with a fresh line."
  `(format *error-output*
           ,(concatenate 'string "; " formatting "~&")
           ,@arguments))
