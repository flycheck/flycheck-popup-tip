;;; test-flycheck-popup-tip.el -- Tests

;; Copyright (C) 2017 Saša Jovanić

;; Author: Saša Jovanić <info@simplify.ba>

;; This file is not part of GNU Emacs.

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Tests for `flycheck-popup-tip-mode'

;;; Code:

(require 'buttercup)
(require 'flycheck)
(require 'undercover-init)
(require 'flycheck-popup-tip)

;;(post-command-hook)

(describe "Suite: flycheck-popup-tip"
  (before-each
    (global-flycheck-mode 1)
    (setq flycheck-global-modes t))

  (describe "Mode: flycheck-popup-tip minor-mode"
    :var (old-function)
    (before-each
      (setq old-function flycheck-display-errors-function))

    (it "sets everything when activated"
      (with-temp-buffer
        (emacs-lisp-mode)
        (flycheck-popup-tip-mode 1)
        (expect flycheck-popup-tip-object :to-be nil)
        (expect flycheck-popup-tip-mode :to-be-truthy)
        (expect flycheck-popup-tip-error-prefix :to-equal "\u27a4 ")
        (expect flycheck-display-errors-function :to-be 'flycheck-popup-tip-show-popup)
        (expect flycheck-popup-tip-old-display-function :to-be old-function)
        (expect focus-out-hook :to-contain 'flycheck-popup-tip-delete-popup)
        (expect post-command-hook :to-contain 'flycheck-popup-tip-delete-popup)))

    (it "resets everything when deactivated"
      (with-temp-buffer
        (emacs-lisp-mode)
        (flycheck-popup-tip-mode 1)
        (flycheck-popup-tip-mode 0)
        (expect flycheck-popup-tip-mode :not :to-be-truthy)
        (expect flycheck-display-errors-function :not :to-be 'flycheck-popup-tip-show-popup)
        (expect flycheck-popup-tip-old-display-function :to-be nil)
        (expect focus-out-hook :not :to-contain 'flycheck-popup-tip-delete-popup)
        (expect post-command-hook :not :to-contain 'flycheck-popup-tip-delete-popup))))

  (describe "Function: flycheck-popup-tip-delete-popup"
    (it "deletes popup"
      (add-hook 'pre-command-hook 'flycheck-popup-tip-delete-popup nil t)
      (spy-on 'popup-live-p :and-return-value t)
      (spy-on 'popup-delete :and-return-value t)
      (flycheck-popup-tip-delete-popup)
      (expect pre-command-hook :not :to-contain 'flycheck-popup-tip-delete-popup)
      (expect 'popup-live-p :to-have-been-called)
      (expect 'popup-delete :to-have-been-called))

    (it "deletes hook even if there is no popup"
      (add-hook 'pre-command-hook 'flycheck-popup-tip-delete-popup nil t)
      (spy-on 'popup-live-p :and-return-value nil)
      (spy-on 'popup-delete :and-return-value t)
      (flycheck-popup-tip-delete-popup)
      (expect pre-command-hook :not :to-contain 'flycheck-popup-tip-delete-popup)
      (expect 'popup-live-p :to-have-been-called)
      (expect 'popup-delete :not :to-have-been-called)))

  (describe "Function: flycheck-popup-tip-format-errors"
    (it "transforms errors from Flycheck"
      (let* ((fake-errors (list
                           (flycheck-error-new-at 1 1 'error "foo")
                           (flycheck-error-new-at 2 2 'warning "bar")
                           (flycheck-error-new-at 2 2 'warning "bar")
                           (flycheck-error-new-at 3 3 'info "spam")))
             (result (flycheck-popup-tip-format-errors fake-errors)))
        (expect result :to-equal
                (propertize "\u27a4 bar\n\u27a4 foo\n\u27a4 spam"
                            'face
                            '(:inherit popup-tip-face
                                       :underline nil
                                       :overline nil
                                       :strike-through nil
                                       :box nil
                                       :slant normal
                                       :width normal
                                       :weight normal)))))

    (it "transforms errors from Flycheck with different prefix set"
      (let* ((flycheck-popup-tip-error-prefix ">> ")
             (fake-errors (list
                           (flycheck-error-new-at 1 1 'error "foo")
                           (flycheck-error-new-at 2 2 'warning "bar")
                           (flycheck-error-new-at 2 2 'warning "bar")
                           (flycheck-error-new-at 3 3 'info "spam")))
             (result (flycheck-popup-tip-format-errors fake-errors)))
        (expect result :to-equal
                (propertize ">> bar\n>> foo\n>> spam"
                            'face
                            '(:inherit popup-tip-face
                                       :underline nil
                                       :overline nil
                                       :strike-through nil
                                       :box nil
                                       :slant normal
                                       :width normal
                                       :weight normal))))))

  (describe "Function: flycheck-popup-tip-show-popup"
    (it "displays popup"
      (let ((fake-errors (list
                          (flycheck-error-new-at 2 2 'error "foo"))))
        (flycheck-popup-tip-show-popup fake-errors)
        (expect flycheck-popup-tip-object :not :to-equal nil)
        (expect pre-command-hook :to-contain 'flycheck-popup-tip-delete-popup))))

  (describe "Customization"
    (it "opens without error"
      (customize-group 'flycheck-popup-tip))))

(provide 'test-flycheck-popup-tip)
;;; test-flycheck-popup-tip.el ends here
