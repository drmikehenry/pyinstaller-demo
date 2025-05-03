Proof of concept using uv, PyInstaller, and Docker to build a Python-based
project into an executable that runs on older Linux.

Key ideas:

- PyInstaller bundles up the current Python interpreter and Python source code
  to make an executable.  This executable on Linux typically depends on Glibc.

- Building on a too-new Linux host means the Glibc version dependency will be
  too new for the resulting executable to run on older Linux.

- Building via Docker on older Linux solves the Glibc version problem; but the
  stock Python interpeters available on those old systems are too old to work
  with newer Python code bases.

- The DeadSnakes project builds some newer Python versions for installation on
  some older Linux hosts, but not very far back.  Ubuntu 16.04 support was
  revoked in 2022, and 18.04 support was revoked in 2023.  The current plan
  seems to be to revoke support for all end-of-lifed distributions:
  https://github.com/deadsnakes/issues/issues/251

- The python-build-standalone project provides Python interpreters built with
  support for fairly old machines (e.g., Ubuntu 14.04):
  https://gregoryszorc.com/docs/python-build-standalone/main/running.html#runtime-requirements

- Uv provides easy access to Python interpreters from python-build-standalone.

- Uv is statically linked and will run on old Linux machines.

Therefore, we can use Docker with an Ubuntu 14.04 image along with uv,
python-build-standalone, and PyInstaller to build a modern Python project into
an executable that will run on Ubuntu 14.04.

To demonstrate:

    docker build -t pyinstaller-demo .
    docker run --rm pyinstaller-demo

Verifying dependencies:

    docker run --rm --entrypoint cat pyinstaller-demo \
      /usr/local/bin/pyinstaller-demo > pyinstaller-demo

    chmod +x pyinstaller-demo
    ldd pyinstaller-demo

With output:

    linux-vdso.so.1 (0x00007ffffc9d8000)
    libdl.so.2 => /lib/x86_64-linux-gnu/libdl.so.2 (0x00007a6255dbf000)
    libz.so.1 => /lib/x86_64-linux-gnu/libz.so.1 (0x00007a6255da3000)
    libpthread.so.0 => /lib/x86_64-linux-gnu/libpthread.so.0 (0x00007a6255d9e000)
    libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007a6255a00000)
    /lib64/ld-linux-x86-64.so.2 (0x00007a6255de8000)

Demonstrating for CentOS 7:

    docker build -t pyinstaller-demo-centos7 . -f centos7.Dockerfile
    docker run --rm pyinstaller-demo-centos7
