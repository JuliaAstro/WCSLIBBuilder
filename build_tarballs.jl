# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

# Collection of sources required to build WCS
sources = [
    "https://cache.julialang.org/ftp://ftp.atnf.csiro.au/pub/software/wcslib/wcslib-5.13.tar.bz2" =>
    "d6983e8bc5997e625e66cc3b8590745231f1761437d533ad4b99a015eeb9b4e7",

]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd wcslib-5.13/
sed -i "s/AC_CANONICAL_BUILD/AC_CANONICAL_HOST/" configure.ac
sed -i "s/^ARCH=.*/ARCH=\"$host\"/" configure.ac
sed -i "s/darwin*/*darwin*/" configure.ac
sed -i "s/build_os/host/" configure.ac
autoconf
./configure --prefix=$prefix --host=$target --disable-fortran --without-cfitsio --without-pgplot --disable-utils
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
    FreeBSD(:x86_64)
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libwcs", :libwcs)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, "WCS", sources, script, platforms, products, dependencies)

