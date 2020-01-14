#!/bin/sh

# Move to parent directory to format and lint
cd ..

# Run oclint related commands to check for any issues

echo "$(tput setaf 4) Running OClint"

unset LLVM_TARGET_TRIPLE_SUFFIX

xcodebuild -target Segment-Facebook -configuration Debug -scheme Segment-Facebook clean
xcodebuild -target Segment-Facebook -configuration Debug -scheme Segment-Facebook COMPILER_INDEX_STORE_ENABLE=NO | xcpretty -r json-compilation-database --output compile_commands.json
oclint-json-compilation-database —e Segment_Facebook.h Segment_Facebook_vers.c Pods -- build -report-type xcode

echo "$(tput setaf 4) Linting pod spec"

# Move to integrations destinations to run pod lint
cd Integrations/analytics-ios-integration-facebook-app-events

# Run pod lint to check for any issues in podspec
pod lib lint --use-libraries --allow-warnings
