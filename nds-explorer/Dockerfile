FROM ndslabs/simpleserve
VOLUME []
MAINTAINER matthewturk@gmail.com
RUN apt-get install -y curl mercurial git bzip2 optipng libpng-dev build-essential
RUN curl -sL https://deb.nodesource.com/setup | bash -
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y nodejs
RUN npm install -g yo bower grunt-cli

# set up an admin user
RUN useradd admin
RUN echo 'admin:admin' | chpasswd
RUN mkdir /home/admin
RUN chown admin:admin /home/admin
RUN chsh -s /bin/bash admin
USER admin

WORKDIR /tmp
RUN hg clone https://bitbucket.org/nds-org/nds-explorer
WORKDIR /tmp/nds-explorer
RUN npm install grunt-contrib-imagemin
RUN npm install grunt --save-dev
RUN npm install
RUN /usr/bin/bower install
RUN /usr/bin/grunt build
USER root
RUN cp -Rv dist/* /var/www/html/
CMD 'nginx'
