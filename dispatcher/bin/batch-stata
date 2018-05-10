#!/usr/bin/perl
##############################################################################
#
# dispatcher.pl
#
# Local Grid Application Dispatcher
#
# Copyright (C) 2008 The University of Chicago
#
# Darren Young <darren.young@gsb.uchicago.edu>
#
# $Id$
#
##############################################################################
#
# CHANGELOG
# ---------
# $Log$
##############################################################################
### TODO (migration)
#	1) get/pass queue
# 2)	get rid of ARch
# 3)
##############################################################################
#                             B E G I N
##############################################################################
BEGIN {

    # Pragmas
    use strict;

    # "Standard" modules we use
    use File::Basename ();
    use Switch;
    use Sys::Hostname;
our $NAME    = File::Basename::basename($0);

}


##############################################################################
#                            M A I N   S C R I P T
##############################################################################
my $logfile    = '/apps/dispatcher/bin/dispatcher.log';
my $uname_cmd  = "uname -s";
my $arch       = `$uname_cmd`; chomp($arch);
my $numargs    = $#ARGV + 1;
my $appbase    = "/apps";
my $scratchdir = "/grid_temp";
my $host       = hostname();
my $username   = $ENV{'LOGNAME'};
#where to get this from ?   my $queue   	 = ;
my $infile;
my $outfile;

$ENV{'LD_LIBRARY_PATH'} = '/apps/knitro/lib';
$ENV{'ZIENA_LICENSE_NETWORK_ADDR'} = "10.135.211.150:8349";

logmsg("Display: $ENV{'DISPLAY'}");
logmsg("Dispatcher on $host called as $NAME by user $username");
logmsg("arch detected as '$arch' via command '$uname_cmd'");
logmsg("Argument count: $numargs");

# No args, must be interactive
if ( $numargs == 0 ) {
    logmsg("No args, assuming interactive");
    $retval = runapp($NAME);
    exit($retval);
} else {
    logmsg("Args given, assuming batch");
    $infile = $ARGV[0];
    $outfile = $ARGV[1];
    logmsg("Batch mode requested");
    ## prepend batch- to work wit existing links
    $NAME = "batch-".$NAME;
	  logmsg("calling runapp with args $NAME, $infile, $outfile");
    runapp($NAME, $infile, $outfile);
    exit(0);
}





