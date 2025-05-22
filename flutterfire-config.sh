#!/bin/bash
# Script to generate Firebase configuration files for different environments/flavors

if [[ $# -eq 0 ]]; then
  echo "Error: No environment specified. Use 'dev', 'staging', or 'prod'."
  exit 1
fi

case $1 in
  dev)
    flutterfire config \
      --project=flavor-tutorial-dev-e7eea \
      --out=lib/firebase_options_dev.dart \
      --ios-bundle-id=com.forgehack.flavortutorial.dev \
      --ios-out=ios/flavors/dev/GoogleService-Info.plist \
      --android-package-name=com.forgehack.flavor_tutorial.dev \
      --android-out=android/app/src/dev/google-services.json
    ;;
  staging)
    flutterfire config \
      --project=flavor-tutorial-staging \
      --out=lib/firebase_options_staging.dart \
      --ios-bundle-id=com.forgehack.flavortutorial.staging \
      --ios-out=ios/flavors/staging/GoogleService-Info.plist \
      --android-package-name=com.forgehack.flavor_tutorial.staging \
      --android-out=android/app/src/staging/google-services.json
    ;;
  prod)
    flutterfire config \
      --project=flavor-tutorial-prod  \
      --out=lib/firebase_options_prod.dart \
      --ios-bundle-id=com.forgehack.flavortutorial \
      --ios-out=ios/flavors/prod/GoogleService-Info.plist \
      --android-package-name=com.forgehack.flavor_tutorial \
      --android-out=android/app/src/prod/google-services.json
    ;;
  *)
    echo "Error: Invalid environment specified. Use 'dev', 'staging', or 'prod'."
    exit 1
    ;;
esac
