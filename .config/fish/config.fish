# set paths
set PATH /usr/local/sbin $PATH
# set PATH $HOME/Library/Android/sdk/platform-tools $PATH
# set PATH $HOME/Library/Android/sdk/tools/bin $PATH
set -gx PATH /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/bin $PATH
set -gx PATH ~/.local/bin $PATH
# set -gx PATH /Volumes/android/android/out/host/darwin-x86/bin $PATH
set -gx GOPATH $HOME/go
set -gx GOARCH amd64
set -gx GOOS darwin
set -gx PATH $GOPATH/bin $PATH
set -gx NVM_DIR $HOME/.nvm

set -gx LANG en_US.UTF-8
set -gx GPG_TTY (tty)

set -gx SSL_CERT_FILE /etc/ssl/cert.pem
set -gx CPPFLAGS -I/usr/local/opt/openssl/include
set -gx LDFLAGS -L/usr/local/opt/openssl/lib

set -g theme_nerd_fonts yes

fry config auto on > /dev/null
cd (pwd)
nvm use default
pyenv version


# ssh-agent
eval (ssh-agent -c) > /dev/null ^ /dev/null
ssh-add ~/.ssh/id_rsa > /dev/null ^ /dev/null
ssh-add ~/.ssh/id_ecdsa.pub > /dev/null ^ /dev/null

# alt+. = last argument
function fish_user_key_bindings
    bind \e. 'history-token-search-backward'
end

function gmd
  git checkout develop; and git fetch --prune; and git rebase; and git branch --merged | grep "\w\+/\w\+"
end

function gmdd
  git branch --merged | grep "\b/\b" | xargs git branch -d
end

function gcost
  git branch -D stmona
  git fetch
  git checkout stmona
end

function gcostmp
  git branch -D stmona
  git fetch
  git checkout stmona
  git merge --no-ff -
  git push
end

function gcob
  git checkout (git for-each-ref --sort=committerdate refs/heads --format='%(refname:short)' | tail -r | fzf --height=30% --reverse --no-mouse)
end

function gmbb
  set a (git rev-parse --abbrev-ref HEAD)
  git fetch
  git branch -D stmona
  git checkout stmona
  git merge $a
end

function gfpp
  begin
    set -lx OVERCOMMIT_DISABLE 1
    for a in {master,develop}
      git checkout $a; and git push
    end; and git push --tags
  end
end

function gfup
  for a in {master,develop}
    git checkout $a; and git pull --ff --ff-only
  end
end

function gff
  begin
    set -lx OVERCOMMIT_DISABLE 1
    git flow finish
  end
end

function goup
  begin
    set -lx OVERCOMMIT_DISABLE 1
    set branch (git rev-parse --abbrev-ref HEAD)
    git checkout qa
    git checkout develop
    git branch -D qa
    git up
    git checkout $branch
  end
end

function gmqa
  set -lx OVERCOMMIT_DISABLE 1
  set branch (git rev-parse --abbrev-ref HEAD)
  goup
  git stash
  git branch -D qa
  git checkout qa
  git merge $branch; and git push; and fish -c 'bundle check; or bundle install'
end

function gccl
  git add changelog/unreleased/
  git commit -va -m '📝  add changelog item'
end

function gmb
  git merge-base -a $argv[1] HEAD
end

function gdmb
  git diff (git merge-base -a $argv[1] HEAD)
end

function adbpush
  set d /sdcard/Download/
  for f in $argv
    echo "pushing $f to $d..."
    adb -d push $f $d
  end
end

function aw
  awk "{print \$$argv}"
end

function bd
  sed -i '/ ap /d' (git status --short|awk '{print $2}')
  sed -i '/ byebug/d' (git status --short|awk '{print $2}')
  sed -i '/ console\.debug/d' (git status --short|awk '{print $2}')
  sed -i '/ console\.log/d' (git status --short|awk '{print $2}')
end

# random values
set -x EDITOR (which nvim ;or which vim)
set -x USE_CCACHE 1
set -x MAKEFLAGS -j8
set -gx TERM screen-256color

# abbreviations
abbr -a -g v nvim -o
abbr -a -g g git
abbr -a -g gdf git dsf
abbr -a -g ga git add
abbr -a -g gst git status
abbr -a -g gd git diff
abbr -a -g gdc git diff --cached
abbr -a -g gp git push
abbr -a -g gm git merge --no-ff
abbr -a -g gc git commit -v
abbr -a -g gca git commit -av
abbr -a -g gco git checkout
abbr -a -g gup git pull --rebase
abbr -a -g gfg 'git ls-files|grep'
abbr -a -g gsup git submodule update --init
abbr -a -g gf git flow
abbr -a -g gffs git flow feature start
abbr -a -g gffp git flow feature publish
abbr -a -g gffr env OVERCOMMIT_DISABLE=1 git flow feature rebase
abbr -a -g sc systemctl
abbr -a -g ssc sudo systemctl
abbr -a -g rrg 'rake routes | grep'
abbr -a -g dc docker-compose
abbr -a -g dcl docker-compose logs
abbr -a -g drw docker-compose run --rm web
abbr -a -g drws docker-compose run --rm web bin/spring
abbr -a -g dew docker-compose exec web
abbr -a -g dewb docker-compose exec web bundle
abbr -a -g dews docker-compose exec web bin/spring
# abbr -a -g dap sed -i / ap /d (git status --short|awk {print \$2})
abbr -a -g le less -R
abbr -a -g lsd lynx -stdin -dump
abbr -a -g os env BUNDLE_GEMFILE=.overcommit_gems.rb bundle exec overcommit --sign
abbr -a -g od env OVERCOMMIT_DISABLE=1
abbr -a -g t trans
abbr -a -g cc ccat