##############################################################################
#                              F U N C T I O N S 
##############################################################################
sub runapp {
    my ($app, $infile, $outfile) = @_;
    my $name = "runapp";
    my $syscmd = "";

    if ( $infile ) {
        logmsg("$name: Running in batch mode");
        logmsg("$name: Running $arch app $app in batch mode with args:");
        logmsg("$name:    infile  => $infile");
        logmsg("$name:    outfile => $outfile");

        ### STATA (All types)
        if ( $app =~ /batch-stata*/ ) {

            # Set TMPDIR for Stata to be the grid scratch dir
            $ENV{'TMPDIR'} = $scratchdir;
            logmsg("$name: Stata temp dir set to: " .  $ENV{'TMPDIR'});

            # Switch on the various stata types
            if ( $app eq "batch-stata" ) {
                $syscmd = "$appbase/bin/stata -b do $infile";
            } elsif ( $app eq "batch-stata-se" ) { 
                $syscmd = "$appbase/bin/stata-se -b do $infile";
            } elsif ( $app eq "batch-stata-mp" ) { 
                $syscmd = "$appbase/bin/stata-mp -b do $infile";
            } else {
                logmsg("$name: Invalid stata type requested ($app)");
                return(0);
            }
        }

        ### SAS
        if ( $app =~ /batch-sas/ ) {
            $syscmd = "$appbase/bin/sas -work /scratch $infile";
        }

        ### SAS Noterm
        ### needed for PROC IMPORT and EXPORT
        if ( $app =~ /batch-sas-noterminal/ ) {
            $syscmd = "$appbase/bin/sas -noterminal $infile";
        }

        ### SAS
        if ( $app =~ /batch-sasmem/ ) {
            $syscmd = "$appbase/bin/sas -work /scratch -memsize 0 -sortsize 0 $infile $outfile";
        }

        ### BATCH-JAVA
        if ( $app =~ /batch-java/ ) {
            $syscmd = "$appbase/bin/java $infile";
        }

        ### MATLAB
        if ( $app =~ /batch-matlab/ ) {
            # If they gave us an out file, use that, otherwise generate one for them
            if ( $outfile ) {
               # $syscmd = "$appbase/bin/matlab -nodisplay -nosplash -nojvm $infile -logfile $outfile";
                $syscmd = "$appbase/bin/matlab -nodisplay -nosplash -r $infile -logfile $outfile 2>&1";
            } else {
                $syscmd = "$appbase/bin/matlab -nodisplay -nosplash -r $infile -logfile batch-matlab.out 2>&1";
               # $syscmd = "$appbase/bin/matlab -nodisplay -nosplash $infile > batch-matlab.out 2>&1";
            }
        }

        ### MATLAB
        if ( $app =~ /batch-matlab-gpu/ ) {
            # If they gave us an out file, use that, otherwise generate one for them
            if ( $outfile ) {
               # $syscmd = "$appbase/bin/matlab-gpu -nodisplay -nosplash -nojvm $infile -logfile $outfile";
                $syscmd = "$appbase/bin/matlab-gpu -nodisplay -nosplash -r $infile -logfile $outfile 2>&1";
            } else {
                $syscmd = "$appbase/bin/matlab-gpu -nodisplay -nosplash -r $infile -logfile batch-matlab.out 2>&1";
               # $syscmd = "$appbase/bin/matlab-gpu -nodisplay -nosplash $infile > batch-matlab.out 2>&1";
            }
        }

        ### MATLAB-ALT
        if ( $app =~ /batch-matlab-alt/ ) {
            # If they gave us an out file, use that, otherwise generate one for them
            if ( $outfile ) {
                $syscmd = "$appbase/bin/matlab -nodisplay -nosplash $infile -logfile $outfile";
                #$syscmd = "$appbase/bin/matlab -nodisplay -nosplash -r $infile -logfile $outfile 2>&1";
            } else {
                $syscmd = "$appbase/bin/matlab -nodisplay -nosplash $infile -logfile batch-matlab.out 2>&1";
               # $syscmd = "$appbase/bin/matlab -nodisplay -nosplash $infile > batch-matlab.out 2>&1";
            }
        }

        ### MATLAB-ALT
        if ( $app =~ /batch-matlab-nojvm/ ) {
            # If they gave us an out file, use that, otherwise generate one for them
            if ( $outfile ) {
                $syscmd = "$appbase/bin/matlab -nodisplay -nosplash -nojvm $infile -logfile $outfile";
                #$syscmd = "$appbase/bin/matlab -nodisplay -nosplash -r $infile -logfile $outfile 2>&1";
            } else {
                $syscmd = "$appbase/bin/matlab -nodisplay -nosplash -nojvm $infile -logfile batch-matlab.out 2>&1";
               # $syscmd = "$appbase/bin/matlab -nodisplay -nosplash $infile > batch-matlab.out 2>&1";
            }
        }

        ### XMATLAB
        if ( $app =~ /xmatlab/ ) {
            # Matlab GUI
            $syscmd = "$appbase/bin/matlab -desktop";
        }

        ### XMATLAB
        if ( $app =~ /xmatlab-gpu/ ) {
            # Matlab GPU GUI
            $syscmd = "$appbase/bin/matlab-gpu -desktop";
        }

        ### MATHEMATICA
        if ( $app =~ /batch-math/ ) {
            # If they gave us an out file, use that, otherwise generate one for them
            if ( $outfile ) {
                $syscmd = "$appbase/bin/math < $infile > $outfile 2>&1";
            } else {
                $syscmd = "$appbase/bin/math < $infile > batch-math.out 2>&1";
            }
        }

        ### SPLUS
        if ( $app =~ /batch-splus/ ) {
            # If they gave us an out file, use that, otherwise generate one for them
            if ( $outfile ) {
                $syscmd = "$appbase/bin/splus SBATCH -input $infile -output $outfile";
            } else {
                $syscmd = "$appbase/bin/splus SBATCH -input $infile -output batch-splus.out";
            }
        }

        ### BATCH-R
        if ( $app =~ /batch-R/ ) {
            # R Batch
            $syscmd = "$appbase/bin/batch-R < $infile > $outfile";
        }
        ### rstudio
        if ( $app =~ /Rstudio/ ) {
            # R Batch
            $syscmd = "$appbase/bin/rstudio";
        }

        ### int-R
        #if ( $app =~ /int-R/ ) {
            # R Batch
        #    $syscmd = "$appbase/bin/R --vanilla";
        #}

        logmsg("Command to be run: $syscmd");
        $retval = system($syscmd);
        return($retval);

    # No args, must be interactive
    } else {
        $syscmd = "$appbase/bin/$app";
        logmsg("$name: Running $arch app $app with args: $args");
        logmsg("$name: command is $syscmd");
        my $retval = system($syscmd);
        return($retval);
    }
}


sub logmsg {
    my $message = shift;

    print "DISPATCHER: $message\n";

    return(1);
}
