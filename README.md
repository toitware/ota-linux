# Toit OTA updates for Linux devices

The latest Toit firmware can run on Linux and devices can be updated through console.toit.io. You will need Toit CLI version v1.17.2 or later. Use:

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
