my vim config
TODO: Readme


Note: To sign with vim-fugutive in a tty create a script
#!/bin/sh
exec gpg2 --pinentry-mode loopback "$@"

and redirect the global option pgp.program to that script.
