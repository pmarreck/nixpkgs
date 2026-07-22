{
  lib,
  stdenv,
  mingw_w64_headers,
  # Rustc require 'libpthread.a' when targeting 'x86_64-pc-windows-gnu'.
  # Enabling this makes it work out of the box instead of failing.
  withStatic ? true,
}:

stdenv.mkDerivation {
  pname = "mingw_w64-pthreads";
  inherit (mingw_w64_headers) version src meta;

  configureFlags = [ (lib.enableFeature withStatic "static") ];

  # llvm-rc does not inherit the target compiler wrapper's header search path.
  # Pass the MinGW headers explicitly for src/version.rc's <winver.h> include.
  RCFLAGS = "--include-dir=${mingw_w64_headers}/include";

  preConfigure = ''
    cd mingw-w64-libraries/winpthreads
  '';
}
