# Build Stage
FROM ubuntu:20.04 as builder

## Install build dependencies.
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y cmake clang git

## Add source code to the build stage.
ADD . /taocpp-json-mayhem
WORKDIR /taocpp-json-mayhem

## TODO: ADD YOUR BUILD INSTRUCTIONS HERE.
RUN git submodule update --init --recursive && mkdir build && cd build && CC=clang CXX=clang++ cmake .. && make mayhem-fuzz -j4

# Package Stage
FROM ubuntu:20.04

## TODO: Change <Path in Builder Stage>
COPY --from=builder /taocpp-json-mayhem/build/*_fuzz /

