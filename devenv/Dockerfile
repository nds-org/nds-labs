FROM ndslabs/hublaunch

USER root
RUN pip uninstall -y yt 

USER user 
RUN cd /home/user && \
  hg clone http://bitbucket.org/yt_analysis/yt && \
  cd yt && \
  python2.7 setup.py develop --user

# Now let's do some things with IPython and whatnot
RUN cd /home/user/ && \
    git clone --recursive https://github.com/ipython/ipython.git && \
    cd ipython && \
    pip install -e ".[notebook]" --user && \
    pip install terminado --user

USER root
RUN sudo apt-get update
RUN sudo apt-get install -y build-essential gfortran m4

USER user
RUN cd /home/user && \
    curl -OL https://github.com/JuliaLang/julia/releases/download/v0.3.3/julia-0.3.3_b24213b893.tar.gz && \
    tar xvfz julia-0.3.3_b24213b893.tar.gz && \
    cd julia-0.3 && \
    echo "prefix=/usr/local/" > Make.user && \
    echo "JULIA_CPU_TARGET=core2" >> Make.user && \
    make
USER root
RUN sudo apt-get install -y patchelf

RUN cd /home/user/julia-0.3 && \
    sudo make install && \
    make clean 

RUN apt-get purge -y ipython
USER user

RUN /usr/local/bin/julia -e 'Pkg.add("IJulia")'
RUN /usr/local/bin/julia -e 'Pkg.add("YT")'
ENV PATH /home/user/.local/bin:$PATH
RUN /home/user/.local/bin/ipython kernelspec install \
    /home/user/.julia/v0.3/IJulia/deps
