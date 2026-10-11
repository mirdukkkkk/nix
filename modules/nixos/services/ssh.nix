{ config, lib, ... }:
{
  services.openssh = {
    enable = true;
    openFirewall = true;
  };

  # Host keys live on the tmpfs root; without them every boot generates new
  # ones and clients see a changed host key.
  preservation.preserveAt."/persist".files = lib.concatMap (key: [
    {
      file = key.path;
      mode = "0600";
    }
    "${key.path}.pub"
  ]) config.services.openssh.hostKeys;
}
