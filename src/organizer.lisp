;;; organizer.lisp
;;;
;;; SPDX-License-Identifier: MIT
;;;
;;; Copyright (C) 2026 LostEclair

(in-package #:morg)

(defun primary-artist (s)
  "First non-empty name in a ;-separated artist string, or NIL."
  (when s
    (find-if-not (lambda (x) (string= x ""))
                 (mapcar (lambda (x) (string-trim " " x))
                         (uiop:split-string s :separator ";")))))

(defun organize-file (root music-file)
  "Move MUSIC-FILE to ROOT/Artist/Album/Title.ext.
Tags are read with the TAGLIB library, which supports MP3, M4A and FLAC."
  (let ((audio (audio-streams:open-audio-file music-file nil)))
    (unless audio (error "No readable tags in ~A" music-file))
    (let* ((artist (or (primary-artist (abstract-tag:album-artist audio))
                       (primary-artist (abstract-tag:artist audio))
                       "Unknown Artist"))
           (album (or (abstract-tag:album audio) "Unknown Album"))
           (title (or (abstract-tag:title audio) (pathname-name music-file)))
           (destination (merge-pathnames (make-pathname :directory `(:relative
                                                                     ,(sanitize artist)
                                                                     ,(sanitize album))
                                                        :name (sanitize title)
                                                        :type (pathname-type music-file))
                                         (uiop:ensure-directory-pathname root)))
           (ignore-file (merge-pathnames
                         *morg-ignore-file*
                         (uiop:pathname-directory-pathname destination))))
      (ensure-directories-exist destination)
      (unless (probe-file ignore-file)
        (message "Marking with \"~A\". Don't want to come here yet again." ignore-file)
        (with-open-file (out ignore-file :direction :output)))
      (when (probe-file destination)
        (message "Skipping existing \"~A\"" destination)
        (return-from organize-file destination))
      (rename-file music-file destination)
      (message "\"~A\" -> \"~A\" (Metadata: ~S ~S ~S)"
               music-file destination
               artist album title)
      destination)))

(defun organize (root music-files)
  "Organizes MUSIC-FILES, using their tags."
  (loop :for file :in music-files
        :doing (handler-case (organize-file root file)
                 (error (e) (message "Could not organize ~A: ~A" file e)))))
