#!/bin/bash

function ConfirmExecution() {

  echo "----------------------------"
  echo "メンテナンスモードを切り替えます"
  echo "スタートする場合は start、ストップする場合は stop と入力して下さい"
  read input

  input=`echo $input | tr A-Z a-z`

  if [ -z $input ] ; then
    echo "  start または stop を入力して下さい"
    ConfirmExecution
  elif [ $input = 'start' ] ; then
    echo "  メンテナンスモードを開始します"
    RunChangeMaintenanceMode start
    exit 0
  elif [ $input = 'stop' ]; then
    echo "  メンテナンスモードを終了します"
    RunChangeMaintenanceMode stop
    exit 0
  else
    echo "  start または stop を入力して下さい"
    ConfirmExecution
  fi
}

function RunChangeMaintenanceMode() {
  MAINTENANCE_SHELL_FILE_NAME="change_maintenance_mode.sh"

  if [ $1 != "start" ] && [ $1 != "stop" ]; then
    echo "$1 ってなに？君新人？使い方知らないの？😇"
    exit 1
  fi

  docker exec ${CONTAINER_ID} /bin/sh -c "./$MAINTENANCE_SHELL_FILE_NAME $1"
  if [ $? != 0 ]; then
    echo "シェルが実行できない？管理者に問い合わせてください。"
    exit 1
  fi
  echo "Maintenance mode changed to $1"
  exit 0
}

#
# ---------------- FROM HERE ----------------
#
CONTAINER_ID=`docker ps -f "name=job_san_nginx" -q`
echo "CONTAINER_ID: ${CONTAINER_ID}"
if [ $? = 1 ]; then
  echo "コンテナがない？管理者に問い合わせてください。"
  exit 1
fi

ConfirmExecution
