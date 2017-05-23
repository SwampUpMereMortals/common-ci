#!/bin/bash
# Tag the repo with the current VERSION.
readonly version=$(cat VERSION)
echo -e "Pushing tag to github: ${version}"
git tag -a v${version} -m "v${version}"
git push origin --tags
