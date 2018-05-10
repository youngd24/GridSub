#!/usr/bin/perl 
############################################################################
#
# UAMGridWebService.pl
#
# GRID Web Service
#
# Copyright (C) 2004-2007 The University of Chicago
#
# Darren Young <darren.young@gsb.uchicago.edu>
#
############################################################################
#
# CHANGELOG
# ---------
#
############################################################################
#
# NOTES
# -----
#
############################################################################


############################################################################
#                               B E G I N
############################################################################

use lib '/util/webservice/lib';
use lib '/util/webservice/lib';

use GRIDLIB;

use SOAP::Lite +trace => all;
use SOAP::Transport::HTTP;

############################################################################
#                      P A C K A G E   V A R I A B L E S
############################################################################

BEGIN { open(STDERR, '>>/util/webservice/log/UAMGridWebService.log'); }


SOAP::Transport::HTTP::CGI 
  -> dispatch_to('GRIDLIB')
  -> handle;

