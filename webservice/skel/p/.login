# @(#)Login 1.14 90/11/01 SMI
##################################################################
#
#         .login file
#
#         Read in after the .cshrc file when you log in.
#         Not read in for subsequent shells.  For setting up
#         terminal and global environment characteristics.
#
##################################################################

set nowin=0
#  Uncomment this line if you do NOT want to enter a windowed environment
#  automatically upon login.
#set nowin=1

#         terminal characteristics for remote terminals:

# set this variable to the terminal type that you want as a default.
set defterm="vt100"

# Determines terminal type.
#

if ($TERM != "sun") then
set noglob
eval `tset -sQ -m dialup:?$defterm -m network:?$defterm -m dumb:?$defterm $TERM`
unset noglob
endif

#         general terminal characteristics

#stty -crterase
#stty -tabs
#stty crt
#stty erase '^h'
#stty werase '^?'
#stty kill '^['
#stty new

#         commands to perform at login

#w         # see who is logged in

# if /usr/local/etc/.login.gsb exists, add definitions

if( -e /usr/local/etc/.login.gsb ) source /usr/local/etc/.login.gsb

#  place local definitions here
#         environment variables
#  script will automatically insert variables and aliases that are found
#  in the old .login here.  uncommenting global variables may disturb the
#  setup -- do so with care.
#setenv EXINIT 'set sh=/bin/csh sw=4 ai report=2'
#setenv MORE '-c'
setenv PRINTER 	s330ps2

#
# If possible, start the windows system.  Give user a chance to bail out
#
if ( `tty` != "/dev/console" || $TERM != "sun" ) then
 	exit	# leave user at regular C shell prompt
endif

#
# If nowin defined, do not start windowed environment.
#
if ( $nowin == 1 ) then
 	exit	# leave user at regular C shell prompt
endif

if ( ${?OPENWINHOME} == 0 ) then 	
  setenv OPENWINHOME /usr/openwin
endif           		

if ( ! -e $OPENWINHOME/bin/openwin ) then
	set mychoice=sunview
endif

echo ""
#click -n	# click -n turns off key click

echo ""
switch( $mychoice )
case	openwin:
	unset mychoice
  	echo -n "Starting OpenWindows (type Control-C to interrupt)"
  	sleep 5
	$OPENWINHOME/bin/openwin
	clear_colormap	# get rid of annoying colourmap bug
	clear		# get rid of annoying cursor rectangle
	echo -n "Automatically logging out (type Control-C to interrupt)"
	sleep 5
	logout		# logout after leaving windows system
	breaksw
	#
case	sunview:
	unset mychoice
	echo -n "Starting SunView (type Control-C to interrupt)"
	sleep 5
	# default sunview background looks best with pastels
	sunview
	clear		# get rid of annoying cursor rectangle
	echo -n "Automatically logging out (type Control-C to interrupt)"
	sleep 5
	logout		# logout after leaving windows system
	breaksw
	#
case	x11r5:
	unset mychoice
	echo -n "Starting X11R5 (type Control-C to interrupt)"
	sleep 5
	/usr/local/X11R5/bin/startx
	clear
	echo -n "Automatically logging out (type Control-C to interrupt)"
	sleep 5
	logout
	breaksw
	#
endsw


#  add personal aliases and variables here
