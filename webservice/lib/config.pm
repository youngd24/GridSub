###############################################################################
#
# config.pm
#
# Grid Web Service Config Module
#
# Copyright (C) 2003-2010 The University of Chicago
#
# Darren Young <darren.young@chicago*.edu>
#
#
###############################################################################
#
# NOTES:
# ------
# 12/04/13 - AW - Updated home directory paths and GIDs 
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
	use homedirs;
	use logging;
}


###############################################################################
#                      P A C K A G E   V A R I A B L E S
###############################################################################
# Define all of the global configuration hashes (GCH) here
# Scope them as "our" so everyone can access them
###############################################################################
package config;

our $GCH_HOMEDIR;			### Base location to create user home directories
our $GCH_GID;				### Group ID's for account classes



###############################################################################
#            G L O B A L   C O N F I G U R A T I O N   H A S H E S
###############################################################################
# Put the actual data for the global configuration hashes in here
###############################################################################

###
$GCH_HOMEDIR{"m"} = "/wsHomes/mba";
$GCH_HOMEDIR{"tm"} = "/wsHomes/mba";
$GCH_HOMEDIR{"p"} = "/wsHomes/phd";
$GCH_HOMEDIR{"f"} = "/wsHomes/fac";
$GCH_HOMEDIR{"ts"} = "/wsHomes/staff";
$GCH_HOMEDIR{"gf"} = "/wsHomes/collab";

###
$GCH_GID{"m"} = "40";
$GCH_GID{"tm"} = "40";
$GCH_GID{"p"} = "30";
$GCH_GID{"f"} = "35";
$GCH_GID{"ts"} = "10";
$GCH_GID{"gf"} = "35";
1;
