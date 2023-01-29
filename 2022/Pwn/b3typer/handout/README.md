# b3typer

## Build Instructions (Debug)

```sh
git clone https://github.com/WebKit/WebKit.git
cd WebKit
git checkout 645b9044d2369e3b083b171da517a2440bb4fa18
git apply debug.patch
Tools/gtk/install-dependencies
Tools/Scripts/build-webkit --jsc-only --debug
cd WebKitBuild/Debug/bin

./jsc --useConcurrentJIT=false
```

## Helpful Information

+ The given patch applies to commit `645b9044d2369e3b083b171da517a2440bb4fa18` on the [WebKit git repository](https://github.com/WebKit/WebKit) (a shallow clone should also work here, in case of space/data restrictions).

+ The binary running remote is the release build, and was built on the latest `Ubuntu 22.04` docker image (the dependencies required to run it are `libicu-dev`, `libatomic1` and `libstdc++6`).

+ The debug build contains helpful JS shell functions, which are not present in the release build.

+ You can use the function `brk()` to set breakpoints from JS using the debug build.

+ In case you need a structureID leak for your exploit, you can leak the structureID of an object by using `Reflect.strid(obj)`.

+ Use the flag `--dumpB3GraphAtEachPhase=true` to emit B3 graph data (you will probably need this to debug your exploit).

+ On the server, jsc is running with the flag `--useConcurrentJIT=false`, this increases exploit stability.

+ Run `/readflag` on the server once you get a shell to retrieve your flag.
