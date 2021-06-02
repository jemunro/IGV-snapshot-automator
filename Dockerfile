# Docker container with the dependencies needed to run the IGV snapshot automator
FROM ubuntu:16.04

LABEL \
  author="Jacob Munro" \
  maintainer="Bahlo Lab"

RUN apt-get update && \
    apt-get install -y
    wget \
    unzip \
    openjdk-11-jdk \
    xvfb \
    xorg \
    python \
    make

# add the source code for the repo to the container
COPY . /IGV-snapshot-automator

# install IGV via the Makefile
# then make a dummy batch script in order to load the hg19 genome into the container
# https://software.broadinstitute.org/software/igv/PortCommands
RUN cd /IGV-snapshot-automator && \
    make install && \
    printf 'new\ngenome hg19\nexit\n' > /genome.bat && \
    xvfb-run --auto-servernum --server-num=1 igv.sh -b /genome.bat

ENV PATH="/IGV-snapshot-automator/:${PATH}"
ENTRYPOINT ["make_IGV_snapshots.py"]
