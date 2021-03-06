#!/bin/bash

# Generates docs:
# 1. Checks out a copy of the repo's gh-pages branch
# 2. Regenerates all docs into that copy
# 3. Pushes the changes to github (if 'upload' argument is specified)

DOCS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DOCS_DIR

# Inputs (relative to dcos-commons/docs/):
PAGES_PATH=${DOCS_DIR}/pages
PAGES_FRAMEWORKS_PATH_PATTERN=${DOCS_DIR}/../frameworks/*/docs/
JAVADOC_SDK_PATH_PATTERN=${DOCS_DIR}/../sdk/*/src/main/

# Output directory:
DEST_DIR_NAME=dcos-commons-gh-pages

# Swagger build to fetch if needed:
SWAGGER_CODEGEN_VERSION=2.2.2
SWAGGER_OUTPUT_DIR=swagger-api
SWAGGER_JAR=swagger-codegen-cli-${SWAGGER_CODEGEN_VERSION}.jar
SWAGGER_URL=http://central.maven.org/maven2/io/swagger/swagger-codegen-cli/${SWAGGER_CODEGEN_VERSION}/${SWAGGER_JAR}

# abort script at first error:
set -eu

error_msg() {
    echo "---"
    echo "Failed to generate docs: Exited early at $0:L$1"
    echo "---"
}
trap 'error_msg ${LINENO}' ERR

run_cmd() {
    echo "RUNNING COMMAND: $@"
    $@
}

UPLOAD_ENABLED=""
if [ "${1:-}" = "upload" ]; then
    UPLOAD_ENABLED="y"
fi

if [ $UPLOAD_ENABLED ]; then
    # Fetch copy of gh-pages branch for output
    if [ -d ${DEST_DIR_NAME} ]; then
        # dir exists: clear before replacing with fresh git repo
        rm -rf ${DEST_DIR_NAME}
    fi
    git clone -b gh-pages --single-branch --depth 1 git@github.com:mesosphere/dcos-commons ${DEST_DIR_NAME}
    rm -rf ${DEST_DIR_NAME}/* # README.md is recovered later
fi

# 1. Generate static jekyll pages
# gem install jekyll

# 1. Generate common + framework docs
# Workaround: '--layouts' flag seems to be ignored. cd into pages dir to generate.
pushd $PAGES_PATH
rm -rf services
mkdir -p services
for dir in $(ls -d $PAGES_FRAMEWORKS_PATH_PATTERN); do
    framework=$(echo $dir | awk -F "/" '{print $(NF-2)}')
    ln -s -v $dir services/$framework
done
run_cmd jekyll build --destination ${DOCS_DIR}/${DEST_DIR_NAME}
popd

# 2. Generate javadocs to api/ subdir
javadoc -quiet -notimestamp -package -d ${DEST_DIR_NAME}/api/ \
    $(find $JAVADOC_SDK_PATH_PATTERN -name *.java) 2>&1 | /dev/null || echo "Ignoring javadoc exit code. Disregard errors about /dev/null."

# 3. Generate swagger html to swagger-api/ subdir
if [ ! -f ${SWAGGER_JAR} ]; then
    curl -O ${SWAGGER_URL}
fi
run_cmd java -jar ${SWAGGER_JAR} \
    generate \
    -l html \
    -i ${SWAGGER_OUTPUT_DIR}/swagger-spec.yaml \
    -c ${SWAGGER_OUTPUT_DIR}/swagger-config.json \
    -o ${DEST_DIR_NAME}/${SWAGGER_OUTPUT_DIR}/

if [ $UPLOAD_ENABLED ]; then
    # Push changes to gh-pages branch
    pushd ${DEST_DIR_NAME}
    git checkout -- README.md # recover gh-pages README *after* generating docs -- otherwise it's removed via generation
    if [ $(git ls-files -m | wc -l) -eq 0 ]; then
        echo "No docs changes detected, skipping commit to gh-pages"
    else
        echo "Pushing $(git ls-files -m | wc -l) changed files to gh-pages:"
        echo "--- CHANGED FILES START"
        git ls-files -m
        echo "--- CHANGED FILES END"
        git add .
        if [ -n "$WORKSPACE" ]; then
            # we're in jenkins. set contact info (not set by default)
            git config user.name "Jenkins"
            git config user.email "jenkins@example.com"
        fi
        git commit -am "Automatic update from master"
        git push origin gh-pages
    fi
    popd
else
    echo "-----"
    echo "Content has been generated here: file://${DOCS_DIR}/${DEST_DIR_NAME}/index.html"
fi
