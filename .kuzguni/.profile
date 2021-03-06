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
git config --global color.ui auto

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

alias s.ed="lime ~/worx/OSX-setup/.kuzguni/.profile"
alias s.cmp="cp -Rf ~/worx/OSX-setup/.kuzguni/.profile ~/.profile; source ~/.profile"
alias s.git="var=$(pwd); cd ~/worx/OSX-setup/; git add .; git commit -a -m '...'; git push -u origin master; cd $var;"
alias p.cd="cd ~/Library/Mobile\ Documents/com~apple~CloudDocs/codelab"

alias wp.grab='cd /tmp; curl -O https://wordpress.org/latest.zip; unzip -q latest.zip; echo move to where?; read WHERE;'
alias wp.help='echo wp.genesis ... info on WP-Genesis framework snippets'
alias wp.genesis='open http://justintallant.com/genesis-sublime-text-2-snippets/'

##########################
#   server-based stuff   #
##########################

alias mongo.start='launchctl load ~/Library/LaunchAgents/homebrew.mxcl.mongodb.plist'
alias mongo.stop='launchctl unload ~/Library/LaunchAgents/homebrew.mxcl.mongodb.plist'
alias redis.start='sudo launchctl start ~/Library/LaunchAgents/io.redis.redis-server'
alias redis.stop='sudo launchctl stop ~/Library/LaunchAgents/io.redis.redis-server'

alias apache.cd="cd /private/etc/apache2/"
alias apache.conf="sudo lime /private/etc/apache2/httpd.conf"
alias apache.sites="sudo lime /private/etc/apache2/vhosts/"
alias apache.restart='sudo apachectl restart'
alias apache.test='apachectl -t'

alias apache.cd="/usr/local/etc/apache2/2.4/httpd.conf"
alias apache.conf="sudo lime /usr/local/etc/apache2/2.4/httpd.conf"

alias nginx.cd="cd /usr/local/etc/nginx/"
alias nginx.conf="sudo lime /usr/local/etc/nginx/nginx.conf"
alias nginx.sites="sudo lime /usr/local/etc/nginx/sites-enabled/"
alias nginx.start='sudo nginx'
alias nginx.stop='sudo nginx -s stop'
alias nginx.restart='sudo nginx -s reload'
alias nginx.unload='sudo launchctl unload ~/Library/LaunchAgents/homebrew.mxcl.nginx.plist'

##########################
#   client-based stuff   #
##########################

alias focus.cd='cd ~/work/prod/js/Bilgera/focus.webapp'
alias focus.compile='focus.cd; grunt compileToJst'
alias focus.cmp='focus.cd; grunt compileToJst'
alias hocaara.cd='cd ~/worx/misc_patches/hocaara/wp-content/themes/hocaara'
alias hg.boot='apache.restart;cd ~/worx/bsb*'

##########################
#   heroku stuff         #
##########################
alias hgit.clone="heroku git:clone -a $@"
alias hgit.remote="heroku git:remote -a $@"
alias hgit.push="git push heroku master"

##########################
#   git for many remotes #
##########################
git-pullall () { for RMT in $(git remote); do git pull -v $RMT $1; done; }    
alias git-pullall=git-pullall
git-pushall () { for RMT in $(git remote); do git push -v $RMT $1; done; }
alias gpa=git-pushall
alias gp="git push -u origin master"
alias gup='git submodule update --init --recursive; git submodule foreach --recursive git submodule update --init; bower update;'
alias gc="git commit -am '...' --allow-empty"

##########################
#   grunt stuff          #
##########################
alias git-init-install="git clone https://github.com/gruntjs/grunt-init-gruntfile.git ~/.grunt-init/gruntfile; 
git clone https://github.com/gruntjs/grunt-init-jquery.git ~/.grunt-init/jquery;
git clone https://github.com/fooplugins/grunt-wp-boilerplate.git ~/.grunt-init/wp-boilerplate;
git clone https://github.com/kamiyam/grunt-init-express ~/.grunt-init/express;
git clone https://github.com/WeRelax/grunt-init-cordova.git ~/.grunt-init/cordova;
git clone https://github.com/WeRelax/grunt-init-marionette.git ~/.grunt-init/marionette;
git clone git@github.com:substancedev/grunt-wp-theme.git ~/.grunt-init/wp-theme;
git clone https://github.com/gruntjs/grunt-init-node.git ~/.grunt-init/node"


##########################
#   phonegap & weinre    #
##########################

alias gap.prep='nginx.unload; weinre &'
alias gap.debug='open -a "Google Chrome" "http://localhost:8080/client/#anonymous" --args --disable-web-security'


alias launched='launchctl list |grep homebrew; echo REMOVE WITH: launchctl remove ...;'

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
export NPM_PACKAGES="${HOME}/.npm-packages"
export NODE_PATH=/usr/local/lib/node:$NPM_PACKAGES/lib/node_modules
export NODE_PATH=${NODE_PATH}:/Users/d4d3/.node/lib/node_modules
export NODE_PATH=${NODE_PATH}:/Users/d4d3/.npm-packages/lib/node_modules

export NODE_MPATH=${HOME}/.node/lib/node_modules/
export NODE_ENV="development"
export MANPATH=${MANPATH}:/opt/local/share/man
export LD_LIBRARY_PATH=${HOME}/Documents/android-sdk-macosx/tools/lib/

export PATH=/usr/local:/usr/local/bin:/usr/local/sbin:$PATH
export PATH=$PATH:${HOME}/Applications
export PATH=$PATH:/Developer/usr/bin/git
export PATH=$PATH:/usr/local/mysql/bin
export PATH=$PATH:${HOME}/.composer/vendor/bin/
export PATH=$PATH:${NPM_PACKAGES}/bin
export PATH=$PATH:/usr/local/mongodb/bin
export PATH=$PATH:/opt/local/bin:/opt/local/sbin
export PATH=$PATH:/usr/local/php5/bin
export PATH=$PATH:/usr/local/lib/node_modules/npm
export PATH=$PATH:/Work/base/js/jsl-0.3.0-mac
export PATH=$PATH:${NODE_PATH}
export PATH=$PATH:${NODE_MPATH}
export PATH=$PATH:${HOME}/.node/bin
export PATH=$PATH:/usr/local/Library/Formula/
export PATH=$PATH:${ANDROID_SDK_PATH}/tools/:$ANDROID_SDK_PATH/platform-tools/
export RBENV_ROOT="$(brew --prefix rbenv)"
export GEM_HOME="$(brew --prefix)/opt/gems"
export GEM_PATH="$(brew --prefix)/opt/gems"

