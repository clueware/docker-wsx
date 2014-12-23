# VMWare WSX docker image

This Dockerfile and its accompanying files are meant to build a straightforward VMWare WSX server image.

The only thing missing is the bundle that you can download from the VMWare website [here], as licensing considerations prevent me from storing it here.

Build the image is done using the usual
```sh
$ cd docker-wsx
$ docker build -t [wsx_image] .
```

Then running it like this:

```sh
$docker run -t wsx_server wsx_image
```
The default listing port is 8888.

[here]:https://my.vmware.com/web/vmware/details?downloadGroup=WKST-WSX-102&productId=293
