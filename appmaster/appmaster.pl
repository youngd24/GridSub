#!/usr/bin/perl
##############################################################################
#
# appmaster.pl
#
# Grid Master Application Runner
#
# Copyright (C) 2017 The University of Chicago
#
# Darren Young <darren.young@gsb.uchicago.edu>
# maintainer: nme@chicagobooth.edu
#
##############################################################################

##############################################################################
#                             B E G I N
##############################################################################
BEGIN {

		require 5.10.0;
    # Pragmas
    use strict;

    # "Standard" modules we use
    use File::Basename ();
    use Switch;
    our $NAME    = File::Basename::basename($0);
    
}


##############################################################################
#                            M A I N   S C R I P T
##############################################################################
#####
# change names/assignments of queues here
    my $longQueue = "long";
    my $shortQueue = "short";
    my $highmemQueue = "highmem";
    my $gpuQueue = "gpu";
####
		my @facNodeQueues = ("arao0", "ezwick", );
#####

my $numargs    = $#ARGV + 1;

my ($queue, $opts) = getQueue();


logmsg("AppMaster called as $NAME");
logmsg("Argument count: $numargs");
logmsg("going to queue: $queue");
logmsg("with options: $opts");

if ( $NAME =~ "appmaster.pl" ) {
    logmsg("Incorrect usage");
    exit(0);
}

# No args, must be interactive
if ( $numargs == 0 ) {
    if ( $NAME =~ "batch*") {
        logmsg("You must supply an argument to batch mode");
        exit(0);
    }
    logmsg("No arguments, running interactively");
    $retval = runapp($NAME);
    exit($retval);
} else {
    if ( $ARGV[0] =~ /help/ ) {
        system("boothhelp batch");
        exit(0);
    }

    logmsg("Args given, evaluating");
    if ( $NAME =~ "batch*" ) {
        logmsg("Batch mode requested");

        ### run it
        runapp($NAME, $ARGV[0], $ARGV[1]);
        exit(0);
    } elsif ( $NAME =~ "gpu*" ){
        logmsg("requesting gpu");
        runapp($NAME, $ARGV[0], $ARGV[1]);
        exit(0);
    } elsif ( $NAME =~ "highmem*" ){
        logmsg("requesting highmem");
        runapp($NAME, $ARGV[0], $ARGV[1]);
        exit(0);
    } elsif ( $NAME =~ "long*" ){
        logmsg("requesting longrun");
        runapp($NAME, $ARGV[0], $ARGV[1]);
        exit(0);
    } else {
        logmsg("You can't give args to a non batch application");
        exit(0);
    }
}

##############################################################################
#                              F U N C T I O N S 
##############################################################################
sub runapp {
    my ($app, $infile, $outfile) = @_;
    my $name = "runapp";
    my $syscmd = "";
    logmsg("DEBUG: App called by name $app");
    logmsg("DEBUG: called as $app");
    # if there's a dash in the name, strip the leading part off before sending to the node
    unless ($app !~ '-') {
      ($app) = $app=~ /-\s*(.*)\s*$/;
    }
    logmsg("DEBUG: running as $app");
    # If they gave us args, assume they want batch mode of that app
    # and that the arguments are to be passed to the called app
    if ( $infile ) {
        my $batchapp = File::Basename::basename($app);
        logmsg("$name: Running app '$batchapp' in batch mode");
        my $tmpfile = "/tmp/$NAME-$<.$$";
        logmsg("TMPFILE: $tmpfile");
        open(TMPFILE, ">$tmpfile") or die "Unable to open tmp file: $?\n";

        # Build common information
        print TMPFILE '#!/bin/bash' . "\n";
        print TMPFILE '#$ -S /bin/bash' . "\n";
        print TMPFILE '#$' . " -o $ENV{HOME}/batch.out" . "\n";
        print TMPFILE '#$' . " -e $ENV{HOME}/batch.err" . "\n";

        print TMPFILE '/apps/dispatcher/bin/' . $batchapp . " $infile $outfile\n";

        close(TMPFILE);

        $syscmd = "qsub -cwd -q $queue $opts $tmpfile";
        logmsg("Submit: $syscmd");
        $retval = system($syscmd);
        logmsg("Cleaning up");
        unlink($tmpfile) || logmsg("Unable to remove temp file");
        return($retval);
   
    # No args, must be interactive
    } else {
        $syscmd = "qrsh -verbose  -q $queue -b y /apps/dispatcher/bin/$app";
        logmsg("$name: command is $syscmd");
        my $retval = system($syscmd);
        return($retval);
    }

}

sub getQueue {
    use feature qw(switch);
    $opts = "";
		if( $user ~~ @facNodeQueues ){ 
			$queue = $user;
			logmsg("user has own node; going to queue $queue");
		}
    #send to large memory node
    elsif($NAME =~ "highmem*") {
      logmsg("send to $highmemQueue");
      $queue = $highmemQueue;
    }
    #send to GPU nodes
    elsif($NAME =~ "gpu*") {
      logmsg("send to $gpuQueue");
      $queue = $gpuQueue;
      $opts = "-l gpu=1";
    }
    #send to long-running queues
    elsif($NAME =~ "long*") {
      logmsg("send to $longQueue");
      $queue = $longQueue;
    }
		else {
      $queue = $shortQueue
		}
 return $queue, $opts;
}

sub logmsg {
    my $message = shift;

    print "MASTER: $message\n";

    return(1);
}
