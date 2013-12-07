#!/bin/bash
#@(#)----------------------------------------------------------------------
#@(#) OBJET            : Moves torrent file to rtorrent watch folder
#@(#)----------------------------------------------------------------------
#@(#) AUTEUR           : Kapasi Sarfraz
#@(#) DATE DE CREATION : 11.11.2013
#@(#) VERSION          : 0.0.0.1

#==========================================================================
#
# USAGE
#   ./mvto.sh torrent_file.torrent
#
# DESCRIPTION
#   This script takes torrent files and moves it to rtorrent monitored
#    watch folder so that rtorrrent can start it
#
# RETURN CODES
#   0    Normal end
#   1    Anormal end
#   2    Torrent filepath might be incorect
#
# CODES NOTICE
#   2    Check script input
#
# OPTIONS
#   $1 : path to torrent file
#
# DEPENDENCIES
#   NOPE
#
#==========================================================================

#==========================================================================
# Functions
#==========================================================================
# NOPE
#==========================================================================
# Options
#==========================================================================

TORRENT_FILEPATH="$1"

#==========================================================================
# Variables
#==========================================================================

CUR=$(pwd)
WATCH_FOLDER=~/.watch

TORRENT_FILEPATH_BASENAME=$(basename "$TORRENT_FILEPATH")
TORRENT_FILEPATH_EXTENSION="${TORRENT_FILEPATH_BASENAME##*.}"

#==========================================================================
# Environment
#==========================================================================

[[ -z "$1" || $TORRENT_FILEPATH_EXTENSION -ne "torrent" ]] && exit 2

#==========================================================================
# Main
#==========================================================================

mv "$TORRENT_FILEPATH" $WATCH_FOLDER

#==========================================================================
# End sequence
#==========================================================================

exit 0
#0
