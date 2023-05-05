#!/bin/bash

#######################################
# Generate file from stub
# Arguments:
#   1 template
#   2 filename
#######################################
function azure::make::stub() {
  local key
  local new_key
  local filename
  local template

  filename="$2"
  template="$1"

  cp "${template}" "${filename}"

  while IFS= read -r key; do
    new_key=$(printf '%s' "${key}")
    sed -i "s/{{\s*$key\s*}}/${!new_key}/g" "${filename}"
  done < <(grep -oP '{{\s*\K([A-Za-z0-9_]+)(?=\s*}})' < "${template}")
}