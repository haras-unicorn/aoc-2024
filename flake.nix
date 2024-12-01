{
  description = "double-star";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";

    cargo2nix.url = "github:cargo2nix/cargo2nix/release-0.11.0";
    cargo2nix.inputs.nixpkgs.follows = "nixpkgs";
    cargo2nix.inputs.flake-utils.follows = "flake-utils";
  };

  outputs = { nixpkgs, flake-utils, cargo2nix, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = { allowUnfree = true; };
          overlays = [ cargo2nix.overlays.default ];
        };

        rustPkgs = pkgs.rustBuilder.makePackageSet {
          rustVersion = "1.75.0";
          packageFun = import ./Cargo.nix;
        };
      in
      {
        packages.${system} = {
          "day-1" = rustPkgs.workspace."day-1" { };
          "day-2" = rustPkgs.workspace."day-2" { };
          "day-3" = rustPkgs.workspace."day-3" { };
          "day-4" = rustPkgs.workspace."day-4" { };
          "day-5" = rustPkgs.workspace."day-5" { };
          "day-6" = rustPkgs.workspace."day-6" { };
          "day-7" = rustPkgs.workspace."day-7" { };
          "day-8" = rustPkgs.workspace."day-8" { };
          "day-9" = rustPkgs.workspace."day-9" { };
          "day-10" = rustPkgs.workspace."day-10" { };
          "day-11" = rustPkgs.workspace."day-11" { };
          "day-12" = rustPkgs.workspace."day-12" { };
          "day-13" = rustPkgs.workspace."day-13" { };
          "day-14" = rustPkgs.workspace."day-14" { };
          "day-15" = rustPkgs.workspace."day-15" { };
          "day-16" = rustPkgs.workspace."day-16" { };
          "day-17" = rustPkgs.workspace."day-17" { };
          "day-18" = rustPkgs.workspace."day-18" { };
          "day-19" = rustPkgs.workspace."day-19" { };
          "day-20" = rustPkgs.workspace."day-20" { };
          "day-21" = rustPkgs.workspace."day-21" { };
          "day-22" = rustPkgs.workspace."day-22" { };
          "day-23" = rustPkgs.workspace."day-23" { };
          "day-24" = rustPkgs.workspace."day-24" { };
        };

        devShells.default = pkgs.mkShell {
          RUST_BACKTRACE = "1";
          packages = with pkgs; [
            # versioning
            git

            # scripts
            just
            nushell

            # tools
            fd

            # spelling
            nodePackages.cspell

            # markdown
            marksman
            markdownlint-cli
            nodePackages.markdown-link-check

            # misc
            nodePackages.prettier
            nodePackages.yaml-language-server
            nodePackages.vscode-langservers-extracted
            taplo

            # nix
            nil
            nixpkgs-fmt
            cargo2nix.packages.${system}.default

            # rust
            llvmPackages.clangNoLibcxx
            lldb
            rustc
            cargo
            clippy
            rustfmt
            rust-analyzer
            cargo-edit
            evcxr
          ];
        };
      });
}
