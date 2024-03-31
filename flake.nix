{
  description = "NixOS Gui Developer";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = { self, nixpkgs, home-manager, ...}: 

    let lib = nixpkgs.lib; 

  in {

   
    nixosConfigurations = {
      tuckernix = lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          ./hardware-configuration.nix 
            ./configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
# home-manager.users.mtuckerb = import /home/mtuckerb/home.nix;
            }
        ];			
      };
    };
  };
}
