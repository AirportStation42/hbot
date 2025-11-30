# hbot
## legacy name is helper
My colletion of bash scripts combined into one script to help make my (and your) life that much easier.
<br>
<br>
h helper
<br>
b basic
<br>
o operations
<br>
t toolkit
<br>
<br>
This is a constant work in progress so be prepared for stuff to break and many updates.
<br>
<br>
Note all updates will get a new package realease. When I am working on this project, they come way to fast for that. I finally turned this into a package mostly becuase I was tired of navingating to the script
<br>
<br>
Most of the functions are highly customized for me, my specific use case and setup. I recommend looking though the functions, understand what they are doing and make modifications that work for you and your enviroment.
## Usage
```
hbot [OPTION] [ARGUMENT]
```
## Options

General
```
   -u  updater     Updates from apt, flatpak, and snap
   -x  xfce fixer  Basic xfce fixes for when it breaks
   -c  clean       Delete stuff for bounus space! (apt, fp, trash, thumbnails, tmp, logs, downloads)
```
Config
```
   -d  drawing     Setup drawing tablet
   -m  monitors    Setup displaylink and arrange monitors
   -v  vpn         Setup Mullvad VPN - REQUIRES ARGUMENT - See VPN section of Arguments below
   -t  timezone    temporarily change timezone - REQUIRES ARGUMENT - See Timezone section of Arguments below
```
Firewalls
```
   -f  firewall    Deploy firewall rules - REQUIRES ARGUMENT - See Firewall section of Arguments below
   -w  watcher     Watch firewall rule hits in packets and bytes
  ```

Special
```
   -s  startup     Good modules to run on startup
   -i  install     Overall Machine Setup
```
## Arguments 
Firewall
```
home     standard home use
lax      lax home use - Allow all Out
lax_in   lax home use with inbound - Allow all Out, AND accept ssh and ping IN
limited  limited home use - Internet Only (HTTP, HTTPS, DNS)

web      web server use
pbs      backup server use
wol      wake on lan server use
dns      dns server use

reset    FLUSH ALL rules and ACCEPT by default !!DANGER!!
vm       limited home use - Internet Only (HTTP, HTTPS, DNS) WITHOUT local access
local    no internet, use when doing 1337 hax
```

Timezone
```
pacific  America/Los_Angeles
mountain America/Denver
central  America/Chicago
eastern  America/New_York
arizona  America/Phoenix
korea    Asia/Seoul
auto     GeoClue
```

VPN
```
home   standard vpn config + deploy home firewall ruleset
mobile vpn config without local LAN access
```