{ pkgs, ... }:
{
  services.udiskie = {
    # Auto mount / unmount USB drives
    enable = true;
  };
}
