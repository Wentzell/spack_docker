# Use an Ubuntu as a base image
FROM centos:6

# Install required packages as specified in pkglst
RUN yum -y install git make python curl gcc-c++ gcc-gfortran vim openmpi-devel openssl-devel lapack-devel patch unzip xz

# Make user and copy spack config
RUN useradd -m user
ADD .spack /home/user/.spack
RUN chown -R user:user /home/user/.spack
RUN echo "source share/spack/setup-env.sh" >> /home/user/.bashrc
USER user

# Clone spack and install triqs
RUN git clone https://github.com/Wentzell/spack.git /home/user/spack
WORKDIR /home/user/spack
ENV PATH /home/user/spack/bin:${PATH}
RUN git checkout triqs
RUN spack install gcc@7.1.0
RUN spack load gcc@7.1.0
RUN spack compiler find
RUN spack install triqs %gcc@7.1.0

CMD /bin/bash
