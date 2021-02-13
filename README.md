# openconnect for Cisco Anyconnect servers with SSO

This repo combines two docker images to enable headless VPN access to systems with web-based single-sign on SSO systems.

## usage

First build the docker images:

```
docker build -t openconnect -f Dockerfile.openconnect .
docker build -t openconnect-sso -f Dockerfile.openconnect-sso .
```

Now, install the x11docker script, and use it to call openconnect-sso:

```
x11docker openconnect-sso -i
```

Once in, use openconnect-sso to log in and get the cookie / fingerprint pair:

```
.local/bin/openconnect-sso --authenticate --server uthscvpn1.uthsc.edu
```

A window will pop up. Use this to log in normally, responding to the 2FA question as needed.
In UTHSC's case, we use Duo MFA to complete the access.

This will return an environment string that we will copy:

```
HOST=https://uthscvpn1.uthsc.edu/
COOKIE=........
FINGERPRINT=..........
```

Copy this, close this docker session and open another:

```
docker run -v /home/erik/.ssh:/root/.ssh --privileged -it --rm openconnect
```

Paste the HOST, COOKIE, FINGERPRINT into the terminal, and run openconnect:

```
echo $COOKIE | openconnect -b --cookie-on-stdin $HOST --servercert $FINGERPRINT
```

You'll now be able to use ssh to log into servers on the UTHSC network, e.g.:

```
ssh me@octopus01
```

Thanks to containerization, this is accomplished without system-level execution of a VPN.

## issues

Automatic, headless login with openconnect-sso works on my desktop, but this seems to depend on a fully-functional gnome-keyring.
If this could be resolved, we could use only one docker image (openconnect-sso) on a headless server.
