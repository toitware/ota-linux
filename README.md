# Toit OTA updates for Linux devices

Starting with v1.6.0, Toit firmware published through [toit.io](https://toit.io/) can run on 
Linux and devices can be updated through [console.toit.io](https://console.toit.io/). 

## Build the bundle on your workstation

First step is to build the bundle on your workstation (not an ARM device). Clone this repository
and enter the directory you cloned it into (e.g. `ota-linux`). You will need Toit CLI version 
v1.17.2 or later. [Download it](https://docs.toit.io/getstarted/installation/linux) or use:

``` sh
toit update
```

to get it. Next, create an identity for your new device using:

``` sh
toit device create-identity
```

This will leave you with a `secret.ubjson` file. Now run:

``` sh
make
```

and you will get a `build/toit-armv5te-linux.tgz` file that can be installed on an ARMv5 device. If you want
to run it on your x64 Linux device, you can use:

``` sh
FIRMWARE_MODEL=x64-linux make
```

and the resulting bundle will be in `build/toit-x64-linux.tgz`.

## Install on your device

Copy the `build/toit-armv5te-linux.tgz` or `build/toit-x64-linux.tgz` bundle to your device and untar it there:

```
tar -xvzf toit-armv5te-linux.tgz
```

This will give you the following files in this directory structure:

```
toit/boot.sh
toit/secret.ubjson
toit/current/config.ubjson
toit/current/flash.registry  <- memory mapped storage created by toit.boot
toit/current/flash.uuid      <- marker left by toit.boot
toit/current/flash.validity  <- marker left by toit.boot
toit/current/toit.boot
toit/current/toit.boot.image
```

Now run the boot script and watch it connect to the Toit cloud:

``` sh
toit/boot.sh
```
