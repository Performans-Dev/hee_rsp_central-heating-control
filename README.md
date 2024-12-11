# central_heating_control

A new Flutter project.


```
cd /home/pi/Heethings/cc-source/hee_rsp_central-heating-control
```

```
git checkout .
git clean -fd
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
```



### Feature List
- Provisioning (x)
- Setup (v)
- Account (x)
- User Management (x)
- Zone Management (v)
- Heater Management (v)
- Sensor Management (v)
- Function Management (x)
- Logs (v)
- Settings (v)
- Mode Management (x)
- Preferences (v)
- Hardware Configuration (x)
- OTA Update (v)
- GPIO Polling (v)
- UART Polling (x)
- Channel Control (v)



