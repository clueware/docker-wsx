FROM ubuntu
MAINTAINER Stéphane Rondinaud <steph.github@clueware.org>

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get install -y python expect python-dev python-pip

# add ttrss as the only nginx site
ADD VMware-WSX-1.0.2-928297.x86_64.bundle /tmp/
ADD install_wsx.expect /tmp/
ADD init_user_wsx.expect /tmp/

RUN pip install pyepoll

RUN DEBIAN_FRONTEND=noninteractive apt-get purge -y python-dev python-pip

RUN chmod a+x /tmp/VMware-WSX-1.0.2-928297.x86_64.bundle

RUN expect /tmp/install_wsx.expect

RUN /etc/init.d/vmware-wsx-server stop

RUN adduser -system wsx

RUN /tmp/init_user_wsx.expect

EXPOSE 8888

CMD vmware-wsx-server
