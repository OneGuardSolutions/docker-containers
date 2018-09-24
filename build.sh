#!/bin/bash

PREFIX="oneguard"

function buildTag() {
	repo="$1"
	tag="$2"
	image="$PREFIX/$repo:$tag"

	if [[ ! -f "$repo/$tag/Dockerfile" ]]; then
		echo "Docker file for '$image' not found" >&2
		return
	fi

	echo "Building image '$image'..."
	docker build --pull -t "$image" "$repo/$tag" || \
		{ echo -e "ERROR: Failed to build image '$image'.\n\n" >&2; return; }

	echo "Publishing image '$image'..."
	docker push "$image" || \
		{ echo -e "ERROR: Failed to publish image '$image'.\n\n" >&2; return; }

	echo -e "Image '$image' published.\n\n"
}

function buildRepo() {
	repo="$1"
	for tag in $(ls "$repo"); do
		if [[ -d "$repo/$tag" ]]; then
			buildTag "$repo" "$tag"
		fi
	done
}

# Find & Build all images
for repo in $(ls); do
	if [[ -d "$repo" ]]; then
		buildRepo "$repo"
	fi
done
