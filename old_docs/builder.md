cd /home/pi/Heethings/cc-source/hee_rsp_central-heating-control
git stash --all
gh repo sync
flutter doctor -v
flutter clean 
flutter pub get
flutter build linux --release -v
cd /home/pi/Heethings/cc-source/hee_rsp_central-heating-control/build/linux/arm64/release/bundle
zip -r cc.zip .
mv cc.zip ~/Desktop
cd ~/Desktop
ftp -n <<EOF
open 217.195.206.12
user ilker.okutman Peb79/^PaL&vDt
cd api2.run/releases.api2.run/heethings-cc
put cc.zip
bye
EOF
rm cc.zip
