# Build Stage
FROM ubuntu:20.04 as builder

## Install build dependencies.
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y cmake clang git

## Add source code to the build stage.
ADD . /taocpp-json-mayhem
WORKDIR /taocpp-json-mayhem

## TODO: ADD YOUR BUILD INSTRUCTIONS HERE.
RUN git submodule update --init --recursive && ./build_fuzz_targets.sh

# Package Stage
FROM ubuntu:20.04

## TODO: Change <Path in Builder Stage>
COPY --from=builder /taocpp-json-mayhem/fuzz_targets/* /

