#!/bin/bash

#######################################
# Execute and print command
# Arguments:
#  @ command statement
#######################################
function try() {
  echo "run: $(printf '"%s" ' "${@}")"
  "${@}"
}

#######################################
# Execute and print command from URL
# Arguments:
#  1 script URL
#  @ script parameters
#######################################
function try.from() {
  # shellcheck disable=SC2145
  echo "run: curl $1 | bash -s -- ${@:2}"
  curl "$1" | bash -s -- "${@:2}"
}

#######################################
# Print message and exit
# Arguments:
#   1 message
#   2 code
#######################################
function throw() {
  echo "${1:-}"
  exit "${2:-1}"
}

#######################################
# Capture fail status of  before execution and execute a new command statement
# Arguments:
#  @ command statement
#######################################
function catch() {
  if [[ $? -ne 0 ]]; then
    "$@"
  fi
}