# location_accuracy
iOSのバックグラウンド状態における位置情報精度を可能な限り最高精度にして動作を確認するためのアプリ

# 設定

## Google Map
1. `$ touch {project_root}/location_accuracy/env/env.plist`
1. env_sample.plistの内容をコピー
1. GCPのAPI KeyをGOOGLE_MAP_API_KEYにコピーする

# 内容

1. 「現地地にピンを配置」をタップするとピンを配置する
2. ピンには番号が割り振られ、経路が線でつながる
3. ピンは"record"という音声認識命令で音声操作による配置も可能である
4. 音声操作でアプリがバックグラウンドになってもピンの配置が可能である

![スクリーンショット 2024-03-17 13 05 17（2）](https://github.com/taqucinco-com/location_accuracy/assets/45273979/0db40f92-43ab-45fe-9658-71524729eab6)

![スクリーンショット 2024-03-17 13 08 04（2）](https://github.com/taqucinco-com/location_accuracy/assets/45273979/e0abd28a-bc3c-4d3a-b7c3-49c5b408294d)
