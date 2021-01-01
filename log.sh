#!/usr/bin/env bash
# ======================================================================
#
# NAME
#
#     log.sh
#
# DESCRIPTION
#
#     A library of bash functions for writing formatted log messages to
#     standard output and standard error.
#
# USAGE
#
#     If you would like to use this library in your bash script, then 
#     source it at the beginning of your bash script.
#
#         source log.sh
#
#     Once the library has been sourced, you can call functions from the 
#     library in your bash script.
#
# AUTHOR
#
#     Marty Kandes, Ph.D.
#     Computational & Data Science Research Specialist
#     High-Performance Computing User Services Group
#     San Diego Supercomputer Center
#     University of California, San Diego
#
# LAST UPDATED
#
#     Monday, December 28th, 2020
#
# ----------------------------------------------------------------------

log::output() {

  echo "${@}" >&1

}

log::error() {

  echo "ERROR :: ${@}" >&2

}

log::warning() {

  echo "WARNING :: ${@}" >&2

}

# ======================================================================
