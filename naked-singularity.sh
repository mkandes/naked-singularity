#!/usr/bin/env bash
# ======================================================================
# NAME
#
#   naked-singularity.sh
#
# DESCRIPTION
#
#   A bash script to help users work with Singularity on their Linux 
#   desktop, laptop, or virtual machine.
#
# USAGE
#
#   Install Singularity from source.
#
#     ./naked-singularity.sh install
#
# LAST UPDATED
#
#   Friday, July 23rd, 2021
#
# ----------------------------------------------------------------------

source log.sh

# ----------------------------------------------------------------------
# naked::install
#
#   Install Singularity (from source).
#
# Globals:
#
#   N/A
#
# Arguments:
#
#   @
#
# Returns:
#
#   True (0) if Singularity is installed sucessfully. False (1)
#   if the installation fails.
#
# ----------------------------------------------------------------------

naked::install() {

  local singularity_version='3.5.3'
  local go_version='1.15.6'
  local -i use_rpm=1

  local os_release_id=''
  local os_release_version_id=''

  while (("${#}" > 0)); do
    case "${1}" in
      -g | --go )
        go_version="${2}"
        shift 2
        ;;
      -r | --rpm )
        use_rpm=0
        shift 1
        ;;
      -s | --singularity )
        singularity_version="${2}"
        shift 2
        ;;
      *)
        log::error "Command-line option ${1} not recognized or not supported."
        return 1
    esac
  done

  log::output 'Checking if Singularity is already installed ...'
  singularity --version > /dev/null 2>&1
  if [[ "${?}" -eq 0 ]]; then
    log::error "Singularity is installed: $(singularity --version)"
    return 1
  else
    log::output 'Singularity is not installed.'
  fi

  log::output 'Parsing /etc/os-release to identify operating system ...'
  if [[ -f '/etc/os-release' ]]; then

    grep '^ID=' /etc/os-release > /dev/null 2>&1
    if [[ "${?}" -eq 0 ]]; then
      grep '^ID=' /etc/os-release | grep '"' > /dev/null 2>&1
      if [[ "${?}" -eq 0 ]]; then
        os_release_id="$(grep '^ID=' /etc/os-release | cut -d '"' -f 2)"
      else
        os_release_id="$(grep '^ID=' /etc/os-release | cut -d '=' -f 2)"
      fi
      log::output "Operating system identified as ${os_release_id}."
    else
      log::error '/etc/os-release does not contain ID parameter.'
      return 1
    fi

    grep '^VERSION_ID=' /etc/os-release > /dev/null 2>&1
    if [[ "${?}" -eq 0 ]]; then
      grep '^VERSION_ID=' /etc/os-release | grep '"' > /dev/null 2>&1
      if [[ "${?}" -eq 0 ]]; then
        os_release_version_id="$(grep '^VERSION_ID=' /etc/os-release | cut -d '"' -f 2)"
      else
        os_release_version_id="$(grep '^VERSION_ID=' /etc/os-release | cut -d '=' -f 2)"
      fi
      log::output "Operating system version identified as ${os_release_version_id}."
    else
      log::error '/etc/os-release does not contain VERSION_ID parameter.'
      return 1
    fi

  else

    log::error '/etc/os-release does not exist.'
    return 1

  fi

  if [[ "${os_release_id}" = 'centos' ]]; then

    log::output 'Running yum update ...'
    yum -y update

    log::output 'Installing Singularity dependencies ...'
    yum -y groupinstall 'Development Tools'
    yum -y install epel-release
    yum -y install openssl-devel
    yum -y install libuuid-devel
    yum -y install libseccomp-devel
    yum -y install wget
    yum -y install squashfs-tools
    yum -y install cryptsetup
    yum -y install debootstrap

  elif [[ "${os_release_id}" = 'ubuntu' ]]; then

    log::output 'Running apt-get update ...'
    apt-get -y update

    log::output 'Installing Singularity dependencies ...'
    apt-get -y install build-essential
    apt-get -y install libssl-dev
    apt-get -y install uuid-dev
    apt-get -y install libgpgme-dev
    apt-get -y install squashfs-tools
    apt-get -y install libseccomp-dev
    apt-get -y install wget
    apt-get -y install pkg-config
    apt-get -y install git
    apt-get -y install cryptsetup-bin
    apt-get -y install debootstrap
    apt-get -y install yum-utils

    # https://github.com/hpcng/singularity/issues/241
    echo '%_var /var' > ~/.rpmmacros
    echo '%_dbpath %{_var}/lib/rpm' >> ~/.rpmmacros

  else

    log::error 'Operating system not recognized or not supported.'
    return 1

  fi

  mkdir -p /tmp/go
  cd /tmp/go

  log::output 'Installing Go ...'
  export CGO_ENABLED=0
  wget https://dl.google.com/go/go1.4-bootstrap-20171003.tar.gz
  tar -xf go1.4-bootstrap-20171003.tar.gz
  mv go 1.4
  cd 1.4/src
  ./make.bash

  export GOROOT_BOOTSTRAP='/tmp/go/1.4'

  cd /tmp/go

  export CGO_ENABLED=1
  git clone https://go.googlesource.com/go "${go_version}"
  cd "${go_version}"
  git checkout "go${go_version}"
  cd src
  ./all.bash

  export GOROOT="/tmp/go/${go_version}"
  export PATH="${GOROOT}/bin:${PATH}"

  cd /tmp

  log::output 'Installing Singularity ...'
  wget "https://github.com/hpcng/singularity/releases/download/v${singularity_version}/singularity-${singularity_version}.tar.gz"
  tar -xf "singularity-${singularity_version}.tar.gz"
  cd singularity
  ./mconfig #--prefix=/opt/singularity <- include prefix as used-defined option?
  make -C ./builddir
  make -C ./builddir install

  # Prepend the path of the install directory of Singularity to PATH
  # because not all secure_paths in /etc/sudoers may include it. If it
  # is not included as one of the secure_paths by default, then the
  # final install test below will fail erroneously, even when
  # Singularity has been installed successfully.
  #
  # https://unix.stackexchange.com/questions/8646/why-are-path-variables-different-when-running-via-sudo-and-su
  export PATH="/usr/local/bin:${PATH}"

  log::output 'Checking if Singularity was installed successully ...'
  singularity --version
  if [[ "${?}" -ne 0 ]]; then
    log::error 'Singularity installation failed!'
    return 1
  fi

  log::output 'Singularity was installed successfully!'

  return 0

}

