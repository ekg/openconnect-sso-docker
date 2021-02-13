FROM ubuntu
RUN apt update -y && apt upgrade -y && apt install -y curl bash python3-pip python3-venv
RUN DEBIAN_FRONTEND=noninteractive apt install -y tzdata && ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime && dpkg-reconfigure --frontend noninteractive tzdata
RUN apt install -y python3-pyqt5 libnss3 libasound2
RUN pip3 install pipx
RUN pipx install "openconnect-sso[full]"
RUN apt install -y gnome-keyring
RUN apt install -y xvfb
RUN apt install -y sudo ssh
RUN useradd -ms /bin/bash robot && echo "robot:robot" | chpasswd && adduser robot sudo
ADD entrypoint.sh /home/robot
RUN chmod +x /home/robot/entrypoint.sh
ENV HOME /home/robot
ENV USER robot
USER robot
RUN mkdir -p /home/robot/.config/openconnect-sso
ADD config.toml /home/robot/.config/openconnect-sso
WORKDIR /home/robot
#CMD ["/home/robot/entrypoint.sh"]

