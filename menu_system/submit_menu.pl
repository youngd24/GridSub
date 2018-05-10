#!/usr/bin/perl
##############################################################################
# test
# APPmaster.pl
#
# Grid Master Application Runner
#
# Copyright (C) 2013 The University of Chicago Booth School of Business
#
# Darren Young <darren.young@gsb.uchicago.edu>
# Nathan Earixson <nme@chicagobooth.edu>
#
# $Id$
#
##############################################################################
#
# CHANGELOG
# ---------
# $Log$
##############################################################################

##############################################################################
#                             TODO
#
#
# supply defualt in/out file names
# args doesn't do anything yet.
##############################################################################


##############################################################################
#                             B E G I N
##############################################################################
BEGIN {

    # Pragmas
    use strict;

    # "Standard" modules we use
    use File::Basename ();
    use Switch;
    use Term::Menu;
}


##############################################################################
#                            M A I N   S C R I P T
##############################################################################
# create menu:
#
##
system 'clear';
print "\n\nWelcome to the Chicago Booth Research Computing Grid\nPlease Choose from the menu below\n\nFor help see http://grid.chicagobooth.edu\n\n\n";

my $session_type,$program_called,$queue_requested,@args,$infile,$outfile;

my $prompt = new Term::Menu (
    #beforetext => "\n\nWelcome to the Chicago Booth Research Computing Grid\nPlease Choose from the menu below\n\nFor help see http://grid.chicagobooth.edu\n",
    aftertext =>  "Enter an option: ",
    tries =>  3,            
    spaces =>  2            
    );
#
# Choose Batch or Interactive
  my $answer = $prompt->menu(
        batch            =>        ["Submit a BATCH job", '1'],
        interactive      =>        ["Start an INTERACTIVE session", '2'],
  );
  $session_type = $prompt->lastval;

##############################################################################
# if BATCH

if ( $session_type =~ "batch" ) {
  my $answer = $prompt->menu(
        stata    =>        ["Submit stata batch job", '1'],
        "stata-mp" =>        ["Submit stata-mp batch job", '2'],
        SAS      =>        ["Submit SAS batch job", '3'],
        matlab   =>        ["Submit MATLAB batch job", '4'],
  );
  $program_called = $prompt->lastval;
# Prompt for queue
  my $answer = $prompt->menu(
        highmem  =>         ["For Jobs that are Memory Intensive", '1'],
        lowmem   =>         ["For Jobs That Are CPU Intensive", '2'],
        GPU      =>         ["To utilize GPU processors", '3'],
        MPI      =>         ["To use OpenMPI", '4'],
  );
  $queue_requested = $prompt->lastval;
# args: string or array? 
  #@args= $prompt->question("Enter any arguments to pass to the program: ");
  $infile= $prompt->question("Enter the name of your input file: ");
  $outfile= $prompt->question("Enter the name out your output file: ");
  chomp($infile,$outfile);
}

##############################################################################
# if  INTERACTIVE

elsif ( $session_type =~ "interactive" ) {
  my $answer = $prompt->menu(
        stata    =>        ["Start a stata session", '1'],
        "stata-mp" =>        ["Start a stata-mp session", '2'],
        "xstata-mp" =>       ["Start an X-stata-mp session", '3'],
        SAS      =>        ["Start a SAS session", '4'],
        matlab   =>        ["Start a matlab session", '5'],
        R   =>             ["Start an R session", '6'],
  );
  $program_called = $prompt->lastval;
# Prompt for queue
  my $answer = $prompt->menu(
        highmem  =>         ["For Jobs that are memory intensive", '1'],
        lowmem   =>         ["For Jobs That Are More CPU Intensive", '2'],
        GPU      =>         ["To utilize GPU processors", '3'],
        MPI      =>         ["To use OpenMPI", '4'],
  );
  $queue_requested = $prompt->lastval;
}


##############################################################################
print "DEBUG: $session_type,$program_called,$queue_requested,$infile,$outfile,@args\n";
logmsg("$session_type,$program_called,$queue_requested,$infile,$outfile,@args");
#exit(0);




# orig code:
my $numargs    = $#args + 1;

logmsg("AppMaster called as $program_called");
logmsg("Queue requested is $queue_requested");
logmsg("Argument count: $numargs");

if ( $program_called =~ "appmaster.pl" ) {
    logmsg("Incorrect usage");
    exit(0);
}

# No args, must be interactive
if ( $numargs == 0 ) {
    if ( $program_called =~ "batch*") {
        logmsg("You must supply an argument to batch mode");
        exit(0);
    }
    logmsg("No arguments, running interactively");
    $retval = runapp($program_called);
    exit($retval);
} else {
    if ( $ARGV[0] =~ /help/ ) {
        system("boothhelp batch");
        exit(0);
    }

    logmsg("Args given, evaluating");
    if ( $program_called =~ "batch*" ) {
        logmsg("Batch mode requested");

        ### run it
        runapp($program_called, $infile, $outfile);
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

    # If they gave us args, assume they want batch mode of that app
    # and that the arguments are to be passed to the called app
    if ( $infile ) {


        my $batchapp = File::Basename::basename($app);
        logmsg("$name: Running app '$batchapp' in batch mode");
        my $tmpfile = "/tmp/$program_called-$<.$$";
        logmsg("TMPFILE: $tmpfile");
        open(TMPFILE, ">$tmpfile") or die "Unable to open tmp file: $?\n";

        # Build common information
        print TMPFILE '#!/bin/bash' . "\n";
        print TMPFILE '#$ -S /bin/bash' . "\n";
        print TMPFILE '#$' . " -o $ENV{HOME}/batch.out" . "\n";
        print TMPFILE '#$' . " -e $ENV{HOME}/batch.err" . "\n";

        print TMPFILE '/opt/gsb/apps/bin/' . $batchapp . " $infile $outfile\n";

        close(TMPFILE);

        $syscmd = "qsub -cwd -q $queue $tmpfile";
        logmsg("Submit: $syscmd");
        $retval = system($syscmd);
        logmsg("Cleaning up");
        unlink($tmpfile) || logmsg("Unable to remove temp file");
        return($retval);
   
    # No args, must be interactive
    } else {
        $syscmd = "qrsh -verbose -q highmem.q -b y /opt/gsb/apps/bin/$app";
        logmsg("$name: command is $syscmd");
        my $retval = system($syscmd);
        return($retval);
    }

}


sub logmsg {
    my $message = shift;

    print "MASTER: $message\n";

    return(1);
}

