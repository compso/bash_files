# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

#set -x;

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
# .bashrc

export PATH=~/bin:${PATH}

# Uncomment this line to show envs as they are sourced
#set -x 

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

## SHOW vars

# User specific aliases and functions

export PS1="\[\e[1;32m\]\u: \w \[\e[0m\]> "
PROMPT_COMMAND='printf "\033]0;${USER}@${HOSTNAME%%.*}  (${SHOW} - ${WORKSPACE})"; printf "\007"'

source /etc/bash_completion.d/git
if [ -f ~/.git-prompt.sh ];then
  source ~/.git-prompt.sh
  export GIT_PS1_DESCRIBE_STYLE='describe'
  export GIT_PS1_SHOWCOLORHINTS=1
  export GIT_PS1_SHOWDIRTYSTATE=1
  export PROMPT_COMMAND='__git_ps1 "\[\e[1;32m\]\u: \w \[\e[0m\]" "\\$ "'
fi



alias my_dif="diff -y --suppress-common-lines"

alias cleartmp="rm -Rfv /tmp/*;rm -Rfv /var/tmp/*"

alias rmfind="find . -name $1 -print0 | xargs -0 /bin/rm -fv"

export BG=black
export FG=white
alias xterm="xterm -fg ${FG} -bg ${BG}"


function rename_find_dir(){
	find . -name "$2"  -print0 | grep -FzZ $1 | xargs -0 -I {} -i "sh" -c "mv -v {} `dirname {}`/$3"
}

alias rfd="rename_find_dir"



#function abcgeo {
#  if [ -f $1 ] ; then
#    abcecho $1 | pyp "p.endswith('_geo') | p.split('=')[1]";
#  else
#         echo "'$1' is not a valid file";
#  fi
#}

#simple calculator script
function calc {
	echo "scale=4; $1" | bc ;
}

#degrees to radians converter
function deg2rad {
  echo "scale=4; .01745329252 * $1" | bc;
  }
  
function rad2deg {  
  echo "scale=4; $1 / 0.01745329252" | bc;
  }

#copy linked libries for executable to directory

function cpldd {
	cp $(ldd $1 | cut -d \( -f1 | cut -d \> -f2) $2
}

function cfg() { source $HOME/config/env.sh; }

#extract archive 
function extract()      # Handy Extract Program.
{
     if [ -f $1 ] ; then
         case $1 in
             *.tar.bz2)   tar xvjf $1     ;;
             *.tar.gz)    tar xvzf $1     ;;
             *.bz2)       bunzip2 $1      ;;
             *.rar)       unrar x $1      ;;
             *.gz)        gunzip $1       ;;
             *.tar)       tar xvf $1      ;;
             *.tbz2)      tar xvjf $1     ;;
             *.tgz)       tar xvzf $1     ;;
             *.zip)       unzip $1        ;;
             *.Z)         uncompress $1   ;;
             *.7z)        7z x $1         ;;
             *)           echo "'$1' cannot be extracted via >extract<" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}

function my_ps() { ps $@ -u $USER -o pid,%cpu,%mem,bsdtime,command ; }
function my_ren() { my_ps |grep renderdl;}
function my_top() { top $@ -u $USER ; }
function pp() { my_ps f | awk '!/awk/ && $0~var' var=${1:-".*"} ; }

function ls_dl() { ps -A -o pid,cpu,user,command |grep renderdl ; }

alias my_sh='ps --no-headers --format comm $$'

alias gomaya='cd $SHOT_PATH/user/$USER/maya'
alias gonuke='cd $SHOT_PATH/user/$USER/nuke'
alias gophotoshop='cd $SHOT_PATH/user/$USER/photoshop'

export PLAYPEN=/net/pinot/disk1/playpen

alias playpen="cd ${PLAYPEN}"

alias 3dgrid="qstat -u '*' -f -q 3d.q"
alias 2dgrid="qstat -u '*' -f -q 2d.q"

alias grid_us="tail -f /net/r0002/disk1/GridEngine/bb_grid/log/bb_update_server.log"
alias grid_gs="tail -f /net/r0002/disk1/GridEngine/bb_grid/log/bb_grid_server.log"
alias grid_ms="tail -f /net/r0002/disk1/GridEngine/bb_grid/log/bb_grid_master.log"

#
#
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p'
alias tail='tail -n 100'
#
alias h='history'
#alias j='jobs -l'
#alias which='type -a'
alias ..='cd ..'
alias ~='cd ~'
alias 1='cd ..'
alias 2='cd ../..'
alias 3='cd ../../..'
alias 4='cd ../../../..'
alias path='echo -e ${PATH//:/\\n}'
alias libpath='echo -e ${LD_LIBRARY_PATH//:/\\n}'
alias pythonpath='echo -e ${PYTHONPATH//:/\\n}'

