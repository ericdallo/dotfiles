{ config, lib, pkgs, ... }:

{
  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.hub;
    userName = "Eric Dallo";
    userEmail = "ericdallo06@hotmail.com";

    extraConfig = {
      core = { editor = "vim"; };
      merge = { tool = "vimdiff"; };
      push = { default = "simple"; };
      pull = { rebase = "false"; };
      credential = { helper = "cache --timeout=72000"; };
      apply = {
        whitespace = "fix";
      };
      color = {
        ui = "auto";
        interactive = "auto";

        branch = {
          current = "yellow reverse";
          local = "yellow";
          remote = "green";
        };
        diff = {
          meta = "yellow bold";
          frag = "magenta bold";
          old = "red bold";
          new = "green bold";
        };
        status = {
          added = "yellow";
          changed = "green";
          untracked = "cyan";
        };
      };
      commit = {
        gpgsign = "true";
      };
      url = { "git@github.com:" = { insteadOf = "https://github.com/"; }; };

      github = { user = "ericdallo"; };
    };

    aliases = {
      ci = "commit";

      br = "branch";
      co = "checkout";
      df = "diff -b";
      lg =
        "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%an, %cr)%Creset' --abbrev-commit --date=relative";
      ph = "push origin HEAD";
      pheroku = "push heroku HEAD";

      last = "cat-file commit HEAD";
      sta =
        "ls-files --exclude-per-directory=.gitignore --exclude-from=.git/info/exclude -t -o -u -s -m -d";

      st = "status";

      cat = "-p cat-file -p";
      fu = "fetch origin";
      pum = "pull origin master";
      pom = "pull origin main";
      fupum = "!git co master && git fu && git pum";
      fopom = "!git co main && git fu && git pum";
      upstream =
        "!git fetch upstream && git merge upstream/master master && git ph -f";
      rebasemaster = ''
        !branch="`git branch 2>/dev/null | grep \* | awk '{ print $2 }'`" && echo "Rebasing $branch from master..." && git fupum && git co $branch && git rebase master'';
      cob = ''
        !git fetch origin && git co -b $1 origin/$1 && echo "Checked out origin branch:"'';
      cod = "!git br -D $1 2> /dev/null; git cob $1";
      cia = "!git ci --amend --no-edit";

      top = ''!eval cd "$(pwd)/$(git rev-parse --show-cdup)" && pwd'';

      push-head = "!git push origin `git symbolic-ref HEAD`";
      publish = "push publish";
      pushall = "!git remote | xargs -n1 git push";
      pushalltags = "!git remote | xargs -n1 git push --tags";

      tblog =
        "log --not-grep='Auto-increment of build number due to changes in directory '";
      tbk =
        "!gitk --not-grep='Auto-increment of build number due to changes in directory '";

      vgc = "repack -f -a -d --depth=250 --window=250";
      nvgc = "!ionice -n7 nice -n20 git vgc";

      findnext = "rev-list --reverse -n1 HEAD..master";
      checkoutnext = "!git checkout `git findnext`";
    };

    ignores = [
      ".lsp/sqlite*"
      ".clj-kondo"
    ];
  };
}
