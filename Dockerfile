FROM amazonlinux

LABEL version="2.0"
LABEL maintainer="github.com/pdreeves"
LABEL description="A container I use for development work."

# Install base applications 
RUN amazon-linux-extras install epel  && \
  yum update -y && \
  yum install python3 screen certbot jq openssh-clients sshpass telnet nc unzip zsh git openssh-server -y && \
  yum clean all && \
  rm -rf /var/cache/yum && \
  mkdir /root/.ssh && \
  echo "ServerAliveInterval 60" >> /root/.ssh/config && \
  git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh && \
  cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc && \ 
  sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd && \
  sed 's/#Port 22/Port 3222/' -i /etc/ssh/sshd_config && \ 
  /usr/bin/ssh-keygen -A


RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
  python get-pip.py && \
  pip3 install awscli ansible boto3 --upgrade

WORKDIR /root
RUN curl -o op_linux_amd64_v0.5.5.zip https://cache.agilebits.com/dist/1P/op/pkg/v0.5.5/op_linux_amd64_v0.5.5.zip && \
	unzip op_linux_amd64_v0.5.5.zip && \
	mv op /usr/local/bin && \
	rm op*

EXPOSE 3222

# Volume for external code
VOLUME /opt/code

# Volume for ssh configs
VOLUME /root/.ssh

CMD /usr/sbin/sshd -D