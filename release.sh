#!/bin/bash

# Exit script at first error:
set -e

if [ -f "IAdvizeSDK.zip" ]; then
    echo -e "\033[1;42m => Found release artifact. Unzipping. \033[0m"
    rm -Rf tmp
    unzip -q IAdvizeSDK.zip -d tmp

    echo -e "\033[1;42m => Extracting version name \033[0m"
    versionName=$(grep "version: " tmp/plugin/pubspec.yaml -m 1 | sed "s/version: \(.*\)/\1/")

    echo -e "\033[1;31m WARNING - You are about to push release ${versionName} to the public demo repository. \033[0m"
    echo -e "\033[1;31m Proceed ? [y/n] \033[0m"
    read -s -n 1 key
    case $key in
        y) ;;
        *)
            rm -R tmp
            exit 0
    esac

    echo -e "\033[1;42m => Updating pubspec.yaml to target latest SDK \033[0m"
    sed -i '' "s/iadvize_flutter_sdk: ^\(.*\)/iadvize_flutter_sdk: ^${versionName}/" pubspec.yaml

    echo -e "\033[1;42m => Updating CHANGELOG, UPGRADING & README \033[0m"
    mv tmp/CHANGELOG.md CHANGELOG.md
    mv tmp/UPGRADING.md UPGRADING.md
    mv tmp/README.md README.md

    echo -e "\033[1;42m => Committing/pushing version update \033[0m"
    git add --all
    git commit -m "(build) publish version ${versionName}" --quiet
    git tag "${versionName}"
    git push origin master --tags

    echo -e "\033[1;42m => Release ${versionName} is now public! This is what remains for you to do: \033[0m"
    echo -e "\033[1;95m - Create a github release from tag ${versionName} : https://github.com/iadvize/iadvize-flutter-sdk/releases/new \033[0m"
    echo -e "\033[1;95m - Fill description with changelog info \033[0m"

    rm -R tmp
    exit 0
else
    echo -e "\033[1;101m No release artifact found. \033[0m"
    exit 1
fi
