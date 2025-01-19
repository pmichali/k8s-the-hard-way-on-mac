FROM debian:bookworm-slim

# Install tools and set timezone
RUN apt-get update -y && apt-get install -y tzdata emacs wget curl openssl git net-tools iputils-ping dnsutils sudo openssh-server ripgrep gettext-base kmod iproute2
ENV TZ=US/Eastern \
    DEBIAN_FRONTEND=noninteractive \
    MORE=-e \
    EDITOR=emacs

# Permit root login via SSH
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

WORKDIR /root
COPY machines.txt set-known-hosts.bash jumpbox-install.bash /root/
COPY gitconfig.txt /root/.gitconfig
COPY emacs-config.txt /root/.emacs

# Setup authorized keys
RUN mkdir -p /root/.ssh && chmod 700 /root/.ssh
COPY keys/* /root/.ssh/

# Start SSH server
# RUN systemctl enable ssh

# Running systemd
CMD [ "/sbin/init" ] 
