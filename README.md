# flycheck-popup-tip

[![License GPL 3](https://img.shields.io/github/license/flycheck/flycheck-popup-tip.svg)][COPYING]
[![Build Status](https://travis-ci.org/flycheck/flycheck-popup-tip.svg?branch=master)](https://travis-ci.org/flycheck/flycheck-popup-tip)
[![Coverage Status](https://coveralls.io/repos/github/flycheck/flycheck-popup-tip/badge.svg)](https://coveralls.io/github/flycheck/flycheck-popup-tip)

This is extension for [Flycheck](http://www.flycheck.org/). It implements minor-mode for displaying errors from Flycheck using [popup.el](https://github.com/auto-complete/popup-el).

![flycheck-popup-tip screenshot](screenshots/01.png)

There is [another official flycheck-pos-tip](https://github.com/flycheck/flycheck-pos-tip) extension for displaying errors under point. However, it does not display popup if you run Emacs under TTY. It displays message on echo area and that is often used for ELDoc.
Also, popups made by `pos-tip` library does not always look good, especially on macOS and Windows.

## Installation

### Melpa

Package is available on [Melpa](https://melpa.org/).

In your [Cask](http://cask.github.io) file:

```cl
(source gnu)
(source melpa)

(depends-on "flycheck-popup-tip")
```

In your `init.el`:

```cl
(with-eval-after-load 'flycheck
  '(add-hook 'flycheck-mode-hook 'flycheck-popup-tip-mode))
```

## Configuration options

There is only one configuration option, `flycheck-popup-tip-error-prefix`.
Default value is "\u27a4 ": `➤ `.

```cl
(custom-set-variables
 '(flycheck-popup-tip-error-prefix "* "))
```

## Usage with `flycheck-pos-tip`

If you are planning to use `flycheck-pos-tip` with GUI Emacs and this
extension on TTY, you can do it with following configuration:

``` elisp
(eval-after-load 'flycheck
  (if (display-graphic-p)
      (flycheck-pos-tip-mode)
    (flycheck-popup-tip-mode)))
```

You can also do the following:

``` elisp
(setq flycheck-pos-tip-display-errors-tty-function #'flycheck-popup-tip-show-popup)
(flycheck-pos-tip-mode)
```

That will help if you start Emacs in GUI, but run emacsclient in TTY.

## Contributing

We welcome all kinds of contributions, whether you write patches, open pull
requests, write documentation, help others with Flycheck issues, or just tell
other people about your experiences with Flycheck.  Please take a look at our
[Contributor’s Guide][contrib] for help and guidance about contributing to
Flycheck.

### Running tests

`UNDERCOVER_FORCE=true UNDERCOVER_CONFIG='("*.el" (:report-file "local-report.json") (:send-report nil))' cask exec buttercup -L . -L tests`

This will also generate `local-report.json` file where you can check if
coverage dropped below 100%.

## License

This program is free software: you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation, either version 3 of the License, or (at your option) any later
version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with
this program.  If not, see http://www.gnu.org/licenses/.

[COPYING]: https://github.com/flycheck/flycheck-popup-tip/blob/master/COPYING
[contrib]: http://www.flycheck.org/en/latest/contributor/contributing.html
