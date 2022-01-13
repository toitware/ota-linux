# Toit OTA updates for Linux devices

The latest Toit firmware (only available on the alpha channel) published through [toit.io](https://toit.io/) can run on 
Linux and devices can be updated through [console.toit.io](https://console.toit.io/). You will need Toit CLI version 
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

and you will get a `build/toit-armv5te-linux.tgz` file that can be installed on an ARMv5 device. Untar the bundle
on the device and run:

``` sh
toit/boot.sh
```

## Directory structure

```
toit/boot.sh
toit/secret.ubjson
toit/current/config.ubjson
toit/current/flash.registry <- memory mapped storage created by toit.boot
toit/current/flash.uuid <- marker left by toit.boot
toit/current/flash.validity <- marker left by toit.boot
toit/current/toit.boot
toit/current/toit.boot.image
```
