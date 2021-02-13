#!/bin/bash

rm -f /tmp/.X99-lock ; export DISPLAY=:99; Xvfb :99 -ac -screen 0 1280x1024x16 &


dbus-run-session -- bash
echo "" | gnome-keyring-daemon --unlock
#openconnect-sso --authenticate --server uthscvpn1.uthsc.edu --user egarris5 --browser-display-mode hidden
