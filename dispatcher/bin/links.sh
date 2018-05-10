#!/bin/bash
#
# Script to make links to local grid app dispatcher
#
# Darren Young <darren.young@chicagogsb.edu>
APPS="stata \
      stataSE \
      stataMP \
      sas \
      sasNoterminal \
      matlab \
      mathematica \
      math \
      R"

DESTPGM="dispatcher.pl"


if [ "$1" == "create" ]; then
    echo "Creating links..."

    # create app links
    for APP in $APPS; do
        if [ ! -e $APP ]; then
            echo "link $DESTPGM to $APP"
            ln -s $DESTPGM $APP
            ln -s $DESTPGM batch-$APP
            ln -s $DESTPGM highmem-$APP
            ln -s $DESTPGM gpu-$APP
            ln -s $DESTPGM long-$APP
  
        fi
    done
elif [ "$1" == "delete" ]; then
    echo "Removing app links"

    for APP in $APPS; do
        if [ -e $APP ]; then
            echo "Remove $APP"
            rm $APP
            rm batch-$APP
            rm highmem-$APP
            rm gpu-$APP
            rm long-$APP
        fi
    done
else
    echo "Usage: `basename $0` <create|delete>"
fi

exit
