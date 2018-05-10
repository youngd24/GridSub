#!/bin/bash
###############################################################################
#
# sge-date.sh
#
# SGE sample script that runs the sleep command
#
# Darren Young [darren.young@gsb.uchicago.edu]
#
# $Id$
#
###############################################################################
#
# A very simple example to obtain the date of a compute node
#
###############################################################################
#
#$ -S /bin/bash
#$ -o $HOME/sge-date.stdout
#$ -e $HOME/sge-date.stderr
#$ -cwd
#
###############################################################################

TIME="60"
sleep $TIME
