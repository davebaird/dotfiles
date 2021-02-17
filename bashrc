
# shellcheck shell=bash
# ~/.bashrc: executed by bash(1) for non-login shells.

export LANGUAGE="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# shellcheck disable=SC2046
[[ $EUID != 0 ]] && [[ -d ~/perl5 ]] && eval $(perl -I ~/perl5/lib/perl5/ -Mlocal::lib)

for dotfile in "$HOME/.git-prompt.sh" "$HOME/.git-completion.sh"; do
  if [[ -e $dotfile ]]; then
        # shellcheck source=/dev/null
	    source "$dotfile"
  fi
done

# shellcheck disable=SC2034
{
# Define some colors first:
red='\e[0;31m'
RED='\e[1;31m'
blue='\e[0;34m'
BLUE='\e[1;34m'
cyan='\e[0;36m'
CYAN='\e[1;36m'
green='\e[0;32m'
GREEN='\e[1;32m'
YELLOW="\[\033[1;33m\]"
GRAY="\[\033[1;30m\]"
NC='\e[0m'              # No Color
COLOUROFF='\033[0m'
}

Z5_STDLIB=
[[ -d /usr/local/src/z5.stdlib ]] && Z5_STDLIB=/usr/local/src/z5.stdlib
[[ -d $HOME/code/z5.stdlib ]]     && Z5_STDLIB=$HOME/code/z5.stdlib

if [[ -f "$Z5_STDLIB/sh/importer" ]]
then
    # shellcheck source=/usr/local/src/z5.stdlib/sh/importer
    source "$Z5_STDLIB/sh/importer"
    export Z5_STDLIB
    import gittools
    import docker.cli.tools
    import pathtools

    PATH.add /usr/local/src/k2.srv/bin
    PATH.add "$HOME/code/newspaper3k/bin"
fi

export PATH=$PATH:$HOME/bin

# Note: PS1 and umask are already set in /etc/profile. You should not
# need this unless you want different defaults for root.
# PS1='${debian_chroot:+($debian_chroot)}\h:\w\$ '
# umask 022

export VISUAL=vi

export HISTIGNORE="&:bg:fg:ll:h:hg:.."

# Are we root?
if [ $UID -eq 0 ]; then
    # root prompt
    SYM='#'
    PROMPTCOLOUR="${RED}"

    # save me from myself
    alias rm='rm -i'
    alias cp='cp -i'
    alias mv='mv -i'

    alias ls='/bin/ls -a'
elif [[ $USER == dave ]]; then
    SYM='$'
    PROMPTCOLOUR=${YELLOW}
else
    SYM='$'
    PROMPTCOLOUR=${GREEN}
fi

export LS_OPTIONS='--color=auto'
eval "$(dircolors)"
alias ls='ls $LS_OPTIONS'
# alias ll='ls $LS_OPTIONS -l'
# alias l='ls $LS_OPTIONS -lA'
#
#alias ls='ls -GF'
alias ll='ls -lF'
alias lla='ls -la'
alias l1='ls --format=single-column'

alias ..='cd ..'
alias h=history
alias path='echo -e ${PATH//:/\\n}'
alias hg='history | grep'
#alias make=gmake

alias find~="find * -type f -name '*~' -print"
alias rm~="find * -type f -name '*~' -print0 | xargs -0 rm"

alias st='stat -c "%A (%a) %8s %.19y %n"'

alias tree='tree --charset=ASCII'


# shellcheck disable=SC2034
{
# * +
GIT_PS1_SHOWDIRTYSTATE="true"

# $
GIT_PS1_SHOWSTASHSTATE="true"

# %
GIT_PS1_SHOWUNTRACKEDFILES="true"

# < > <> =
GIT_PS1_SHOWUPSTREAM="auto"
}

# fancy prompt
function __prompt_command () {
  local _err="$?"
  if [ $_err != 0 ]; then
    ERRSTR="$RED** $_err **$COLOUROFF"
  else
    ERRSTR="- $_err -"
  fi

  if [ $UID -eq 0 ]; then
    PS1="[\$(date +%H:%M)] [$PROMPTCOLOUR\u@\h$COLOUROFF]: \w\n$ERRSTR : $SYM "
  else
    #PROMPT_COMMAND='__git_ps1 "\u@\h:\w" "\\\$ "'
    __git_ps1  "[\$(date +%H:%M)] [$PROMPTCOLOUR\u@\h$COLOUROFF]: \w" "\n$ERRSTR : $SYM "
  fi
}

export PROMPT_COMMAND=__prompt_command




