# ======================================================================
#
# NAME
# 
#     naked-singularity.sh
#
# DESCRIPTION
#
#     A bash script to help users create Singularity containers from the 
#     definition (or recipe) files available in the naked-singularity 
#     repository.
#
# USAGE
#
#     1. Install Singularity on your local desktop, laptop, or virtual 
#        machine.
#
#            ./naked-singularity.sh install
#
#     2. Build a simple Ubuntu Singularity container for Comet at SDSC.
#
#            ./naked-singularity.sh build -s comet -a ubuntu -d ubuntu.def 
#
#     3. Uninstall Singularity from your local desktop, laptop, or 
#        virtual machine.
#
#            ./naked-singularity.sh uninstall
#
# LAST UPDATED
#
#     Tuesday, April 30th, 2019
#
# ----------------------------------------------------------------------

naked_out() {

  echo "naked-singularity: ${@}" >&1

}


naked_err() {

  echo "naked-singularity: ERROR :: ${@}" >&2

}


naked_warn() {

  echo "naked-singularity: WARNING :: ${@}" >&2

}


naked_build() {

  local path_to_definition_file="${naked_dir}/definition-files"
  local path_to_image="${naked_dir}/images"

  local system=''
  local application=''
  local definition_file=''
  local image=''
  local -i image_size='-1'
  local writable='false'
  local force_overwrite='false'

  naked_out "Read in all command-line options for 'build' command ..."

  while (( "${#}" > 0 )); do
    naked_out "Read in command-line option '${1}' with input value '${2}' ... "
    case "${1}" in
      -s | --system )
        system="${2}"
        shift 2
        ;;
      -a | --application )
        application="${2}"
        shift 2
        ;;
      -d | --definition-file )
        definition_file="${2}"
        shift 2
        ;;
      -i | --image )
        image="${2}"
        shift 2
        ;;
      -z | --image-size )
        image_size="${2}"
        shift 2
        ;;
      -w | --writable )
        writable='true'
        shift 1
        ;;
      -f | --force-overwrite )
        force_overwrite='true'
        shift 1
        ;;
      *)
        naked_err "Command-line option ${1} not recognized or not supported."
        return 1
    esac
  done

  naked_out "All command-line options for 'build' command have been read ... "

  naked_out 'Check if DEFINITION FILE is exists ...'

  if [[ -z "${system}" ]]; then
    naked_err 'No SYSTEM name was provided.'
    naked_err 'Use the -s (or --system) command-line option to specify the name of the target SYSTEM.'
    naked_err 'Listing all SYSTEMs to choose from ...'
    echo "ls ${path_to_definition_file}"
    echo "$(ls "${path_to_definition_file}")"
    return 1
  fi

  path_to_definition_file+="/${system}"

  if [[ ! -d "${path_to_definition_file}" ]]; then
    naked_err "${path_to_definition_file} does not exist."
    naked_err 'Use the -s (or --system) command-line option to specify the name of the target SYSTEM.'
    naked_err 'Listing all SYSTEMs to choose from ...'
    echo "ls ${path_to_definition_file%/${system}}"
    echo "$(ls "${path_to_definition_file%/${system}}")"
    return 1
  fi

  if [[ -z "${application}" ]]; then
    naked_err 'No APPLICATION name was provided.'
    naked_err 'Use the -a (or --application) command-line option to specify the name of the APPLICATION to be run on the target SYSTEM.'
    naked_err 'Listing all APPLICATIONs to choose from ...'
    echo "ls ${path_to_definition_file}"
    echo "$(ls "${path_to_definition_file}")"
    return 1
  fi

  path_to_definition_file+="/${application}"

  if [[ ! -d "${path_to_definition_file}" ]]; then
    naked_err "${path_to_definition_file} does not exist."
    naked_err 'Use the -a (or --application) command-line option to specify the name of the APPLICATION to be run on the target SYSTEM.'
    naked_err 'Listing all APPLICATIONs to choose from ...'
    echo "ls ${path_to_definition_file%/${application}}"
    echo "$(ls "${path_to_definition_file%/${application}}")"
    return 1
  fi

  if [[ -z "${definition_file}" ]]; then
    naked_err 'No DEFINITION FILE was provided.'
    naked_err 'Use the -d (or --definition-file) command-line option to specify the name of the DEFINITION FILE.'
    naked_err 'Listing all DEFINITION FILEs to choose from ...'
    echo "ls ${path_to_definition_file}"
    echo "$(ls "${path_to_definition_file}")" 
    return 1
  fi

  path_to_definition_file+="/${definition_file}"

  if [[ ! -f "${path_to_definition_file}" ]]; then
    naked_err "${path_to_definition_file} does not exist."
    naked_err 'Use the -d (or --definition-file) command-line option to specify the name of the DEFINITION FILE.'
    naked_err 'Listing all DEFINITION FILEs to choose from ...'
    echo "ls ${path_to_definition_file%/${definition_file}}"
    echo "$(ls "${path_to_definition_file%/${definition_file}}")"
    return 1
  fi

  naked_out "DEFINITION FILE exists ... ${path_to_definition_file}"

  naked_out 'Check if IMAGE exists ...'

  if [[ -z "${image}" ]]; then
    naked_warn 'WARNING :: No IMAGE name was provided.'
    naked_warn 'Use the -i (or --image) command-line option to specify the name of the IMAGE.'
    image="$(echo "${definition_file}" | sed 's/.def//')"
    if [[ "${writable}" = 'true' ]]; then
      image+='.img'
    else
      image+='.simg'
    fi 
    naked_out "Setting IMAGE name ... ${image}"
  fi

  path_to_image+="/${system}"
  path_to_image+="/${application}"
  path_to_image+="/${image}"

  if [[ ! -f "${path_to_image}" ]]; then
    naked_out "${path_to_image} does not exist yet ..."
    naked_out "Prepare to build a new Singularity IMAGE from ${path_to_definition_file} ..."
    naked_out 'Make parent directories to accomodate new IMAGE if they do not exist already ...'
    echo "mkdir -p $(dirname ${path_to_image})"
    mkdir -p "$(dirname "${path_to_image}")"
    if [[ "${writable}" = 'true' ]]; then
      naked_out "Build new $(basename "${path_to_image}") as a writable ext3 Singularity IMAGE ..."
      if (( "${image_size}" <= 0 )); then
        naked_warn 'WARNING :: IMAGE_SIZE is less than or equal to zero.'
        naked_warn 'IMAGE_SIZE is the size of the IMAGE in integer-valued units of MiB.'
        naked_warn 'Attempting to set IMAGE SIZE from DEFINITION FILE ...'
        grep 'SINGULARITY_IMAGE_SIZE' "${path_to_definition_file}"
        if [[ "${?}" -ne 0 ]]; then
          naked_err 'SINGULARITY_IMAGE_SIZE not found in DEFINITION FILE ... '
          return 1
        else
          naked_out 'Setting IMAGE_SIZE equal to SINGULARITY_IMAGE_SIZE ... '
          image_size="$(grep 'SINGULARITY_IMAGE_SIZE' "${path_to_definition_file}" | \
                        sed s'/    SINGULARITY_IMAGE_SIZE //')"
        fi
      fi
      naked_out 'Creating writable ext3 Singularity IMAGE now ...'
      echo "singularity image.create --size ${image_size} ${path_to_image}"
      singularity image.create --size "${image_size}" "${path_to_image}"
      naked_out 'IMAGE created ...'
      naked_out 'Starting build now ...'
      echo "sudo singularity build --writable ${path_to_image} ${path_to_definition_file}"
      sudo singularity build --writable "${path_to_image}" "${path_to_definition_file}"
    else
      naked_out "Build $(basename "${path_to_image}") as a read-only squashfs Singularity IMAGE ..."
      naked_out 'Starting build now ...'
      echo "sudo singularity build ${path_to_image} ${path_to_definition_file}"
      sudo singularity build "${path_to_image}" "${path_to_definition_file}"
    fi
  else
    naked_err "${path_to_image} already exists ..."
    naked_err 'Cannot overwrite existing IMAGE ...'
    return 1
  fi

  naked_out 'Build complete.'

  return 0

}


