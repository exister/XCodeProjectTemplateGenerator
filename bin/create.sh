#! /bin/sh

set -e
set -x

function usage() {
  echo "Usage: $0 <template_name> <path_to_new_project> <package_name> <project_name> <class_prefix> <organization_name>"
  echo "  <template_name>: Template name"
  echo "  <path_to_new_project>: Path to your new iOS project"
  echo "  <package_name>: Package name, following reverse-domain style convention"
  echo "  <project_name>: Project name"
  echo "  <class_prefix>: Class prefix"
  echo "  <organization_name>: Organization name"
  exit 1
}

# check whether it is a proper create command (at least 3 arguments)
if [ $# -lt 6 ]; then
	usage
fi

# the two lines below are to get the current folder, and resolve symlinks
SCRIPT="$0"
# need this for relative symlinks
while [ -h "$SCRIPT" ] ; do
   SCRIPT=`readlink "$SCRIPT"`
done

BINDIR=$( cd "$( dirname "$SCRIPT" )" && pwd )
TEMPLATES_DIR="$BINDIR/../templates"

TEMPLATE_NAME=$1
PROJECT_PATH=$2
PACKAGE=$3
PROJECT_NAME=$4
CLASS_PREFIX=$5
ORGANIZATION_NAME=$6

echo "Cloning $TEMPLATE_NAME to $PROJECT_PATH"
echo "Creating project $PACKAGE $ORGANIZATION_NAME $PROJECT_NAME $CLASS_PREFIX"

TEMPLATE_DIR="$TEMPLATES_DIR/$TEMPLATE_NAME"

# check whether the project path exists and is not empty
if [ -d "$PROJECT_PATH" ]; then
	if [ "$(ls -1A "$PROJECT_PATH")" ]; then
		echo "\033[31mError: $PROJECT_PATH is not empty. Please specify an empty folder.\033[m"
		exit 1
	fi
fi

# check whether the template path exists and is not empty
if [ -d "$TEMPLATE_DIR" ]; then
  if [ "$(ls -1A "$TEMPLATE_DIR")" ]; then
    echo "Using $TEMPLATE_DIR"
  else
    echo "\033[31mError: $PROJECT_PATH is not empty. Please specify an empty folder.\033[m"
    exit 1
  fi
fi

# copy the files in; then modify them
echo "Cloning template"
cp -r "$TEMPLATE_DIR/" "$PROJECT_PATH"

# replace placeholders
# echo "Replacing placeholders"
find "$PROJECT_PATH" -type f -exec sed -i '' -e "s/__TESTING__/$PROJECT_NAME/g" {} \;
find "$PROJECT_PATH" -type f -exec sed -i '' -e "s/__CLASS__PREFIX__/$CLASS_PREFIX/g" {} \;
find "$PROJECT_PATH" -type f -exec sed -i '' -e "s/__ORGANIZATION_NAME__/$ORGANIZATION_NAME/g" {} \;
find "$PROJECT_PATH" -type f -exec sed -i '' -e "s/__PACKAGE__/$PACKAGE/g" {} \;

#rename files and folders
echo "Renaming files"
find "$PROJECT_PATH" -d -name "__TESTING__*" -type d -exec sh -c -x '$0 $1 $(echo $1 | sed -e "s/__TESTING__/$2/g")' mv {} $PROJECT_NAME \;
find "$PROJECT_PATH" -d -name "__TESTING__*" -type f -exec sh -c -x '$0 $1 $(echo $1 | sed -e "s/__TESTING__/$2/g")' mv {} $PROJECT_NAME \;
find "$PROJECT_PATH" -d -name "__CLASS__PREFIX__*" -type f -exec sh -c -x '$0 $1 $(echo $1 | sed -e "s/__CLASS__PREFIX__/$2/g")' mv {} $CLASS_PREFIX \;

cd $PROJECT_PATH
pod install
