#!/bin/bash

     # Check if version argument is provided
     if [ -z "$1" ]; then
       echo "Error: Please provide a version number (e.g., 0.0.2)"
       exit 1
     fi

     VERSION=$1

     # Validate version format (X.Y.Z)
     if ! [[ $VERSION =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
       echo "Error: Version must be in the format X.Y.Z (e.g., 0.0.2)"
       exit 1
     fi

     # Update pubspec.yaml with new version
     sed -i '' "s/^version: .*/version: $VERSION/" pubspec.yaml

     # Prompt for changelog entry
     echo "Enter changelog entry for version $VERSION (press Ctrl+D when done):"
     CHANGELOG_ENTRY=""
     while IFS= read -r line; do
       CHANGELOG_ENTRY+="$line\n"
     done

     # If no changelog entry provided, use a default
     if [ -z "$CHANGELOG_ENTRY" ]; then
       CHANGELOG_ENTRY="## [$VERSION] - $(date +%Y-%m-%d)\n\n### Changed\n- Version bump to $VERSION.\n"
     fi

     # Prepend changelog entry to CHANGELOG.md
     if [ -f CHANGELOG.md ]; then
       echo -e "$CHANGELOG_ENTRY\n$(cat CHANGELOG.md)" > CHANGELOG.md
     else
       echo -e "$CHANGELOG_ENTRY" > CHANGELOG.md
     fi

     # Stage and commit changes
     git add pubspec.yaml CHANGELOG.md
     read -p "Enter commit message (e.g., Bump version to $VERSION): " COMMIT_MESSAGE
     if [ -z "$COMMIT_MESSAGE" ]; then
       COMMIT_MESSAGE="Bump version to v$VERSION"
     fi
     git commit -m "$COMMIT_MESSAGE"

     # Create and push the new tag
     git tag v$VERSION

     # Push changes and tag to the main branch
     git push origin main
     git push origin v$VERSION

     echo "Version $VERSION committed and tagged. Pushed to main and tag v$VERSION. GitHub Actions workflow will now run."