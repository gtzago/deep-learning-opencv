FROM gtzago/nvidia-opencv
ARG PYTHON_VERSION=3.5
ARG NB_USER=ubuntu

USER $NB_USER
RUN cd /home/$NB_USER && \
    git clone https://github.com/Theano/libgpuarray.git && \
    cd /home/$NB_USER/libgpuarray && \
    git checkout tags/v0.6.2 -b v0.6.2 && \
    rm -rf build Build && \
    mkdir Build && \
    cd /home/$NB_USER/libgpuarray/Build && \
    cmake .. -DCMAKE_INSTALL_PREFIX=~/.local -DCMAKE_BUILD_TYPE=Release && \
    make && \
    make install && \
    cd /home/$NB_USER/libgpuarray
ENV CPATH $CPATH:/home/$NB_USER/.local/include
ENV LIBRARY_PATH $LIBRARY_PATH:/home/$NB_USER/.local/lib
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/home/$NB_USER/.local/lib
RUN cd /home/$NB_USER/libgpuarray && \
    python3 setup.py build && \
    python3 setup.py install --user && \
    cd /home/$NB_USER && \
    rm -R /home/$NB_USER/libgpuarray

USER root
RUN pip3 install tensorflow-gpu keras jupyter

USER $NB_USER    

EXPOSE 8888

CMD jupyter notebook --port=8888 --ip=0.0.0.0
