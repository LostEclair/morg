;;; main.lisp
;;;
;;; SPDX-License-Identifier: MIT
;;;
;;; Copyright (C) 2026 LostEclair

(in-package #:morg)

(defun music-storage-location (program-arguments)
  "Returns first element of the PROGRAM-ARGUMENTS.
This happens only if LENGTH of PROGRAM-ARGUMENTS is 1."
  (when (/= (length program-arguments) 1)
    (message "usage: morg music-storage")
    (uiop:quit 2))
  (car program-arguments))

(defun quit-if-directory-does-not-exist (directory)
  "Ensures that DIRECTORY exists.
Elsewhere, UIOP:QUIT's."
  (unless (uiop:directory-exists-p directory)
    (message "\"~A\" seems to not exist..." directory)
    (uiop:quit 1)))

(defun main ()
  "Entry point for the application."
  (message "This is ~A ~A (~A)"
           (lisp-implementation-type)
           (lisp-implementation-version)
           (uiop:implementation-identifier))
  (message)
  (message "MORG is free software released under the MIT license.")
  (message "It's provided \"as is\", without warranty of any kind.")
  (message)
  (let ((music-storage (music-storage-location (uiop:command-line-arguments))))
    (message "Expecting music storage at \"~A\"" music-storage)
    (quit-if-directory-does-not-exist music-storage)
    (let* ((all (walk-files music-storage))
           (ignores (find-ignore-files all))
           (music (remove-ignored (find-music-files all) ignores)))
      (message "Found ~R untouched music file~:P" (length music))
      (organize music-storage music))))
