#!/bin/bash
#
# Increment the version in our maven project.  This mimics the maven
# release plugin to some degree.
#
# Tag current commit we are on with the version that's in the pom
# file.  Bump that version and commit, then finally push it all back
# to github.
set -o errexit -o errtrace -o nounset


# TODO: Set up some dependency checks: Ensure maven is present, ensure
# ${CI} is present, ensure pom file exists, etc.


# Capture Current version & tag it.
declare CURRENT_VERSION=$(mvn -q -Dexec.executable="echo" -Dexec.args='${project.version}' --non-recursive org.codehaus.mojo:exec-maven-plugin:1.3.1:exec)
git tag -a v$CURRENT_VERSION -m "v$CURRENT_VERSION"

# Set next version and bump pom file to it.
mvn build-helper:parse-version versions:set -DnewVersion=\${parsedVersion.majorVersion}.\${parsedVersion.minorVersion}.\${parsedVersion.nextIncrementalVersion} versions:commit;
declare NEW_VERSION=$(mvn -q -Dexec.executable="echo" -Dexec.args='${project.version}' --non-recursive org.codehaus.mojo:exec-maven-plugin:1.3.1:exec)

echo "  - Commit to github.."
git add pom.xml
# Including "[skip ci]" in the commit message ensures we don't trigger
# another CI build on master.
git commit -am "Set next release version:  $NEW_VERSION

    Source of this Commit: https://travis-ci.org/${TRAVIS_REPO_SLUG}/builds/${TRAVIS_BUILD_ID}
    [skip ci]"
git push origin HEAD:master
git push origin --tags
echo "  - Success.  Done."
