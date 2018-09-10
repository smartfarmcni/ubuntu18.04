FROM ubuntu:18.04

ADD ./environment.yml .

RUN apt-get update && apt-get install -y \
    libopenblas-base libboost-python-dev libsuperlu5 \
    build-essential gfortran qttools5-dev qt5-default \
    cmake git curl bzip2 redis-server libpqxx-dev libboost-test-dev \
    libyaml-cpp-dev libboost-dev libblas-dev liblapack-dev \
    openjdk-8-jre-headless \
    python3-psycopg2 python3-redis python3-ruamel.yaml python3-psutil \
    socat wget \
    && echo "deb http://apt.postgresql.org/pub/repos/apt/ bionic-pgdg main" | tee /etc/apt/sources.list.d/docker.list \
    && wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y postgresql-9.6 \
    && apt-get clean
RUN git clone --recursive --branch 3.5.4 https://github.com/Cylix/cpp_redis.git && \ 
    cd cpp_redis && git submodule update --init --recursive && mkdir build && cd build && \
    cmake .. && make && make install && cd ../.. && rm -rf cpp_redis 
RUN curl --silent -o miniconda-installer.sh https://repo.continuum.io/miniconda/Miniconda3-4.3.31-Linux-x86_64.sh && \ 
    bash miniconda-installer.sh -b -p $HOME/anaconda3 && rm miniconda-installer.sh
RUN $HOME/anaconda3/bin/conda env create -f environment.yml

