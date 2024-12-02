{ pkgs, ... }:
{
  dev = pkgs.mkShell {
    packages = with pkgs; [
      pkgs.llvmPackages_19.clang
      pkgs.nim
      pkgs.sbcl
    ];

    shellHook=''
      unset TEMP TEMPDIR TMP TMPDIR
    '';
  };
}
