set os = `uname -r | awk '{print substr($0,1,1)}'`
if ($os == 4) then

# begin sunos .cshrc #########################################################

# @(#)Cshrc 1.5 90/11/01 SMI
#################################################################
#
#         .cshrc file
#
#         initial setup file for both interactive and noninteractive
#         C-Shells
#
#################################################################


# Set default window system by uncommenting one of the following
#set mychoice=sunview
set mychoice=openwin
#set mychoice=x11r5

# uncomment to use GNU utilities
#set use_gnu

#         set up search path

# add directories for local commands
set lpath = ( /home/crsp )

# add directories for linker
set ld_dirs =  /usr/local/lib 

# set manual search path
set man_dirs = /usr/local/man

if( ${?use_gnu} != 0 ) then
	set lpath = ( /usr/local/gnu/bin $lpath )
	set ld_dirs =  /usr/local/gnu/lib:$ld_dirs 
	set man_dirs = /usr/local/gnu/man:$man_dirs
endif

if ( ${?mychoice} != 0 ) then
	if ( ${mychoice} == "openwin" ) then
		setenv OPENWINHOME /usr/openwin
		set lpath = ( /usr/openwin/bin/xview /usr/openwin/bin $lpath )
		set ld_dirs =  $OPENWINHOME/lib:$ld_dirs 
		set man_dirs = $OPENWINHOME/man:$man_dirs
		cp $HOME/.xinitrc.ow $HOME/.xinitrc
	endif
	if ( ${mychoice} == "x11r5" ) then
		set X11HOME = /usr/local/X11R5
		set lpath = ( $X11HOME/bin $lpath )
		set ld_dirs = $X11HOME/lib:$ld_dirs
		set man_dirs = $X11HOME/man:$man_dirs
		cp $HOME/.xinitrc.x11r5 $HOME/.xinitrc
	endif
endif

# add lang directory (fortran 1.3.1)
set langpath =( ) ; set langmanpath = ( )
set langpath = (/usr/local/lang) ; set langmanpath = ($langpath/man)
set path = (. ~ ~/bin $lpath /usr/local/bin /usr/ucb $langpath \
	/usr/bin /usr/etc)

#         cd path

#set lcd = ( )  #  add parents of frequently used directories
#set cdpath = (.. ~ ~/bin ~/src $lcd)

#         set this for all shells

set noclobber

#         aliases for all shells

alias cd            'cd \!*;echo $cwd'
alias cp            'cp -i'
alias mv            'mv -i'
alias rm            'rm -i'
alias pwd           'echo $cwd'
#alias del          'rm -i'
#umask 002

# if general file exists, add definitions
if ( -e /usr/local/etc/.cshrc.gsb ) source /usr/local/etc/.cshrc.gsb

# file for extra personal cshrc definitions
set personalrc = ~/.cshrc.local
if ( -e $personalrc ) source $personalrc

# add language settings if using new language
if ($langpath != "" ) then
	set man_dirs = ${langmanpath}:$man_dirs
	setenv SUN_SOURCE_BROWSER_EX_FILE \
		/usr/local/lang/SC1.0/sun_source_browser.ex
	set ld_dirs = /usr/local/lang/SC1.0:$ld_dirs
endif

# set linker search path
setenv LD_LIBRARY_PATH $ld_dirs

# set man search path
setenv MANPATH ${man_dirs}:/usr/man

# add personal aliases and variables for all shells here.

#         skip remaining setup if not an interactive shell

if ($?USER == 0 || $?prompt == 0) exit

#          settings  for interactive shells

set history=40
set ignoreeof
#set notify
#set savehist=40
#set prompt="% "
set prompt="`hostname`{`whoami`}%\!: "
#set time=100

#          commands for interactive shells

#date
#pwd

#         other aliases

#alias a            alias
#alias h            'history \!* | head -39 | more'
#alias u            unalias

#alias             clear
#alias list         cat
#alias lock          lockscreen
#alias m             more
#alias mroe          more
#alias type         more

#alias .             'echo $cwd'
#alias ..            'set dot=$cwd;cd ..'
#alias ,             'cd $dot '

#alias dir          ls
#alias pdw           'echo $cwd'
#alias la            'ls -a'
#alias ll            'ls -la'
#alias ls           'ls -F'

#alias pd           dirs
#alias po           popd
#alias pp           pushd

#alias +w            'chmod go+w'
#alias -w            'chmod go-w'
#alias x             'chmod +x'

#alias j             'jobs -l'

#alias bye           logout
#alias ciao          logout
#alias adios         logout

#alias psg           'ps -ax | grep \!* | grep -v grep'
#alias punt          kill

#alias r            rlogin
#alias run          source

#alias nms 'tbl \!* | nroff -ms | more'                  # nroff -ms
#alias tms 'tbl \!* | troff -t -ms >! troff.output &'    # troff -ms
#alias tpr 'tbl \!* | troff -t -ms | lpr -t &'           # troff & print
#alias ppr 'lpr -t \!* &'                                # print troffed

#alias lp1           'lpr -P1'
#alias lq1           'lpq -P1'
#alias lr1           'lprm -P1'

#alias sd           'screendump | rastrepl | lpr -v &'

#alias edit         textedit

#alias help          man
#alias key           'man -k'

#alias mkae          make

#  script will automatically insert variables and aliases that are found
#  in the old .cshrc here.  uncommenting global variables may disturb the
#  setup -- do so with care.


#  add personal aliases and variables here

# end sunos .cshrc ###########################################################

else if ($os == 5) then

# begin solaris .cshrc ########################################################

set path=(/opt/local/SUNWspro/bin /usr/ucb /bin /usr/bin /opt/local/bin /opt/local/gnu/bin /opt/bin /usr/local/bin /usr/local/gnu/bin $path .)

set filec	# Set filename completion
set ignoreeof	# Ignore EOF for logout
set noclobber	# Check before overwriting files

umask 022

setenv HOST `/usr/ucb/hostname`
setenv PAGER more
setenv VISUAL /bin/vi
setenv MANPATH /usr/man:/opt/local/man:/opt/local/SUNWspro/man
setenv LD_LIBRARY_PATH /opt/local/SUNWspro/lib:/opt/local/lib:/opt/local/gnu/lib:/usr/lib:/usr/openwin/lib:/usr/ccs/lib:/lib:/usr/ucblib

if ($?prompt ) then
    set prompt="${HOST}:${PWD}>"
    set history=20
endif

# file for extra personal cshrc definitions
set personalrc = ~/.cshrc.local
if (-e $personalrc ) source $personalrc

# CRSP-specific stuff
set crsprc = /local/bin/crsprc.csh
if (-e $crsprc) source $crsprc

# end solaris .cshrc ##########################################################

endif