naked_inspect() {

  echo 'run singularity inspect command ... '

}


naked_install() {

  local operating_system='ubuntu'
  local prefix='/usr/local'
  local version='2.6.1'

  naked_out "Read in all command-line options of the 'install' command ..."

  while (( "${#}" > 0 )); do
    naked_out "Read in command-line option '${1}' with input value '${2}' ... "
    case "${1}" in
      -o | --os )
        operating_system="${2,,}"
        shift 2
        ;;
      -p | --prefix )
        prefix="${2}"
        shift 2
        ;;
      -v | --version )
        version="${2}"
        shift 2
        ;;
      *)
        naked_err "Command-line option ${1} not recognized or not supported."
        return 1
    esac
  done

  naked_out "All command-line options for 'install' command have been read ... "

  naked_out 'Checking if Singularity is already installed on this system ...'
  echo 'singularity --version'
  singularity --version
  if [[ "${?}" -eq 0 ]]; then
    naked_err 'Singularity is already installed on this system!'
    naked_err 'Please uninstall the existing version of Singularity prior to installing a new version.'
    return 1
  fi

  naked_out 'Singularity is not yet installed on this system ...'

  if [[ "${operating_system}" = 'centos' ]]; then

    naked_out 'Running update ...'
    echo 'sudo yum -y update'
    sudo yum -y update

    naked_out 'Installing Singularity dependencies ...'
    echo "sudo yum groupinstall -y 'Development Tools'"
    sudo yum groupinstall -y 'Development Tools'
    echo 'sudo yum install -y libarchive-devel'
    sudo yum install -y libarchive-devel
    echo 'sudo yum install -y epel-release'
    sudo yum install -y epel-release
    echo 'sudo yum install -y debootstrap'
    sudo yum install -y debootstrap
    echo 'sudo yum install -y debian-keyring'
    sudo yum install -y debian-keyring

  elif [[ "${operating_system}" = 'ubuntu' ]]; then

    naked_out 'Running update ...'
    echo 'sudo apt-get -y update'
    sudo apt-get -y update

    naked_out 'Installing Singularity dependencies ...'
    echo 'sudo apt-get -y install python'
    sudo apt-get -y install python
    echo 'sudo apt-get -y install dh-autoreconf'
    sudo apt-get -y install dh-autoreconf
    echo 'sudo apt-get -y install build-essential'
    sudo apt-get -y install build-essential
    echo 'sudo apt-get -y install libarchive-dev'
    sudo apt-get -y install libarchive-dev
    echo 'sudo apt-get -y install debootstrap'
    sudo apt-get -y install debootstrap
    echo 'sudo apt-get -y install squashfs-tools'
    sudo apt-get -y install squashfs-tools

  else

    naked_err 'Operating system not recognized or not supported.'
    return 1

  fi

  naked_out 'Downloading Singularity source code...'
  echo "wget https://github.com/singularityware/singularity/releases/download/${version}/singularity-${version}.tar.gz"
  wget "https://github.com/singularityware/singularity/releases/download/${version}/singularity-${version}.tar.gz"

  naked_out 'Extracting Singularity source code...'
  echo "tar -xzvf singularity-${version}.tar.gz"
  tar -xzvf singularity-${version}.tar.gz

  naked_out 'Configuring Singularity ...'
  echo "cd singularity-${version}"
  cd "singularity-${version}"
  echo "./configure --prefix=${prefix}"
  ./configure --prefix="${prefix}"

  naked_out 'Compiling Singularity ...'
  echo 'make'
  make

  naked_out 'Installing Singularity ...'
  echo 'sudo make install'
  sudo make install

  naked_out 'Checking if Singularity was installed successully ...'
  singularity --version
  if [[ "${?}" -ne 0 ]]; then
    naked_err 'Singularity was NOT installed successfully ...'
    return 1
  fi

  naked_out 'Singularity was installed successfully!'

  naked_out 'Cleaning up ...'
  cd ../
  rm -rf "singularity-${version}.tar.gz"
  rm -rf "singularity-${version}"

  return 0

}


