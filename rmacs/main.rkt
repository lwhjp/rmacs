#lang racket/base

(provide rmacs)

(require racket/match)

(require "editor.rkt")
(require "buffer.rkt")
(require "mode.rkt")
(require "mode/fundamental.rkt")

(define (usable-terminal?)
  (not (equal? (getenv "TERM") "dumb")))

(define (rmacs #:initial-files [initial-files '()])
  (define e (make-editor #:default-modeset (modeset-add-mode kernel-modeset
                                                             fundamental-mode)))
  (for ((file initial-files)) (visit-file! e file))
  (editor-mainloop e))

(module+ main
  (require racket/trace)
  (current-trace-notify (lambda (s) (log-info "TRACE: ~a" s)))
  (when (not (usable-terminal?))
    (error 'rmacs
           "Cannot run with TERM=~a; terminal lacks essential features."
           (getenv "TERM")))
  (void
   (rmacs #:initial-files (match (current-command-line-arguments)
                            ['#()
                             (list
                              (build-path (collection-file-path "main.rkt" "ansi")
                                          'up 'up "doc" "xterm_controls.txt"))]
                            [(vector files ...)
                             files])))
  ;; (require profile)
  ;; (require ansi)
  ;; (void (profile-thunk (lambda () (begin0 (main)
  ;;                                   (tty-restore!)
  ;;                                   (display (select-graphic-rendition style-normal))
  ;;                                   (display (clear-screen))
  ;;                                   (flush-output)))))
  )
