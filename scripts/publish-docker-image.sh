#!/bin/bash
#
# Publish a docker image that was built.  This lets us easily push
# built docker images from CI jobs into Artifactory.
set -o errexit -o errtrace -o nounset

# TODO: Check environment, fail if ${CI} isn't present, etc.  Also
# take better care of the arguments passed to this script.

# TODO: Beyond publishing, we can extend this script to do more as
# well.  Typically if it's just 1 gradle jar or war in a docker image,
# we can make this script build the docker image as well (using the
# same version as the java artifact).

docker push meremortal-mortal-docker.jfrog.io/${1}:${2}
