{ pkgs, ... }:
{
  dev = pkgs.mkShell {
    packages = with pkgs; [
      # clang so we can clang++
      llvmPackages_19.clang
      # nim
      nim
      # common lisp
      sbcl
      # ocaml and related deps
      ocamlPackages.ocaml
      ocamlPackages.dune_3
      ocamlPackages.findlib
      ocamlPackages.utop
      ocamlPackages.odoc
      ocamlPackages.ocaml-lsp
      ocamlformat
    ];

    # all sorts of things get sad if we let nix mess around with the TMPDIR
    # so lets just unset it
    shellHook=''
      unset TEMP TEMPDIR TMP TMPDIR
    '';
  };
}
