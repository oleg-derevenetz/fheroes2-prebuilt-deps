This directory contains scripts used to pre-build the dependencies of the **fheroes2** project for the Windows platform.

* `vcpkg_triplets` directory contains custom [vcpkg](https://vcpkg.io/) triplets for Windows platform, which are used to build binary dependencies;
* `sdl1.bat` downloads and prepares **SDL1** binary dependencies from [https://www.libsdl.org/](https://www.libsdl.org/);
* `sdl2.bat` builds and prepares **SDL2** binary dependencies using [vcpkg](https://vcpkg.io/) infrastructure;
* `zlib.bat` builds and prepares **zlib** binaries using [vcpkg](https://vcpkg.io/) infrastructure.