#app spacific

alias nukepath='echo -e ${NUKE_PATH//:/\\n}'

alias mayamod='echo -e ${MAYA_MODULE_PATH//:/\\n}'
alias mayaplug='echo -e ${MAYA_PLUG_IN_PATH//:/\\n}'
alias mayascripts='echo -e ${MAYA_SCRIPT_PATH//:/\\n}'

alias dlshader='echo -e ${DL_SHADERS_PATH//:/\\n}'


#
#
alias dus="du -ka --max-depth=1 . | sort -nr | cut -f2 | xargs -d '\n' du -sh" # list summery order by size
alias du='du -kh' # Makes a more readable output.
alias df='df -kTh'

# App aliases

alias nukev='nuke -v'
alias nv='nukev'
alias na='nuke --nukeassist'
alias md='maya_dev'
alias m='maya'
alias nd='nuke_dev'
alias n='nuke'
alias chrome='RV_VERSION=4.0.10 XDG_CONFIG_HOME=/disk1/$USER XDG_CACHE_HOME=/disk1/$USER chromium-browser --allow-outdated-plugins'
alias mb='mkBundle'
##
#	Grid engine
##


alias my_grid="watch qstat -u ${USERNAME}"
alias ls_ren="watch qstat -u \\\"*\\\""

function wake_farm() {
  
  mode=on ; for rfnum in {$1..$2} ; do host=r00$rfnum ; hostip=`host $host | awk '{print $4}'` ; ipmiip=`echo $hostip | sed 's/\.50\./\.51\./'` ; echo "-- $host --" ; ipmitool -I lanplus -H $ipmiip -U ADMIN -P ADMIN power $mode ; sleep 5 ;done

}



##
#	GIT
##

export GIT_HOME=/git/

alias gogit="cd $GIT_HOME"
git_log_origin(){
	br=`git branch | grep '*' | cut -d" " -f 2`				
	git log origin/"$br"..
}


git_hierarchical_status() {

	for d in "$@";do
		if [ -d $d ]; then
			cd $d
			if [ -d .git ] ; then
				echo "----------------------------"
				echo $d
				git status
				echo "- - - - - - - - - - - - - - "
				br=`git branch | grep '*' | cut -d" " -f 2`				
				git log origin/"$br"..
				echo "----------------------------"		
			fi
			cd ../
		fi
	done
}

git_enumerator() {
	echo "enter command to be run in all git directories"
	read cmd
	for d in "$@";do
		if [ -d $d ]; then
			cd $d
			if [ -d .git ] ; then
				echo "------------- $d ---------------"
				echo $cmd
				eval $cmd

			fi
			cd ../
		fi
	done
	echo "done"	
}

alias git_pullall='git submodule foreach git pull origin master'

#kill aliases
alias term='kill -s TERM'

#
##-------------------------------------------------------------
## The 'ls' family (this assumes you use a recent GNU ls)
##-------------------------------------------------------------
#alias ll="ls -l --group-directories-first"
alias ls='ls -F' # add colors for filetype recognition
alias la='ls -Al' # show hidden files
alias lx='ls -lXB' # sort by extension
alias lk='ls -lSr' # sort by size, biggest last
alias lc='ls -ltcr' # sort by and show change time, most recent last
alias lu='ls -ltur' # sort by and show access time, most recent last
alias lt='ls -ltr' # sort by date, most recent last
alias lm='ls -al |more' # pipe through 'more'
alias lr='ls -lR' # recursive ls

#watch ls aliases
alias llw='watch "ls -l|tail -n 40"'
alias ltw='watch "ls -ltr|tail -n 40"'


# Modo

export PATH=${PATH}:/opt/modo

MAXWELL2_ROOT=/disk1/playpen/install/dist/Maxwell;export MAXWELL2_ROOT; # ADDED BY INSTALLER - DO NOT EDIT OR DELETE THIS COMMENT - 667B9C26-80AA-A570-F0F2-0F1B4747D88F 686A12FE-7DF6-52EB-10A8-57EC1D9345FF

MAXWELL2_MATERIALS_DATABASE=/disk1/playpen/install/dist/Maxwell/materials\ database;export MAXWELL2_MATERIALS_DATABASE; # ADDED BY INSTALLER - DO NOT EDIT OR DELETE THIS COMMENT - 667B9C26-80AA-A570-F0F2-0F1B4747D88F 686A12FE-7DF6-52EB-10A8-57EC1D9345FF
