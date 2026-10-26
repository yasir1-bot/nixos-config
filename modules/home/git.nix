{
  variables,
  ...
}:
{
  programs.git = {
    enable = true;

    settings = {
      user = {
        name = variables.name;
        email = variables.email;
      };

      alias = {
        st = "status --short --branch";
        co = "checkout";
        br = "branch";
        lg = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all";
        last = "log -1 HEAD --stat";
        unstage = "reset HEAD --";
      };

      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      fetch.prune = true;
      rebase.autoStash = true;
      merge.conflictStyle = "zdiff3";
      diff.algorithm = "histogram";
      diff.colorMoved = "zebra";
      core.editor = "nvim";
      core.pager = "less -FRX";
      color.ui = "auto";
    };
  };
}
