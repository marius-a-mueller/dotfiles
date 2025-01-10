function nixos-deploy -a flake host
    nixos-rebuild switch --flake $flake --target-host $host --build-host $host --fast --use-remote-sudo
end