# ----------------------------------------------------------------------
# naked::help
#
#   Prints information on how to use this script to standard output.
#
# Globals:
#
#   N/A
#
# Arguments:
#
#   N/A
#
# Returns:
#
#   True (0) always.
#
# ----------------------------------------------------------------------

naked::help() {

  log::output 'USAGE: naked-singularity.sh <command> [options] {value}'
  log::output ''
  
  return 0

}

# ----------------------------------------------------------------------
# naked::main
#
#   Controls the execution of the script.
#
# Globals:
#
#   @
#
# Arguments:
# 
#   @
#
# Returns:
#
#   True (0) if the script executes without issue. False (1) if the 
#   script fails to executre properly.
# 
# ----------------------------------------------------------------------

naked::main() {

  local naked_command=''

  # If at least one command-line argument was provided by the user, 
  # then start parsing the command-line arguments. Otherwise, throw
  # an error.
  if (( "${#}" > 0 )); then

    naked_command="${1}"
    shift 1

    if [[ "${naked_command}" = 'install' ]]; then

      naked::install "${@}"
      if [[ "${?}" -ne 0 ]]; then
        log::error 'Failed to run install command.'
        exit 1
      fi

    elif [[ "${naked_command}" = 'help' || \
            "${naked_command}" = '-h' || \
            "${naked_command}" = '--help' ]]; then

      naked::help 
      if [[ "${?}" -ne 0 ]]; then
        log::error 'Failed to run help command.'
        exit 1
      fi

    else

      log::error 'Command not recognized or not supported.'
      exit 1

    fi

  else

    log::error 'No command-line arguments were provided.'
    exit 1

  fi

  exit 0

}

# ----------------------------------------------------------------------

naked::main "${@}"

# ======================================================================
