#!/bin/bash

set -eo pipefail

xcodebuild \
  -workspace TravelAssistance/TravelAssist.xcworkspace \
  -scheme WTP_Leisure_Dev \
  -sdk iphonesimulator \
  -destination 'platform=iOS Simulator,name=iPhone 12' \
  test | xcpretty
