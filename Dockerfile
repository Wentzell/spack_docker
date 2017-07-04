# Use an Ubuntu as a base image
FROM ubuntu:14.04

# Install required packages as specified in pkglst
RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get -y install git make python curl unzip xz-utils g++ gfortran vim libopenmpi-dev openssl liblapack-dev libgmp3-dev environment-modules

# Make user and copy spack config
RUN useradd -m user
ADD .spack /home/user/.spack
RUN chown -R user:user /home/user/.spack
RUN echo "source /home/user/spack/share/spack/setup-env.sh" >> /home/user/.bashrc
RUN echo "source /etc/profile.d/modules.sh" >> /home/user/.bashrc
USER user

# Clone spack and install triqs
RUN git clone https://github.com/Wentzell/spack.git /home/user/spack
ENV PATH /home/user/spack/bin:${PATH}
WORKDIR /home/user/spack
RUN git checkout triqs
RUN spack install gcc@7.1.0
#RUN spack load gcc@7.1.0
#RUN spack compiler find
#RUN spack install triqs %gcc@7.1.0

CMD /bin/bash
