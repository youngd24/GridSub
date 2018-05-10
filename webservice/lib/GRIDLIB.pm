###############################################################################
#
# GRIDLIB.pm
#
# GRID WebService Interface Module
#
# Copyright (C) 2004-2010 The University of Chicago
#
# Darren Young <darren.young@chicago*edu>
#
###############################################################################
#
# NOTES:
# ------
# * The calling client will always expect a string value for the return.
#   - Return SUCCESS or FAILED to indicate good/bad status.
#   - One of these days figure out how to cast an int or bool return
# * Perl die() will send a SOAP fault (exception) to the caller with the die
#   message as the SOAP fault message.
#
###############################################################################


###############################################################################
#                                 B E G I N
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
	use homedirs;
	use logging;
}


###############################################################################
#                      P A C K A G E   V A R I A B L E S
###############################################################################
package GRIDLIB;


###############################################################################
# NAME        : ServiceTester
# DESCRIPTION : Method that returns if the service works
# ARGUMENTS   : object($self)
# RETURN      : string
# NOTES       : None
###############################################################################
sub ServiceTester {
    my ( $self ) = @_;
    my $name = "ServiceTester";
    logging::logmsg(STDERR, "$name: entering ServiceTester()");
    logging::logmsg(STDERR, "$name: self => $self");

	logging::logmsg(STDERR, "$name: returning service operational");
    return("Service Operational");
}


###############################################################################
# NAME        : InitAccount
# DESCRIPTION : Initialize a grid account
# ARGUMENTS   : object($self), string(username), string(userid), string(type)
# RETURN      : 0 or 1
# NOTES       : None
###############################################################################
sub InitAccount {
    my ( $self, $uname, $uid, $actype ) = @_;
    my $name = "InitAccount";
    logging::logmsg(STDERR, "$name: entering InitAccount()");
    
    # Log what we received
    logging::logmsg(STDERR, "$name: self   => $self");
    logging::logmsg(STDERR, "$name: uname  => $uname");
    logging::logmsg(STDERR, "$name: uid    => $uid");
    logging::logmsg(STDERR, "$name: actype => $actype");
    
    my $retval;
    
    # Create the home directory
    logging::logmsg(STDERR, "$name: calling _make_homedir()");
    if ( homedirs::_make_homedir($uname, $uid, $actype)) {
		logging::logmsg(STDERR, "$name: Created homedir for $uname");
		$retval = "SUCCESS";
	} else {
		logging::logmsg(STDERR, "$name: FAILED to create homedir for $uname");
		$retval = "FAILED";
	}
	
	return($retval);
}


###############################################################################
# NAME        : DeleteAccount
# DESCRIPTION : Delete a grid account
# ARGUMENTS   : object($self), string(username), string(type)
# RETURN      : 0 or 1
# NOTES       : None
###############################################################################
sub DeleteAccount {
    my ( $self, $uname, $actype ) = @_;
    my $name = "DeleteAccount";
    logging::logmsg(STDERR, "$name: entering DeleteAccount()");
    
    # Log what we received
    logging::logmsg(STDERR, "$name: self   => $self");
    logging::logmsg(STDERR, "$name: uname  => $uname");
    logging::logmsg(STDERR, "$name: actype => $actype");
    
    my $retval;
    
    # Delete the home directory
    logging::logmsg(STDERR, "$name: calling _remove_homedir()");
    if ( homedirs::_remove_homedir($uname, $actype)) {
		logging::logmsg(STDERR, "$name: Removed homedir for $uname");
		$retval = "SUCCESS";
	} else {
		logging::logmsg(STDERR, "$name: FAILED to remove homedir for $uname");
		$retval = "FAILED";
	}
	
	return($retval);
}

1;