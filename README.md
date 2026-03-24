# theos-docker

## Setup

```bash
docker build -t theos-builder .
```

32bit (armv7 / armv7s) ビルドが必要な場合は、Swift 5.6.1 toolchain / iPhoneOS15.6 SDK を使用する:

```bash
docker build -t theos-builder-armv7 --build-arg LEGACY_SWIFT=1 .
```

## Usage


### theos

```bash
# nic.pl
docker run -it --rm -v $(pwd):/src --workdir /src theos-builder nic.pl
# make package
docker run -it --rm -v $(pwd):/src --workdir /src theos-builder make package
# make package FINALPACKAGE=1
docker run -it --rm -v $(pwd):/src --workdir /src tweak-builder make package FINALPACKAGE=1
```

### bash

```bash
docker run -it --rm -v $(pwd):/src --workdir /src theos-builder /bin/bash
```
