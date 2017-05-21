#!/bin/bash
#
# Increment the version in our gradle project.  This mimics the maven
# release plugin to some degree.
#
# Tag current commit we are on with the version that's in the pom
# file.  Bump that version and commit, then finally push it all back
# to github.
set -o errexit -o errtrace -o nounset


# TODO: Set up some dependency checks: Ensure gradlew is present, ensure
# ${CI} is present, ensure build.gradle file exists, etc.


# Capture Current version & tag it.
declare CURRENT_VERSION=$(grep currentVersion gradle.properties | awk -F= '{print $2}')
git tag -a v$CURRENT_VERSION -m "v$CURRENT_VERSION"

# Set next version and bump pom file to it.
# assume the version is in gradle.properties
NEW_VERSION=$(echo ${CURRENT_VERSION} | perl -e '@va=split(/\./,<>); $va[$#va]++; print join(".", @va);')
sed -i '' -e "s/currentVersion=.*/currentVersion=$NEW_VERSION/g" gradle.properties

echo "  - Commit to github.."
git add gradle.properties
# Including "[skip ci]" in the commit message ensures we don't trigger
# another CI build on master.
git commit -am "Set next release version:  $NEW_VERSION

    Source of this Commit: https://travis-ci.org/${TRAVIS_REPO_SLUG}/builds/${TRAVIS_BUILD_ID}
    [skip ci]"
git push origin HEAD:master
git push origin --tags
echo "  - Success.  Done."
