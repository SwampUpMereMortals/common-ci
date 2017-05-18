# common-ci

[![Build Status](https://travis-ci.org/SwampUpMereMortals/common-ci.svg?branch=master)](https://travis-ci.org/SwampUpMereMortals/common-ci)

Common CI Scripts installed across all CI builds.

This produces a debian package, and publishes is to the mere mortals
Artifactory server.  After that, it's available from Travis builds
that are setup with the proper credentials.  Those Travis builds
`apt-get install` the package, and use the scripts.

