# Kinderampel

Kid friendly alarm clock resembling a traffic light.

![alarm-clock-looping](https://user-images.githubusercontent.com/21044999/103445861-1a25b580-4c47-11eb-943f-b2163caa2044.gif)

## To Run:
1. Clone the repo and `cd kinderampel`
2. Set target e.g. `export MIX_TARGET=rpi0`
3. Install dependecies `mix deps.get`
4. Create firmware bundle `mix firmware`
5. To create a bootable SD Card `mix burn`

## Over the air update
The below steps are optional, however it will streamline development process significantly.
1. Set environment variables `SSID` and `PSK` to configure WiFi connection
2. Connect the raspberry pi zero via the gadget connection to the host
3. Run `ssh nerves.local`
4. Inspect `VintageNet.info` to confirm that `wlan0` is included in the available interfaces list. Under the `Interface wlan0` section you will also find the ipaddress being used under `Addresses`. 
5. You can also find the ipaddress by inspecting`RingLogger.next`. This is also a great debugging tool. You should see something like this being logged:
```
00:00:20.020 [debug] udhcpc(wlan0): udhcpc: lease of xxx.xxx.x.xxx obtained, lease time 7200
```
6. Once you've identified the correct ipaddress you should be able to run `ssh ${ipaddress}`
7. After compiling your firmware, you can run `upload.sh ${ipaddress}` to deploy updates over the air

Note: If you are configuring correct SSID and password to a WiFi network, but your device is failing to connect to it it may due to the type of WiFi network. It may be that the WiFi network may be 5GHz and your device is only compatible with 2.4GHz. 

## Hardware Used
With the listed items below no soldering was required:
- [Raspberry Pi Zero WH](https://www.adafruit.com/product/3708)
- [Pi Traffic Light](https://lowvoltagelabs.com/products/pi-traffic/)
- Micro SD Card, and adapter to read it on host
- Micro USB cable that supports data transfer

## Debugging
Inspect `RingLogger.next` to see what is being logged.

## Todo:
1. Add a HTTP API layer to allow controlling the lights from a web UI
2. Can we avoid constantly checking time every few x seconds? Is there a way to increase performance by adding idle time?
