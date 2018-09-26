#!/bin/bash

PREFIX="oneguard"
BASE_DIR="$(dirname "$0")"

function printHelp() {
	cat << EOF
Usage:
	$(basename "$0")
		Build all tags for all repositories
	$(basename "$0") <repository>
		Build all tags for specified repository
	$(basename "$0") <repository>:<tag>
		Build specified tag for the repository repository
	$(basename "$0") --help
		Print this help message

EOF
}

function buildTag() {
	repo="$1"
	tag="$2"
	image="$PREFIX/$repo:$tag"
	if [[ ! -d "$BASE_DIR/$repo/$tag" ]]; then
		echo -e "ERROR: No such tag: '$repo:$tag'.\n" >&2
		return
	fi

	if [[ ! -f "$BASE_DIR/$repo/$tag/Dockerfile" ]]; then
		echo "Docker file for '$image' not found" >&2
		return
	fi

	echo "Building image '$image'..."
	docker build --pull -t "$image" "$repo/$tag" || \
		{ echo -e "ERROR: Failed to build image '$image'.\n\n" >&2; return; }

	echo -e "Image '$image' was built successfully.\n\n"
}

function buildRepo() {
	repo="$1"
	if [[ ! -d "$BASE_DIR/$repo" ]]; then
		echo -e "ERROR: No such repository: '$repo'.\n" >&2
		return
	fi

	for tag in $(ls "$BASE_DIR/$repo"); do
		if [[ -d "$BASE_DIR/$repo/$tag" ]]; then
			buildTag "$repo" "$tag"
		fi
	done
}


function buildAll() {
	for repo in $(ls); do
		if [[ -d "$BASE_DIR/$repo" ]]; then
			buildRepo "$repo"
		fi
	done
}

if [ "$#" -eq "0" ]; then
	buildAll
	exit
fi

if [ "$#" -ne "1" ] || [ "$1" == "--help" ]; then
	printHelp
	exit
fi

if [ "$(grep -c : <<< "$1")" -eq "0" ]; then
	buildRepo "$1"
	exit
fi

repo="$(cut -d : -f 1 <<< "$1")"
tag="$(cut -d : -f 2 <<< "$1")"
buildTag $repo $tag
