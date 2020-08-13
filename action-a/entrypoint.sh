#!/bin/sh -l

# sh -c "echo Hello world my name is $INPUT_MY_NAME"
# pwd
# ls -l

# echo "BIG UGLY booger" > BOOGER.txt

pwd
ls
nimble install -y jester uuids
nim c --passL='-static' --gcc.exe=musl-gcc --gcc.linkerexe=musl-gcc \
    -o:exercism_local_tooling_webserver \
    src/exercism_local_tooling_webserver.nim
