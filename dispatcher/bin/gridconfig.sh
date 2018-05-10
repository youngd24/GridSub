#!/bin/sh

if [ $LOGNAME != "root" ]; then
    
    if [ ! -f $HOME/.nogrid -a ! -f $HOME/.gridready ]; then

        clear
    
        echo "Configuring account for the Booth grid"

        ### create the ssh dir if necessary
        if [ ! -d $HOME/.ssh ]; then
	        mkdir $HOME/.ssh
	        chmod 0700 $HOME/.ssh
        fi


        ### if the user doesn't have an ssh rsa keypair, generate it
        if [ ! -f $HOME/.ssh/id_rsa.pub ]; then
	        /usr/bin/ssh-keygen -C "$LOGNAME@chicagobooth.edu" -N "" -t rsa -b 1024 -f $HOME/.ssh/id_rsa
        fi


        ### if their rsa key isn't in the authorized key file, add it
        if [ ! -f $HOME/.ssh/authorized_keys ]; then
	        if [ -f $HOME/.ssh/id_rsa.pub ]; then
		        cat $HOME/.ssh/id_rsa.pub > $HOME/.ssh/authorized_keys
	        fi
        else 
	        if [ -f $HOME/.ssh/id_rsa.pub ]; then
		        cat $HOME/.ssh/id_rsa.pub >> $HOME/.ssh/authorized_keys
	        fi
        fi

        ### clean out their old .profile and .bashrc (if it's there
        if [ -f $HOME/.profile ]; then
            mv $HOME/.profile $HOME/.profile.nogrid
        fi

        if [ -f $HOME/.bashrc ]; then
            mv $HOME/.bashrc $HOME/.bashrc.nogrid
        fi

        touch $HOME/.gridready
        echo ""
        echo "*** NOTE ***"
        echo "Your account is ready, please logout and back on for changes to take effect"

    fi

fi

