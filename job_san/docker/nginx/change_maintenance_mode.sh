#!/bin/bash

LOCK_FILE_DIR="/var/tmp/nginx"
LOCK_FILE_NAME="maintenance"

LOCK_FILE="${LOCK_FILE_DIR}/${LOCK_FILE_NAME}"
function StartMaintenance() {
  if [ -f ${LOCK_FILE} ]; then
  echo "すでにメンテナンスモードです"
  exit 1
else
  touch ${LOCK_FILE}
  if [ $? = 0 ]; then
    echo "メンテナンスモードスタート"
    exit 0
  else
    echo "ファイル作成が異常終了"
    exit 1
  fi
fi
}

function StopMaintenance() {
  if [ -f ${LOCK_FILE} ]; then
    rm -rf ${LOCK_FILE}
    if [ $? = 0 ]; then
      echo "メンテナンスモードフィニッシュ"
      exit 0
    else
      echo "ファイル削除が異常終了"
      exit 1
    fi
  else
    echo "すでにメンテナンスモードではありません。"
    exit 1
  fi
}

echo "Run change_maintenance_mode.sh $@"
if [ $@ = "start" ]; then
  StartMaintenance
elif [ $@ = 'stop' ] ; then
  StopMaintenance
else
  echo "引数がちゃうねんドァフォ！ちゃんとしてな、ワイは何もせえへんからな。😤"
  exit 1
fi
