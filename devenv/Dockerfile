FROM ndslabs/hublaunch

USER root
RUN pip uninstall -y yt 
RUN apt-get update && \
    apt-get upgrade -qy && \
    apt-get purge -y ipython && \
    apt-get install -y julia
RUN cd /tmp/ && \
    git clone --recursive https://github.com/ipython/ipython.git && \
    cd ipython && \
    pip install -e ".[notebook]" && \
    pip install terminado

USER user 
RUN cd /home/user && \
  hg clone http://bitbucket.org/yt_analysis/yt && \
  cd yt && \
  python2.7 setup.py develop --user

RUN julia -e 'Pkg.add("IJulia")'
RUN julia -e 'Pkg.add("YT")'
RUN ipython kernelspec install \
    /home/user/.julia/v0.3/IJulia/deps