naked_shell() {

  echo 'run singularity shell command ... '

}


naked_uninstall() {

  local prefix='/usr/local'

  naked_out "Read in all command-line options of the 'uninstall' command ..."

  while (( "${#}" > 0 )); do
    naked_out "Read in command-line option '${1}' with input value '${2}' ... "
    case "${1}" in
      -p | --prefix )
        prefix="${2}"
        shift 2
        ;;
      *)
        naked_err "Command-line option ${1} not recognized or not supported."
        return 1
    esac
  done

  naked_out "All command-line options for 'uninstall' command have been read ... "

  naked_out 'Checking if Singularity is installed ...'
  echo 'singularity --version'
  singularity --version
  if [[ "${?}" -ne 0 ]]; then
    naked_err 'Singularity is not installed on this system.'
    return 1
  fi

  naked_out 'Uninstalling Singularity ...'
  sudo rm -rf "${prefix}/libexec/singularity"
  sudo rm -rf "${prefix}/etc/singularity"
  sudo rm -rf "${prefix}/include/singularity"
  sudo rm -rf "${prefix}/lib/singularity"
  sudo rm -rf "${prefix}/var/lib/singularity"
  sudo rm "${prefix}/bin/singularity"
  sudo rm "${prefix}/bin/run-singularity"
  sudo rm "${prefix}/etc/bash_completion.d/singularity"
  sudo rm "${prefix}/man/man1/singularity.1"

  naked_out 'Checking if Singularity was uninstalled successfully ...'
  which singularity
  if [[ "${?}" -eq 0 ]]; then
    naked_err 'Singularity was NOT uninstalled!'
    return 1
  fi

  naked_out 'Singularity was uninstalled successfully!'

  return 0

}


