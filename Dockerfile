#Pull base image

FROM nmirikm/raspi_python:3.6.5

RUN apt-get update && apt-get install -y \
    i2c-tools \
    libi2c-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    &&pip install smbus2
# Define working directory 
WORKDIR /work

#https://qiita.com/tm_nagoya/items/17894f33a6f80d00931e
ADD adt7410_13bit.py /work/

# Define default command
CMD ["bash"]
