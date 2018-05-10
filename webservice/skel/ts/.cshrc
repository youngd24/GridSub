# @(#)cshrc 1.11 89/11/29 SMI
umask 022
set path=($path /foo/bar)	# /foo/bar is a dummy dir used as an example
if ( $?prompt ) then
	set history=32
	source /local/bin/mbashrc
	source ~/.login
endif