# git wip
function work_in_progress
  if git log -n 1 | grep -q -c wip; then
    echo "WIP!!"
  end
end

function tm
  tmux attach; or tmux
end

function drwr
  docker-compose run --rm web bin/spring rspec (git status --short | awk "{print \$2}" | grep -E "^spec/.*_spec.rb")
end

function rslf
  git ls-files | grep -E "^spec/.*($argv[1]).*_spec\.rb\$"
  env RAILS_ENV=test bin/rspec (git ls-files | grep -E "^spec/.*($argv[1]).*_spec\.rb\$")
end

function drwdb
  docker-compose stop db
  docker-compose rm -f db
  docker-compose run                   --rm web bash -c 'bundle check || bundle'
  parallel ::: \
    "docker-compose run --rm web bin/spring rake db:setup" \
    "sleep 1; docker-compose run -e RAILS_ENV=test --rm web bin/spring rake db:setup" \
    "docker-compose up -d"
end

function drwrs
   docker-compose stop
   docker-compose rm -v
   docker-compose run --rm web bash -lc 'gem install bundler; bundle install -j128'
   docker-compose up -d
end

function gls
  git log --oneline --author='yaa\?chi' --since="$argv[1] days ago"
end

function gfc
  git status --short | awk "{print \$2}"
end

function brup
  brew update
  and brew outdated
  and brew upgrade
  and brew cask upgrade
  and brew cleanup
end

function update_powerlinego
  go get -u github.com/justjanne/powerline-go
end

function fish_prompt
  ~/go/bin/powerline-go -error $status -shell bare
end

function mkcdir
  set dir $argv[1]
  mkdir -p $dir ; and cd $dir
end

function mktouch
  mkdir -p (dirname $argv[1])
  touch $argv[1]
end

function rails
  if test -f bin/rails
    bin/rails $argv
  else
    rails $argv
  end
end

function rspec
  if test -f bin/rspec
    bin/rspec $argv
  else
    rspec $argv
  end
end

function pryc
  pry -r ./config/environment
end

function ml
  fish -c 'sleep 5; m lock' & ;sleep 10; cd $HOME/github/xmr-stak; eval $HOME/github/xmr-stak/bin/xmr-stak
end

function xmr2hkd
  curl -s --compress "https://currencio.co/xmr/hkd/$argv/" | pup '.result-text text{}'
end

function coin2hkd
  curl -s --compress "https://currencio.co/$argv[1]/hkd/$argv[2]/" | pup '.result-text text{}'
end

function coin2usd
  curl -s --compress "https://currencio.co/$argv[1]/usd/$argv[2]/" | pup '.result-text text{}'
end

function coins
  coin2usd btc 1 &
  coin2usd eth 1 &
  coin2usd xmr 1 &
  coin2usd mco 1 &
end

function etn2usd
  set usd (curl -s --compress https://graphs.coinmarketcap.com/currencies/electroneum/ | jq '.price_usd | last | last')
  math -s2 "$usd *$argv"
end

function sgd2fiat
  curl -s "https://finance.google.com/finance/converter?a=$argv[2]&from=SGD&to=$argv[1]" | pup '.bld text{}' | grep -Eo '\d+\.\d+'
end

function usd2fiat
  curl -s "https://finance.google.com/finance/converter?a=$argv[2]&from=usd&to=$argv[1]" | pup '.bld text{}' | grep -Eo '\d+\.\d+'
end

function whattomine
  curl -s 'whattomine.com/coins.json' | jsonpp | less
end

function wttr
  curl -s wttr.in
end

function update_go_cli
  for a in {cjbassi/gotop,justjanne/powerline-go}
    echo "updating $a ..."
    go get -u "github.com/$a"
  end
end

function icat
  kitty +kitten icat "$argv"
end
alias fzg='find /Volumes/GoogleDrive | fzy'
alias gwip='git add -A; git ls-files --deleted -z | xargs -0 git rm; git commit -m "wip"'
alias gunwip='git log -n 1 | grep -q -c wip; and git reset HEAD~1'
alias gdq='git checkout develop; and git branch -D qa'
alias gts='git tag -l --sort=v:refname | tail -n20'

alias bi='bundle check; or bundle install'
alias bii='bundle install'
alias bu='bundle update'
alias be='bundle exec'

alias rm='safe-rm'

alias ...='cd ../..'
alias ....='cd ../../..'

abbr -a -g pie perl -p -i -e "s###g"

defaults write .GlobalPreferences com.apple.mouse.scaling -1

test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish
