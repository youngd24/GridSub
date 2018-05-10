###############################################################################
#
# logging.pm
#
# General Purpose logging module
#
# Copyright (C) 2004-2010 The University of Chicago
#
# Darren Young <darren.young@chicago*.edu>
#
###############################################################################
#
# NOTES:
# ------
#
###############################################################################


###############################################################################
#                                  B E G I N
###############################################################################
BEGIN {
	
	# Pragmas
    use strict;
    use warnings;

    # "Standard" modules we use
    use FindBin;
    use POSIX qw(strftime);
    
    # Our library path(s)
    use lib "$FindBin::Bin/lib";

	# Our modules we use
	use config;
	use logging;
}


###############################################################################
#                      P A C K A G E   V A R I A B L E S
###############################################################################
package logging;


###############################################################################
# NAME        : logmsg
# DESCRIPTION : Print a formatted log message to a file handle
# ARGUMENTS   : OPTIONAL: scalar(fh)
#             : REQUIRED: scalar(message)
# RETURN      : True
# NOTES       : None
###############################################################################
sub logmsg {

    my ($package, $filename, $line, $subr) = caller();
    my $message;
    my $fh;

    # 1 arg form vs 2 arg form
    if ( $#_ == 0 ) {       # got 1 arg, assume dest is STDOUT
        $fh = STDOUT;
        $message = $_[0];
    } elsif ( $#_ == 1 ) {  # got 2, they want the message somewhere else
        $fh = $_[0];
        $message = $_[1];
    }

    my $n = POSIX::strftime "%Y-%m-%d %H:%M:%S", localtime(time());
    print $fh "[$n] $package(): $message\n";

    return(1);
}


# #############################################################################
# NAME        : debug
# DESCRIPTION : Print a debug formatted log message to a file handle
# ARGUMENTS   : OPTIONAL: scalar(fh)
#             : REQUIRED: scalar(message)
# RETURN      : True
# NOTES       : Set a package level variable DEBUG to enable/disable these
# #############################################################################
sub debug { 

    my $message;
    my $fh;

    # 1 arg form vs 2 arg form
    if ( $#_ == 0 ) {       # got 1 arg, assume dest is STDOUT
        $fh = STDOUT;
        $message = $_[0];
    } elsif ( $#_ == 1 ) {  # got 2, they want the message somewhere else
        $fh = $_[0];
        $message = $_[1];
    }

    if ( $main::DEBUG ) {
        logmsg($fh, "DEBUG: $message");
        return(1); 
    } else {
        return(1);
    }
} 


# return true
1;
