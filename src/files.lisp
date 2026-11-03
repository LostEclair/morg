;;; files.lisp
;;;
;;; SPDX-License-Identifier: MIT
;;;
;;; Copyright (C) 2026 LostEclair

(in-package #:morg)

(defun walk-files (root)
  "Return a list of all files under ROOT, recursively."
  (uiop:while-collecting (collect)
    (uiop:collect-sub*directories root (constantly t) (constantly t)
                                  (lambda (dir)
                                    (mapc #'collect (uiop:directory-files dir))))))

(defun find-ignore-files (files)
  (remove-if-not (lambda (p)
                   (string= (file-namestring p) *morg-ignore-file*))
                 files))

(defun find-music-files (files)
  (remove-if-not (lambda (p)
                   (member (pathname-type p) '("mp3" "flac" "m4a")
                           :test #'equalp))
                 files))

(defun remove-ignored (music ignores)
  "Remove from MUSIC every file that sits in a directory containing an IGNORES files."
  (let ((ignored-dirs (mapcar #'uiop:pathname-directory-pathname ignores)))
    (remove-if (lambda (m)
                 (member (uiop:pathname-directory-pathname m) ignored-dirs
                         :test #'uiop:pathname-equal))
               music)))

(defun sanitize (s)
  (let ((clean (string-trim
                " ."
                (substitute-if #\_
                               (lambda (c)
                                 (or (find c "/\\:*?\"<>|[]")
                                     (< (char-code c) 32)))
                               s))))
    (if (string= clean "") "_" clean)))
