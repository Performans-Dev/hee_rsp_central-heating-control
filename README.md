# central_heating_control

A new Flutter project.


```
cd /home/pi/Heethings/cc-source/hee_rsp_central-heating-control
```

```
gh repo sync
```

```
sudo rm -rf .dart_tool
flutter clean && flutter pub get
flutter build linux --release
```

```
cp -r /home/pi/Heethings/cc-source/hee_rsp_central-heating-control/build/linux/arm64/release/bundle/* /home/pi/Heethings/cc-app
```

```
sudo /home/pi/Heethings/cc-app/central_heating_control