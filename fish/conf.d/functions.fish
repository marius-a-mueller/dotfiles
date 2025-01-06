function nixos-rebuild -a flake host
    /run/current-system/sw/bin/nixos-rebuild switch --flake $flake --target-host $host --build-host $host --fast --use-remote-sudo
end
