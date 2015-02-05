#!/bin/bash

echo 'PHP_AUTOCONF="'$(which autoconf)'"' >> ~/.bash_profile && . ~/.bash_profile

# Change the window title of X terminals
case ${TERM} in
        xterm*|rxvt*|Eterm|aterm|kterm|gnome*|interix)
                PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\007"'
		use_color=true
                ;;
        screen)
                PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\033\\"'
		use_color=true
                ;;
esac

if ${use_color} ; then
	# set color prompt
        if [[ ${EUID} == 0 ]] ; then
                PS1='\[\033[01;31m\]\h\[\033[01;34m\] \W \$\[\033[00m\] '
        else
                PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] '
        fi

	# enable ls colors
        alias ls='ls -G'
	# enable grep color
        alias grep='grep --colour=auto'
else
        if [[ ${EUID} == 0 ]] ; then
                # show root@ when we don't have colors
                PS1='\u@\h \W \$ '
        else
                PS1='\u@\h \w \$ '
        fi
fi

#vigo's addition
export PS1="\h@\u\[\033[36m\][\w]:\[\033[0m\]\n$ "

if [ -f /opt/local/etc/bash_completion ]; then
	. /opt/local/etc/bash_completion
fi

if [ -f /opt/local/etc/django_bash_completion ]; then
	. /opt/local/etc/django_bash_completion
fi

# Try to keep environment pollution down
unset use_color

# improve bash history
shopt -s histappend
PROMPT_COMMAND=$PROMPT_COMMAND';history -a'
# Store 10000 commands in bash history
export HISTFILESIZE=10000
export HISTSIZE=10000
# Don't put duplicate lines in the history
export HISTCONTROL=ignoredups


# MacPorts Installer addition on 2015-01-05_at_14:01:58: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.

export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:/opt/X11/lib/pkgconfig
export PATH=~/bin:/usr/local/bin:/usr/local/mysql/bin:$PATH

alias nodejs='node'
alias ls="ls -alhG"
alias visible='defaults write com.apple.Finder AppleShowAllFiles YES'
alias invisible='defaults write com.apple.Finder AppleShowAllFiles NO'
alias finder='killall Finder && open /System/Library/CoreServices/Finder.app'
alias sleep="osascript -e 'tell application \"Finder\" to sleep'"

# Get readable list of network IPs
alias ips="ifconfig -a | perl -nle'/(\d+\.\d+\.\d+\.\d+)/ && print $1'"
alias myipx="dig +short myip.opendns.com @resolver1.opendns.com"
alias myip="curl ipecho.net/plain; echo"
alias flush="dscacheutil -flushcache" # Flush DNS cache

alias gzip="gzip -9n" # set strongest compression level as ‘default’ for gzip
alias ping="ping -c 5" # ping 5 times ‘by default’
alias ql="qlmanage -p 2>/dev/null" # preview a file using QuickLook
alias ejectcd='drutil eject'
alias forceeject="hdiutil detach -force"
alias forcequit="killall -HUP"
alias syslog='tail -f /var/log/system.log'
alias ports.tcp='sudo lsof -nP | grep TCP'
alias ports.udp='sudo lsof -nP | grep UDP'
alias lock='/System/Library/CoreServices/"Menu Extras"/User.menu/Contents/Resources/CGSession -suspend'

alias apache.cd="cd /private/etc/apache2/"
alias apache.conf="sudo lime /private/etc/apache2/httpd.conf"
alias apache.sites="sudo lime /private/etc/apache2/vhosts/"
alias apache.restart='sudo apachectl restart'

alias nginx.cd="cd /usr/local/etc/nginx/"
alias nginx.conf="sudo lime /usr/local/etc/nginx/nginx.conf"
alias nginx.sites="sudo lime /usr/local/etc/nginx/sites-enabled/"
alias nginx.start='sudo nginx'
alias nginx.stop='sudo nginx -s stop'
alias nginx.restart='sudo nginx -s reload'

alias mongo.start='launchctl load ~/Library/LaunchAgents/homebrew.mxcl.mongodb.plist'
alias mongo.stop='launchctl unload ~/Library/LaunchAgents/homebrew.mxcl.mongodb.plist'

alias focus.cd='cd ~/work/prod/js/Bilgera/focus.webapp'
alias focus.compile='focus.cd; grunt compileToJst'
alias focus.cmp='focus.cd; grunt compileToJst'

alias dirspaces="sudo du -xhd 1"
alias myssh="pbcopy < ~/.ssh/id_rsa.pub | pbpaste > ~/clipboard.text"

# Open a man page in Preview.app
pman() { man -t "${1}" | open -f -a /Applications/Preview.app; }
# Quit an app cleanly
quit() {
    for app in $*; do
        osascript -e 'quit app "'$app'"'
    done
}
pkill() {
	for X in `ps acx | grep -i $1 | awk {'print $1'}`; do
	  kill $X;
	done
}
# Relaunch an app
relaunch() {
    for app in $*; do
        osascript -e 'quit app "'$app'"';
        sleep 2;
        open -a $app
    done
}
# lsZ -- list contents of compressed tar archive
function lsZ() {
    tar tvzf "$1"
}

# deZ -- silently extract contents of compressed tar archive
function deZ() {
    # extract bzip2 compressed tars as well
    if [[ $(file "$1") == *bzip2* ]]; then
        bunzip2 -c "$1" | tar xf -
    else
        tar xzf "$1"
    fi
}

# enZ -- build compressed tar archive
function enZ() {
    tar cZf "${2:-$1.tar.Z}" "$1"
}

# enG -- build compressed tar archive (with gzip)
function enG() {
    tar czf "${2:-$1.tar.gz}" "$1"
}

# enB -- build compressed tar archive (with bzip2)
function enB() {
    tar cf - "$1" | bzip2 > "${2:-$1.tar.bz2}"
}

# lsB -- list contents of bzip2 compressed tar archive
function lsB() {
    bunzip2 -c "$1" | tar tvf -
}

# deB -- silently extract contents of bzip2 compressed tar archive
function deB() {
    bunzip2 -c "$1" | tar xf -
}

export ANDROID_SDK_PATH=~/Documents/android-sdk-macosx
export NODE_PATH=/usr/local/lib/node
export NODE_MPATH=~/.node/lib/node_modules/
export NODE_ENV="development"
export MANPATH=$MANPATH:/opt/local/share/man
export LD_LIBRARY_PATH=~/Documents/android-sdk-macosx/tools/lib/

export PATH=$PATH:~/Applications
export PATH=/usr/local:/usr/local/bin:/usr/local/sbin:$PATH
export PATH=$PATH:/Developer/usr/bin/git
export PATH=$PATH:/usr/local/mysql/bin
export PATH=$PATH:/usr/local/mongodb/bin
export PATH=$PATH:/opt/local/bin:/opt/local/sbin
export PATH=$PATH:/usr/local/php5/bin
export PATH=$PATH:/usr/local/lib/node_modules/npm
export PATH=$PATH:NODE_PATH
export PATH=$PATH:$NODE_MPATH
export PATH=$PATH:$NODE_MPATH/plugman/
export PATH=$PATH:$NODE_MPATH/bower/bin/
export PATH=$PATH:$NODE_MPATH/grunt-cli/bin/
export PATH=$PATH:$NODE_MPATH/cordova/bin/
export PATH=$PATH:/usr/local/Library/Formula/
export PATH=$PATH:$ANDROID_SDK_PATH/tools/:$ANDROID_SDK_PATH/platforn-tools/
