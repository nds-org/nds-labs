FROM ubuntu:trusty

RUN apt-get -qq update && \
    apt-get -qy install git mysql-server apache2 supervisor \
      php5 php5-mysql php5-gd php5-dev php5-curl php-apc php5-cli php5-json python-pygments && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
    
RUN a2enmod rewrite

WORKDIR /srv
RUN for repo in libphutil arcanist phabricator ; \
       do \
          git clone https://github.com/phacility/$repo.git ; \
          cd $repo ; \
          git pull --rebase ; \
          cd .. ; \
       done

ADD ./basic.conf.php /srv/phabricator/conf/custom/basic.conf.php
ADD ./000-default.conf /etc/apache2/sites-available/000-default.conf
ADD ./my.cnf /etc/mysql/my.cnf
ADD ./run.sh /usr/local/bin/run.sh
ADD ./phd.conf /etc/supervisor/conf.d/phd.conf

ENV PHAB_HOSTNAME=phabricator.nationaldataservice.org
EXPOSE 80

CMD supervisord -n
