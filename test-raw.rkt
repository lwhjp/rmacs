#lang racket/base

(require "tty-raw-extension")
(require "ansi.rkt")

(define (main)
  (tty-raw!)
  (let loop ()
    (define ch (read-byte))
    (display (select-graphic-rendition ch))
    (printf "Byte: ~v" ch)
    (display (clear-to-eol))
    (display "\015\012")
    (display (select-graphic-rendition))
    ;;(flush-output)
    (if (member ch '(4 8 127)) ;; EOF, C-h, DEL
	(exit)
	(loop))))

(main)