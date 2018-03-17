#!/bin/bash
 ##############################################################################
 #                      parabola-riscv64-bootstrap                            #
 #                                                                            #
 #    Copyright (C) 2018  Andreas Grapentin                                   #
 #                                                                            #
 #    This program is free software: you can redistribute it and/or modify    #
 #    it under the terms of the GNU General Public License as published by    #
 #    the Free Software Foundation, either version 3 of the License, or       #
 #    (at your option) any later version.                                     #
 #                                                                            #
 #    This program is distributed in the hope that it will be useful,         #
 #    but WITHOUT ANY WARRANTY; without even the implied warranty of          #
 #    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the           #
 #    GNU General Public License for more details.                            #
 #                                                                            #
 #    You should have received a copy of the GNU General Public License       #
 #    along with this program.  If not, see <http://www.gnu.org/licenses/>.   #
 ##############################################################################

set -euo pipefail

# output formatting
export BO=$(tput bold)
export NO=$(tput sgr0)
export RE=$(tput setf 4)
export GR=$(tput setf 2)
export WH=$(tput setf 7)

# messaging functions
notify() {
  # useful if running notify_telegram
  local recipient=-274411993
  if type -p notify-send >/dev/null; then
    machinectl -q shell --uid=$SUDO_USER .host \
      $(which notify-send) -h string:recipient:$recipient "$@" >/dev/null
  fi
}

die() {
  echo "$BO$RE==> ERROR:$WH $*$NO" 1>&2
  notify -c error *Error:* "$(caller): $*"
  trap - ERR
  exit 1;
}

msg() {
  echo "$BO$GR==>$WH $*$NO";
}

trap "die unknown error" ERR

# host system check helpers
check_exe() {
  echo -n "checking for $1 ... "
  type -p $1 >/dev/null && echo yes || (echo no && die "missing ${2:-$1} in \$PATH")
}

check_file() {
  echo -n "checking for $1 ... "
  [ -f "$1" ] && echo yes || (echo no && die "missing ${2:-$1} in filesystem")
}