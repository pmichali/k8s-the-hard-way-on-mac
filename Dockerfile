FROM debian:bookworm-slim

# Install tools and set timezone
RUN apt-get update -y && apt-get install -y tzdata emacs wget curl openssl git net-tools iputils-ping dnsutils sudo openssh-server ripgrep gettext-base kmod
ENV TZ=US/Eastern \
    DEBIAN_FRONTEND=noninteractive \
    EDITOR=emacs

# Permit root login via SSH
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Enable password authentication
# RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Setup user with password
# RUN useradd -ms /bin/bash -l -u 1000 pcm && echo "pcm:pcm" | chpasswd
WORKDIR /root

# Give user passwordless sudo access
# COPY pcm /etc/sudoers.d/pcm

COPY machines.txt set-known-hosts.bash jumpbox-install.bash /root/
COPY gitconfig.txt /root/.gitconfig
COPY emacs-config.txt /root/.emacs
# Setup authorized keys
RUN mkdir -p /root/.ssh && chmod 700 /root/.ssh
COPY keys/* /root/.ssh/

# RUN chown -R 1000:1000 /home/pcm/

# Hard code path so that SSH will have alternate paths, like root would have
# RUN echo "export PATH=/usr/local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" >> /home/pcm/.bashrc

# Start SSH server
RUN service ssh start

# SSH port (optional, change if needed)
EXPOSE 22

# Start SSH service
CMD ["/usr/sbin/sshd", "-D"]

# CMD ["sleep", "infinity"]
