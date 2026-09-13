{ lib, ... }:
{
  options.my.identity.email = lib.mkOption {
    type = lib.types.str;
    description = "Primary email address, shared across programs (git, firefox sync, ...)";
  };
}