naked_upload() {

  echo 'Upload image to users HOME directory on target system ...'

}


naked_verify() {

  echo 'Verify checksums of definition file and image match ... '

}


main() {

  local naked_command=''
  local naked_dir="${PWD}"

  if (( "${#}" > 0 )); then # at least one command-line arguments was
    # provided. The first argument is expected to be main command issued 
    # by the user. Read in that command and then determine if it is a
    # valid command.

    naked_command="${1}"
    shift 1

    if [[ "${naked_command}" = 'build' ]]; then

      naked_build "${@}"
      if [[ "${?}" -ne 0 ]]; then
        exit 1
      fi

    elif [[ "${naked_command}" = 'install' ]]; then

      naked_install "${@}"
      if [[ "${?}" -ne 0 ]]; then
        exit 1
      fi

    elif [[ "${naked_command}" = 'uninstall' ]]; then

      naked_uninstall "${@}"
      if [[ "${?}" -ne 0 ]]; then
        exit 1
      fi

    elif [[ "${naked_command}" = 'help' || \
            "${naked_command}" = '-h' || \
            "${naked_command}" = '--help' ]]; then # return help. 

      echo "USAGE: naked-singularity.sh <command> [options] {values}"
      echo ""
      echo "Finish writing help later ... ."

    else

      naked_err 'Command not recognized or not supported.'
      exit 1

    fi

  else

    naked_err 'No command-line arguments were provided.'
    exit 1

  fi
  
  exit 0

}


main "${@}"

# ======================================================================
