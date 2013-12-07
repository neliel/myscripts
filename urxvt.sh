#!/bin/bash
#@(#)----------------------------------------------------------------------
#@(#) OBJET            : urxvt daemon and client launcher
#@(#)----------------------------------------------------------------------
#@(#) AUTEUR           : Kapasi Sarfraz
#@(#) DATE DE CREATION : 16.11.2013
#@(#) VERSION          : 0.0.0.1

#==========================================================================
#
# USAGE
#   ./urxvt.sh [urxvt_options]
#
# DESCRIPTION
#   Launch the urxvt daemon if not started and start client
#
# RETURN CODES
#   0    Normal end
#   1    Anormal end
#   3    urxvt command not found
#
# CODES NOTICE
#   3   Install the urxvt command
#
# OPTIONS
#   NOPE
#
# DEPENDENCIES
#   urxvt
#
#==========================================================================

#==========================================================================
# Functions
#==========================================================================
# NOPE
#==========================================================================
# Options
#==========================================================================
# NOPE
#==========================================================================
# Variables
#==========================================================================

URXVTC=urxvtc
URXVTD=urxvtd

#==========================================================================
# Environment
#==========================================================================

[ -z $URXVTC ] && exit 3
[ -z $URXVTD ] && exit 3

#==========================================================================
# Main
#==========================================================================

cd
$URXVTC "$@"
if [ $? -eq 2 ]; then
   $URXVTD -q -o -f
   $URXVTC "$@"
fi

#==========================================================================
# End sequence
#==========================================================================

exit 0
#0
