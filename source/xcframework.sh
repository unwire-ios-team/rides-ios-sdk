#! /bin/bash

set -Eeuo pipefail

echo ""
echo "--------------------------------------------------------------"
echo "- xcframework.sh ..."
echo "--------------------------------------------------------------"
echo ""

DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)"

while [ $# -gt 0 ]; do
    case $1 in
        # Scheme name.
        -s | --schemeName | --product | -p) shift; SCHEME_NAME=$1;;
        # Outpu dorectory.
        -o | --out | --outputDir | -outDir) shift; OUT_DIR=$1;;
    esac
    shift
done

if ! [[ ${SCHEME_NAME+x} ]]; then
    echo "Required SCHEME_NAME / PRODUCT not specified. You can specify it as an arguments: -s <SCHEME_NAME> (or: -p)"
    exit 1
fi

if ! [[ ${OUT_DIR+x} ]]; then
    OUT_DIR="$(pwd)"
    echo "Output directory not specified, setting to the current directory: ${OUT_DIR}"
fi

PRODUCT="${SCHEME_NAME}"

TMP_DIR="${HOME}/tmp/xcframeworks/${PRODUCT}"

mkdir -p "${TMP_DIR}"

echo "Archiving ${PRODUCT} slide for iOS Simulator..."

xcodebuild archive \
-scheme "${PRODUCT}" \
-destination="iOS Simulator" \
-archivePath "${TMP_DIR}/iOSSimulator.xcarchive" \
-sdk iphonesimulator \
SKIP_INSTALL=NO BUILD_LIBRARIES_FOR_DISTRIBUTION=YES

echo "Archiving ${PRODUCT} slide for iOS Device..."

xcodebuild archive \
-scheme "${PRODUCT}" \
-destination="iOS" \
-archivePath "${TMP_DIR}/iOS.xcarchive" \
-sdk iphoneos \
SKIP_INSTALL=NO BUILD_LIBRARIES_FOR_DISTRIBUTION=YES

echo "Creating xcframework for iOS (device and simulator)..."

xcodebuild -create-xcframework \
-framework "${TMP_DIR}/iOS.xcarchive/Products/Library/Frameworks/${PRODUCT}".framework \
-framework "${TMP_DIR}/iOSSimulator.xcarchive/Products/Library/Frameworks/${PRODUCT}".framework \
-output "${OUT_DIR}/${PRODUCT}".xcframework
