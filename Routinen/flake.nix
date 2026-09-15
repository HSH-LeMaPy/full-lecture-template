{
  description = "Quarto + Python via Nix";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };

      pythonEnv = pkgs.python312.withPackages (ps: with ps; [
        jupyter
        ipykernel
        numpy
	networkx
        pandas
        matplotlib
        sympy
	# hier pip packages hinzufügen, können auf search.nixos.org gefunden werden
      ]);
    in {
      devShells.${system}.default = pkgs.mkShell {
        packages = [
	  pkgs.pandoc
          pkgs.quarto
	  pkgs.chromium  # wichtig zum mermaid rendern!!!
          pythonEnv
        ];

        shellHook = ''
          export QUARTO_PYTHON=${pythonEnv}/bin/python3
	  export QUARTO_CHROMIUM=${pkgs.chromium}/bin/chromium
	'';
      };
    };
}
