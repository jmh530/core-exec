#!/usr/bin/env bash

set -euvo pipefail

dockerId=$1

err_report() {
    echo "Error on line $1"
}
trap 'err_report $LINENO' ERR

## dub file with unittest
source="/++dub.sdl: name\"foo\" \n dependency\"mir\" version=\"*\"+/ unittest { import mir.combinatorics, std.stdio; writeln([0, 1].permutations); } void main() {}"
bsource=$(echo -e "$source" | base64 -w0)
DOCKER_FLAGS="-unittest" [ docker run -e DOCKER_FLAGS --rm $dockerId $bsource | grep -q "_Dmain" == "[[0, 1], [1, 0]]" ]
