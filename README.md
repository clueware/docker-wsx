# VMWare WSX docker image

This Dockerfile and its accompanying files are meant to build a straightforward VMWare WSX server image.

The only thing missing is the bundle that you can download from the VMWare website [here], as licensing considerations prevent me from storing it here.

Building the image is done using the usual
```sh
$ cd docker-wsx
$ docker build -t [wsx_image] .
```

Then running it like this:

```sh
$ docker run -t wsx_server wsx_image
```
The default listing port is 8888.

## Options

There are two Scripts to enhance the Dockerfile which can be applied (together or seperate) by running either

```sh
$ chmod +x enable-ssl-certificate.sh
$ ./enable-ssl-certificate.sh
```

or

```sh
$ chmod +x enable-upgrade.sh
$ ./enable-upgrade.sh
```

or both, respectively.

The first script will prompt you to enter the required data in order to automatically generate a self-signed SSL-Certificate once the WSX Installer succeeded, which is required to communicate to the WSX Server over HTTPS.

The second script triggers the WSX Beta 1.1 Upgrade Installer right after the base WSX Installer finished. Note that you are required to download the Upgrade Installer by yourself as the same licensing considerations apply as above. Grab the Updater from this [link].


[here]:https://my.vmware.com/web/vmware/details?downloadGroup=WKST-WSX-102&productId=293
[link]:https://my.vmware.com/group/vmware/get-download?downloadGroup=WKST-WSX-110-BETA
