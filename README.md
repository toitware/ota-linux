# Toit OTA for Linux devices

The latest Toit firmwares can run on Linux. You will need Toit CLI version v1.17.2 or later. Use:

``` sh
toit update 
```

to get it.

Next, create an identity for your new device using:

``` sh
toit device create-identity
```

This will leave you with a `secret.ubjson` file. Now run:

``` sh
make 
```

and you will get a `bundle.tgz` file that can be installed on an ARMv5 device. Untar the bundle
on the device and run:

``` sh
toit/boot.sh
```
