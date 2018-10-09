#!/bin/bash

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

	source "$BASE_DIR/$repo/repository.conf"
	image="$namespace/$repo:$tag"

	if [[ ! -d "$BASE_DIR/$repo/$tag" ]]; then
		echo -e "ERROR: No such tag: '$image'.\n" >&2
		exit 1
	fi

	if [[ ! -f "$BASE_DIR/$repo/$tag/Dockerfile" ]]; then
		echo "Docker file for '$image' not found" >&2
		exit 1
	fi

	echo ">>> Building image '$image'..."
	docker build --pull -t "$image" "$BASE_DIR/$repo/$tag" || \
		{ echo -e "ERROR: Failed to build image '$image'.\n\n" >&2; return; }
	echo -e "<<< Image '$image' was built successfully."

	echo ">>> Pushing image '$image'..."
	docker push "$image"|| \
		{ echo -e "ERROR: Failed to push image '$image'.\n\n" >&2; return; }
	echo -e "<<< Image '$image' was pushed successfully.\n"
}

function buildRepo() {
	repo="$1"
	if [[ ! -d "$BASE_DIR/$repo" ]]; then
		echo -e "ERROR: No such repository: '$repo'.\n" >&2
		exit 1
	fi

	source "$BASE_DIR/$repo/repository.conf"
	tags="${order//,/\\n}\\n${order//,/\\n}\\n$(cd "$BASE_DIR/$repo" && find * -maxdepth 0 -type d)"
	tags="$(echo -e "$tags" | sort | uniq -u)"
	tags="${order//,/ } $tags"

	echo -e ">>>>>> Building repository '$namespace/$repo':\n"
	for tag in $tags; do
		if [[ -d "$BASE_DIR/$repo/$tag" ]]; then
			buildTag "$repo" "$tag"
		else			
			echo -e "ERROR: No such tag: '$namespace/$repo:$tag'.\n" >&2
			exit 2
		fi
	done
	echo -e "<<<<<< Repository '$namespace/$repo' built.\n"
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
