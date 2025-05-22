# flavor_tutorial
Flutter Firebase CLIをFlavorで使用するためのチュートリアル。

Firebaseにプロジェクトが存在するか確認する
```shell
firebase projects:list
```

# flavor_tutorial
Flutter Firebase CLIをFlavorで使用するためのチュートリアル。

Firebaseにプロジェクトが存在するか確認する
```shell
firebase projects:list
```

権限の強化が必要なので以下のコマンドを実行
```shell
chmod +x flutterfire-config.sh
```

```shell
flutterfire config \
  --project=flavor-tutorial-dev \
  --out=lib/firebase_options_dev.dart \
  --ios-bundle-id=com.forgehack.flavorTutorial.dev \
  --ios-out=ios/flavors/dev/GoogleService-Info.plist \
  --android-package-name=com.forgehack.flavor_tutorial.dev \
  --android-out=android/app/src/dev/google-services.json
```
