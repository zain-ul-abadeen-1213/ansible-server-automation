FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Base packages: SSH server (how Ansible connects), Python (how Ansible
# manages the node), sudo (for privilege escalation) and curl (handy checks).
RUN apt-get update && apt-get install -y \
        openssh-server \
        python3 \
        sudo \
        curl \
    && rm -rf /var/lib/apt/lists/*

# Unprivileged user that Ansible logs in as, with passwordless sudo.
RUN useradd -m -s /bin/bash deploy \
    && echo "deploy ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/deploy \
    && chmod 0440 /etc/sudoers.d/deploy

# Inject the control node's public key at build time.
# Place your key in targets/authorized_keys BEFORE building
# (see README: ssh-keygen + cp ~/.ssh/ansible_lab.pub targets/authorized_keys).
RUN mkdir -p /home/deploy/.ssh && chmod 700 /home/deploy/.ssh
COPY authorized_keys /home/deploy/.ssh/authorized_keys
RUN chmod 600 /home/deploy/.ssh/authorized_keys \
    && chown -R deploy:deploy /home/deploy/.ssh

# sshd needs this runtime directory to start.
RUN mkdir -p /var/run/sshd

EXPOSE 22 80

# Run sshd in the foreground so it stays the container's main process.
CMD ["/usr/sbin/sshd", "-D"]
