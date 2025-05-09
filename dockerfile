FROM alpine:3.18

ENV USER=webminal
ENV HOME=/home/$USER
ENV GROUPNAME=$USER
ENV UID=1337
ENV GID=31337
ENV TINI_KILL_PROCESS_GROUP=1
RUN apk update && apk add --no-cache tini ttyd tmux openrc bash socat  && \
    echo "export PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '" >> /etc/profile && \
    echo "alias poweroff='kill 1'" >> /etc/profile

COPY create-tmux-sessions.sh .
RUN chmod +x create-tmux-sessions.sh
RUN addgroup \
    --gid "$GID" \
    "$GROUPNAME" \
&&  adduser \
    --disabled-password \
    --gecos "" \
    --home "/home/$USER" \
    --ingroup "$GROUPNAME" \
    --uid "$UID" \
    --shell "/bin/bash" \
    $USER

COPY test.pcap /home/$USER
RUN chown $USER:$GROUPNAME /home/$USER/test.pcap
EXPOSE 8080 
ENTRYPOINT ["/sbin/tini", "--"]
COPY tmux-session-handler.sh /tmux-session-handler
RUN chmod u+x /tmux-session-handler
RUN mkdir /etc/cron/
RUN echo "*/1 * * * * bash /tmux-session-handler" > /etc/cron/crontab
RUN echo "# End of file line" >> /etc/cron/crontab
RUN crontab /etc/cron/crontab
CMD [ "/bin/bash", "-c", "set -x && crond -l 8 -f & ttyd -u 1337 -g 31337 -w /home/webminal/ -p 8080 -m 30 -s 3 -t closeOnDisconnect=true -t titleFixed=Webminal -t rendererType=webgl -t disableLeaveAlert=true bash /create-tmux-sessions.sh" ]
