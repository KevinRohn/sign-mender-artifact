#!/bin/bash

set -e

# $1 = artifact-input-name
# $2 = artifact-output-path
# $3 = signed-artifact-name
# $4 = signing-key-path

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]  || [ -z "$4" ]; then
  echo "Please provide all required variables"
  exit 1
else

  ARTIFACT_INPUT_NAME=$1
  ARTIFACT_OUTPUT_PATH=$2
  ARTIFACT_OUTPUT_NAME=$3
  SIGNING_KEY=$4

  echo "Signed output name $ARTIFACT_OUTPUT_NAME is set."

  if [ -f "$ARTIFACT_INPUT_NAME" ]; then
    echo "Artifact $ARTIFACT_INPUT_NAME path is set for mender-artifact signing."
    true
  else
    echo "Error: $ARTIFACT_INPUT_NAME path does not exist."
    exit 1
  fi

  if [ -d "$ARTIFACT_OUTPUT_PATH" ]; then
    echo "Output path $ARTIFACT_OUTPUT_PATH is set."
    true
  else
    echo "Error: $OUTPUT_PATH path does not exist."
    exit 1
  fi
  if [ -f "$SIGNING_KEY" ]; then
    echo "Singing key $SIGNING_KEY path is set."
    true
  else
    echo "Error: Singing key $SIGNING_KEY path does not exist."
    exit 1
  fi

fi

check_dependency() {
  if ! which "$1" >/dev/null; then
    echo "The $1 utility is not found but required to generate Artifacts." 1>&2
    return 1
  fi
}

if ! check_dependency mender-artifact; then
  echo "No mender-artifact installation found" 1>&2
  exit 1
fi

mender-artifact sign ${ARTIFACT_INPUT_NAME} -k ${SIGNING_KEY} -o ${ARTIFACT_OUTPUT_PATH}/${ARTIFACT_OUTPUT_NAME}.mender

if [ -f "${ARTIFACT_OUTPUT_PATH}/${ARTIFACT_OUTPUT_NAME}.mender" ]; then
  echo "Artifact ${ARTIFACT_OUTPUT_PATH}/${ARTIFACT_NAME}.mender signed successful."
  echo "::set-output name=signed-artifact-path::${ARTIFACT_OUTPUT_PATH}/${ARTIFACT_OUTPUT_NAME}.mender"
  exit 0
else
  echo "Artifact generation failed."
  exit 1
fi
