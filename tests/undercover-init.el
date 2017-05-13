;;; undercover-init -- Initialization for undercover

;;; Commentary:

;; `undercover.el' initialization

;;; Code:

(when (require 'undercover nil t)
  (undercover "*.el"))

(provide 'undercover-init.el)
;;; undercover-init ends here
