#!/bin/bash


#######################################
# Generate environment file with environment variable matches in a template
# Arguments:
#   1 file to generate
#   2 template
#   3 data source environment variable name pattern
#######################################
function azure::make::env() {
  local key
  local hash
  local script
  local new_key
  local matches
  local temporal
  local target=${1:-.env}
  local template=${2:-.env.example}
  # shellcheck disable=SC2016
  local var_pattern=${3:-'$%s'}

  hash=$(date +"%N")
  script=.env.${hash}.sh
  matches=.env.temporal
  temporal=.env.azure.sh

  grep -Po '^(#*\w+)=' "${template}" > ${matches}

  # Region - Generate file script
  echo "#!/usr/bin/env bash" > "${script}"
  echo "cat <<EOF > ${temporal}" >> "${script}"

  while IFS='=' read -r key; do
      key=${key//=/}
      if echo "$key" | grep -q "^#"; then
          key=${key//#/}
      fi

      # shellcheck disable=SC2059
      new_key=$(printf "${var_pattern}" "${key}")

      echo "${key}=${new_key}" >> "${script}"
  done < ${matches}

  echo "EOF" >> "${script}"
  # EndRegion - Generate file script

  sh "${script}"
  sed '/[A-Za-z_]=$/d' ${temporal} > "${target}"
  rm ${matches} "${script}" ${temporal}
}



