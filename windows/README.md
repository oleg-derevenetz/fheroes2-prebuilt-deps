This directory contains scripts used to pre-build the dependencies of the **fheroes2** project for the Windows platform.

* `vcpkg_triplets` directory contains custom [vcpkg](https://vcpkg.io/) triplets for Windows platform, which are used to build binary dependencies;
* `sdl1_core.bat` downloads and prepares **SDL1** core package using binaries from [https://www.libsdl.org/](https://www.libsdl.org/);
* `sdl1_deps.bat` builds and prepares **SDL1** dependency package using [vcpkg](https://vcpkg.io/) infrastructure;
* `sdl2.bat` builds and prepares **SDL2** package using [vcpkg](https://vcpkg.io/) infrastructure.
