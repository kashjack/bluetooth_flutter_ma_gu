flutter pub upgrade
mkdir "output"

flutter build apk
cp build/app/outputs/flutter-apk/app-release.apk output/android.apk
#./pgyer_upload.sh -k "862115a01cec65c4b82f68cd14d74e2b" "./output/android.apk"

#flutter build ipa --release --export-method=ad-hoc
#cp build/ios/ipa/flutter_app.ipa output/ios.ipa
#./pgyer_upload.sh -k "862115a01cec65c4b82f68cd14d74e2b" "./output/ios.ipa"

##flutter build ipa --release --export-method=release
