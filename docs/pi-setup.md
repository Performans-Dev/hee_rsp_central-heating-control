## SSH
`nano ~/.ssh/known_hosts`
```
ssh-copy-id pi@192.168.1.123
```

## INSTALL FLUTTER
```
sudo apt update
sudo apt install snapd
sudo reboot
```

```
sudo snap install core
sudo snap install flutter --classic
```

```
sudo apt-get -y install libsqlite3-0 libsqlite3-dev
```

```
export XDG_RUNTIME_DIR=/tmp/user-$USER
```


## SET RTC 
1. Install tools
```
sudo apt-get install i2c-tools
sudo i2cdetect -y 0 # (if using Raspberry Pi 1A or 1B or)
sudo i2cdetect -y 1 # (if using Raspberry Pi 2 or later)
```
2. Edit boot config
```
sudo nano /boot/config.txt
```
at the end of the file, add
```
dtoverlay=i2c-rtc,ds1307
```

3. Add the module to /etc/modules:
```
sudo nano /etc/modules
```
at the end of the file, add
```
rtc-ds1307
```

4. edit/lib/udev/hwclock-set
```
sudo nano /lib/udev/hwclock-set
```
Comment out the following lines with #
```
#if [ -e /run/systemd/system ] ; then
#exit 0
#fi
```

5. reboot
```
sudo reboot
```

6. set time

`date` or `sudo date -s "2 OCT 2015 18:00:00"`

7. save the date onto the RTC Pi
```
sudo hwclock -w
```

8. Verify the date has been saved onto the RTC Pi with the following:
```
sudo hwclock -r
```
https://www.abelectronics.co.uk/kb/article/30/rtc-pi-setup-on-raspberry-pi-os


## COPY SOURCE TO PI
```
rsync -avz ~/Development/FlutterProjects/heethings/CentralHeatingControl/CHC pi@192.168.1.123:~/Heethings
rsync -avz ~/Developer/Projects/chc/hee_rsp_central-heating-control pi@192.168.1.123:~/Heethings
```

## BUILD ON PI
```
cd ~/Heethings/CHC
flutter clean && flutter pub get && flutter analyze && dart fix --apply && flutter build linux --release
```

## RUN ON PI
```
cd ~/Heethings/CHC/build/linux/arm64/release/bundle
```
```
sudo ./central_heating_control
```
or
```
sudo ./build/linux/arm64/release/bundle/central_heating_control
```

