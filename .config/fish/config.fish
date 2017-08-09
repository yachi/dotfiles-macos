# set paths
set PATH /usr/local/bin /usr/local/sbin /usr/bin /bin /usr/sbin /sbin
set PATH $HOME/Library/Android/sdk/platform-tools $PATH
set -gx GOPATH $HOME/go
set -gx GOARCH amd64
set -gx GOOS darwin
set -gx PATH $GOPATH/bin $PATH
set -gx NVM_DIR $HOME/.nvm

set -g theme_nerd_fonts yes

fry config auto on > /dev/null
fry use ruby-2.4.1

# shell color
if status --is-interactive
  eval sh $HOME/.config/base16-shell/scripts/base16-default-dark.sh
end


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
set -U fish_user_abbreviations 'v=nvim -o'
set fish_user_abbreviations $fish_user_abbreviations 'g=git'
set fish_user_abbreviations $fish_user_abbreviations 'gdf=git dsf'
set fish_user_abbreviations $fish_user_abbreviations 'gst=git status'
set fish_user_abbreviations $fish_user_abbreviations 'gd=git diff'
set fish_user_abbreviations $fish_user_abbreviations 'gdc=git diff --cached'
set fish_user_abbreviations $fish_user_abbreviations 'gp=git push'
set fish_user_abbreviations $fish_user_abbreviations 'gm=git merge --no-ff'
set fish_user_abbreviations $fish_user_abbreviations 'gc=git commit -v'
set fish_user_abbreviations $fish_user_abbreviations 'gca=git commit -av'
set fish_user_abbreviations $fish_user_abbreviations 'gco=git checkout'
set fish_user_abbreviations $fish_user_abbreviations 'gup=git pull --rebase'
set fish_user_abbreviations $fish_user_abbreviations 'gfg=git ls-files|grep'
set fish_user_abbreviations $fish_user_abbreviations 'gsup=git submodule update --init'
set fish_user_abbreviations $fish_user_abbreviations 'gf=git flow'
set fish_user_abbreviations $fish_user_abbreviations 'gffs=git flow feature start'
set fish_user_abbreviations $fish_user_abbreviations 'gffp=git flow feature publish'
set fish_user_abbreviations $fish_user_abbreviations 'gffr=env OVERCOMMIT_DISABLE=1 git flow feature rebase'
set fish_user_abbreviations $fish_user_abbreviations 'sc=systemctl'
set fish_user_abbreviations $fish_user_abbreviations 'ssc=sudo systemctl'
set fish_user_abbreviations $fish_user_abbreviations 'rrg=rake routes | grep'
set fish_user_abbreviations $fish_user_abbreviations 'dc=docker-compose'
set fish_user_abbreviations $fish_user_abbreviations 'dcl=docker-compose logs'
set fish_user_abbreviations $fish_user_abbreviations 'drw=docker-compose run --rm web'
set fish_user_abbreviations $fish_user_abbreviations 'drws=docker-compose run --rm web bin/spring'
set fish_user_abbreviations $fish_user_abbreviations 'dew=docker-compose exec web'
set fish_user_abbreviations $fish_user_abbreviations 'dewb=docker-compose exec web bundle'
set fish_user_abbreviations $fish_user_abbreviations 'dews=docker-compose exec web bin/spring'
set fish_user_abbreviations $fish_user_abbreviations "dap=sed -i '/ ap /d' (git status --short|awk '{print \$2}')"
set fish_user_abbreviations $fish_user_abbreviations 'le=less -R'
set fish_user_abbreviations $fish_user_abbreviations 'lsd=lynx -stdin -dump'
set fish_user_abbreviations $fish_user_abbreviations 'os=env BUNDLE_GEMFILE=.overcommit_gems.rb bundle exec overcommit --sign'
set fish_user_abbreviations $fish_user_abbreviations 'od=env OVERCOMMIT_DISABLE=1'
set fish_user_abbreviations $fish_user_abbreviations 't=trans'

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
  brew update; and brew outdated; and brew upgrade; and brew cleanup
end

function fish_prompt
  ~/.dotfiles/powerline-shell.py $status --shell bare # ^/dev/null
end

alias gwip='git add -A; git ls-files --deleted -z | xargs -r -0 git rm; git commit -m "wip"'
alias gunwip='git log -n 1 | grep -q -c wip; and git reset HEAD~1'
alias gdq='git checkout develop; and git branch -D qa'

alias bi='bundle check; or bundle install'
alias bii='bundle install'
alias bu='bundle update'
alias be='bundle exec'

alias rm='safe-rm'

alias ...='cd ../..'

set fish_user_abbreviations $fish_user_abbreviations 'pie=perl -p -i -e "s###g"'

defaults write .GlobalPreferences com.apple.mouse.scaling -1

test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish
