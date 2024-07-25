{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    cmake
    vcpkg
    glm
    glew
    SDL2
    lua
    openal
    libvorbis
    # Add other dependencies as needed
    
    # Development tools
    gcc
    #gdb
    #valgrind
    #kcachegrind
    clang-tools # for clang-format, clang-tidy, etc.
  ];

  shellHook = ''
    echo "TEC development environment"
    echo "Run 'cmake .' to configure the project"
    echo "Then run 'make' to build"
  '';
}
