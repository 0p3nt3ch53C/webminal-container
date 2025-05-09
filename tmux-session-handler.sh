#!/bin/sh

IDLE_REMOVAL=2
TIME_REMOVAL=8

TIMESTAMP=$(date '+%Y/%m/%d %H:%M:%S:0000')
NOW=$(($(date +%s)))

SESSIONS=$(su -c 'tmux ls -F "#{session_name} #{session_activity} #{session_created}"' webminal 2>&1 )

echo "$SESSIONS" | while read -r LINE; do
  if [[ "$SESSIONS" == "no server running on /tmp/tmux-1337/default" ]]; then 
    echo "[${TIMESTAMP}] tmux-session-handler: INFO - No clients connected."
    break
  fi 
  if [[ "$SESSIONS" == "error connecting to /tmp/tmux-1337/default (No such file or directory)" ]]; then 
    echo "[${TIMESTAMP}] tmux-session-handler: INFO - Webminal sessions not started. No clients connected."
    break
  fi
  SESSION_NAME=$(echo $LINE | awk '{print $1}')
  LAST_ACTIVITY=$(echo $LINE | awk '{print $2}')
  CREATED_AT=$(echo $LINE | awk '{print $3}')
  CREATED_AT_DELTA=$(((NOW - CREATED_AT) / 60 ))
  LAST_ACTIVITY_MINS_ELAPSED=$(((NOW - LAST_ACTIVITY) / 60))
  # # print all sessions
  echo "[${TIMESTAMP}] tmux-session-handler: INFO - tmux session ${SESSION_NAME} has been idle for ${LAST_ACTIVITY_MINS_ELAPSED}min, and was started ${CREATED_AT_DELTA}min ago."

  # Remove inactive sessions
  if [[ "$LAST_ACTIVITY_MINS_ELAPSED" -gt "$IDLE_REMOVAL" ]]; then
    echo "[${TIMESTAMP}] tmux-session-handler: WARNING - Killing tmux session $SESSION_NAME (Inactive for ${LAST_ACTIVITY_MINS_ELAPSED}min)"
    su -c "tmux kill-session -t ${SESSION_NAME}" webminal
    echo "[${TIMESTAMP}] tmux-session-handler: INFO - Killed tmux session ${SESSION_NAME} since it has been inactive for ${LAST_ACTIVITY_MINS_ELAPSED}min which past the idle threshold ${IDLE_REMOVAL}min."
    break
  fi

  # Remove sessions after set duration
  if [[ "$CREATED_AT_DELTA" -gt "$TIME_REMOVAL" ]]; then
    echo "[${TIMESTAMP}] tmux-session-handler: WARNING - Killed tmux session $SESSION_NAME (created ${CREATED_AT_DELTA}min ago)" 
    su -c "tmux kill-session -t ${SESSION_NAME}" webminal
    echo "[${TIMESTAMP}] tmux-session-handler: INFO - Killed tmux session ${SESSION_NAME} that was created ${CREATED_AT_DELTA}min ago, since it is older than session time threshold ${TIME_REMOVAL}min."
    break
  fi
done
