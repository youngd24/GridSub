#
# @(#)local.profile 1.4	93/09/15 SMI
#
stty istrip
PATH=/opt/local/bin:/opt/bin:/usr/ucb:/bin:/usr/bin:/usr/local/bin:/usr/local/gnu/bin:.
#PATH=${PATH}:/foo/bar		# /foo/bar is a dummy dir used as an example
export PATH

#
# If possible, start the windows system
#
if [ `tty` = "/dev/console" ] ; then
	if [ "$TERM" = "sun" -o "$TERM" = "AT386" ] ; then

		if [ ${OPENWINHOME:-""} = "" ] ; then
			OPENWINHOME=/usr/openwin
			export OPENWINHOME
		fi

		echo ""
		echo "Starting OpenWindows in 5 seconds (type Control-C to interrupt)"
		sleep 5
		echo ""
		$OPENWINHOME/bin/openwin

		clear		# get rid of annoying cursor rectangle
		exit		# logout after leaving windows system

	fi
fi

