FROM ubuntu:18.04

ADD ./environment.yml .

RUN apt-get update
RUN apt-get install -y libopenblas-base libboost-python-dev libsuperlu5
RUN apt-get install -y build-essential gfortran qttools5-dev qt5-default 
RUN apt-get install -y cmake git curl bzip2 redis-server libpqxx-dev libboost-test-dev
RUN apt-get install -y libyaml-cpp-dev libboost-dev libblas-dev liblapack-dev
RUN apt-get install -y openjdk-8-jre-headless
RUN apt-get install -y socat wget # only for drone testing
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ bionic-pgdg main" | tee /etc/apt/sources.list.d/docker.list
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y postgresql-9.6 
RUN git clone --recursive --branch 3.5.4 https://github.com/Cylix/cpp_redis.git && cd cpp_redis && git submodule update --init --recursive && mkdir build && cd build && cmake .. && make && make install && cd .. 
RUN curl --silent -o miniconda-installer.sh https://repo.continuum.io/miniconda/Miniconda3-4.3.31-Linux-x86_64.sh && bash miniconda-installer.sh -b -p $HOME/anaconda3
RUN $HOME/anaconda3/bin/conda env create -f environment.yml

