###############################################################################
#
# homedirs.pm
#
# Manage grid home directories
#
# Copyright (C) 2003-2010 The University of Chicago
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
    
    # Various file modules
    use File::Copy;
    use File::Path qw(make_path remove_tree);
    use File::Find;
    
    # Our library path(s)
    use lib "$FindBin::Bin/lib";

	# Our modules we use
	use config;
	use logging;
}


###############################################################################
#                      P A C K A G E   V A R I A B L E S
###############################################################################
package homedirs;


###############################################################################
# NAME        : _make_homedir
# DESCRIPTION : Create a user home directory
# ARGUMENTS   : string(username), string(uid), string(type)
# RETURN      : 0 or 1
# NOTES       : 
###############################################################################
sub _make_homedir {
    my ( $uname, $uid, $actype ) = @_;
    my $name = "_make_homedir";
    logging::logmsg(STDERR, "$name: entering _make_homedirs()");

    my $homedir   = $config::GCH_HOMEDIR{$actype} . "/$uname";
    my @skelfiles = ( '.profile' );
    my $skelbase  = "$FindBin::Bin/skel";
    my $gid       = $config::GCH_GID{$actype};
    my $retval    = 1;

	### Log the info
    logging::logmsg(STDERR, "$name: homedir  => $homedir");
    logging::logmsg(STDERR, "$name: skelbase => $skelbase");
    logging::logmsg(STDERR, "$name:      gid => $gid");

	##############################################################################
    ### Create the home directory
	##############################################################################
    logging::logmsg(STDERR, "$name: Attempting to create directory: $homedir");
    if ( !-d $homedir ) {
        if ( mkdir( "$homedir", 0720 ) ) {
            logging::logmsg(STDERR, "$name: Created home directory: $homedir");
        } else {
			my $err = "FAILED to create home directory $homedir: $!";
            logging::logmsg(STDERR, "$name: $err");
            die($err);
        }
    } else {
		my $err = "FAILED to create directory $homedir: $homedir already exists";
        logging::logmsg(STDERR, "$name: $err");
        die("$err");
    }


	##############################################################################
    ### Change the ownership on the home directory
	##############################################################################
    logging::logmsg(STDERR, "$name: Attempting to change ownership on: $homedir");
    my $cnt = 0;
    $cnt = chown $uid, $gid, $homedir;
    if ( $cnt != 1 ) {
		my $err = "FAILED - home directory $homedir ownership not changed: $!";
        logging::logmsg(STDERR, "$name: $err");
        die($err);
    } else {
        logging::logmsg(STDERR, "$name: $homedir ownership changed to $uid:$gid");
        $retval = 1;
    }


    logging::logmsg(STDERR, "$name: returning with value: $retval");
    return ($retval);
}


###############################################################################
# NAME        : _remove_homedir
# DESCRIPTION : Remove a user home directory
# ARGUMENTS   : string(username), string(type)
# RETURN      : 0 or 1
# NOTES       : Not working yet
###############################################################################
sub _remove_homedir {
    my ( $uname, $actype ) = @_;
    my $name = "_remove_homedir";
    my ( $package, $filename, $line ) = caller;
    logging::logmsg("$name: entering with args @_");
    logging::logmsg( "$name: called from package->$package, filename->$filename, line->$line" );

    my $homedir   = $config::GCH_HOMEDIR{$actype} . "/$uname";
    my $retval    = 1;

	### Log the info
	logging::logmsg(STDERR, "$name: uname   => $uname");
	logging::logmsg(STDERR, "$name: actype  => $actype");
    logging::logmsg(STDERR, "$name: homedir => $homedir");

    if ( -d "$homedir" ) {
        if ( File::Path::rmtree( ["$homedir"] ) ) {
            $retval = 1;
            logging::logmsg("$name: removed home directory $homedir");
        } else {
            $retval = 0;
            logging::logmsg("$name: FAILED rmtree($homedir) for directory");
        }
    } else {
        logging::logmsg("$name: INFO home directory $homedir does not exist");
    }

    return($retval);
}

1;
