# dmus

# Development

Run the app:
```sh
flutter run

# press r in terminal to hotreload
```

Build the app:
```sh
flutter build apk
```

Generate localization:
```sh
flutter gen-l10n
```

# Debugging on a real phone

Connect to a device / emulator using [ADB](https://developer.android.com/tools/adb) ([Arch Linux Package](https://archlinux.org/packages/extra/x86_64/android-tools/))

## Enable Wireless Debugging

Under developer settings, which for me was under, `Settings` > `System` > `Developer Options`.

Look for `Wireless debugging`, enable it, and then click on it.

## Pair Your Device

In the wireless debugging options, there is a `Pair device with pairing code` button. Click this to get a code and ip / port.

Once you've been given the code, in your terminal you can pair the device using `adb pair <ip>:<port> <code>`.

An example looks something like:
```
$ adb pair 192.168.1.61:42009 302457
Successfully paired to 192.168.1.32:44091 [guid=adb-43122FDF6104FU-hvguED]
```

You will get a message like the above, and you should see a device appear on your phone.

## Connect Your Device

Once you have paired the device, you need to actually connect to it.

In the wireless debugging options, it will say `IP address & Port` and list off these values.

In your terminal, you can connect to the device using `adb connect <ip>:<port>`.

An example looks something like:
```
$ adb connect 192.168.1.32:42359
connected to 192.168.1.32:42359
```

You should see a notification appear on your phone.

