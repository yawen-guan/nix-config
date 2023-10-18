{ ... }: {
  programs.git = {
    enable = true;
    delta.enable = true;
    userName = "Yawen Guan";
    userEmail = "yawen.guan.email@gmail.com";
    extraConfig = {
      pull.rebase = false; # merge
    };
  };
}
