# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

# Collection of sources required to build WCS
name = "WCS"
version = v"5.19"
sources = [
    "https://cache.julialang.org/ftp://ftp.atnf.csiro.au/pub/software/wcslib/wcslib-5.19.tar.bz2" =>
    "670cb0e8253100ba3e239a576f3bd7b0bf48488125eb056f60fef5e0c19ac90a"

]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd wcslib-5.19/
wget -O config/config.sub 'https://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.sub;hb=HEAD'
if [[ "${target}" == *mingw* ]]; then
    ./configure --prefix=$prefix --host=$target --disable-fortran --without-cfitsio --without-pgplot --disable-utils CFLAGS=-DNO_OLDNAMES
else
    ./configure --prefix=$prefix --host=$target --disable-fortran --without-cfitsio --without-pgplot --disable-utils
fi
make
make install
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Linux(:i686, :glibc),
    Linux(:x86_64, :glibc),
    Linux(:aarch64, :glibc),
    Linux(:armv7l, :glibc, :eabihf),
    Linux(:powerpc64le, :glibc),
    Linux(:i686, :musl),
    Linux(:x86_64, :musl),
    Linux(:aarch64, :musl),
    Linux(:armv7l, :musl, :eabihf),
    MacOS(:x86_64),
    FreeBSD(:x86_64),
    Windows(:i686),
    Windows(:x86_64)
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libwcs", :libwcs)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)

