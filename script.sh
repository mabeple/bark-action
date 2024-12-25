#!/bin/bash

red='\e[91m'
green='\e[92m'
cyan='\e[96m'
none='\e[0m'

if [[ -z $INPUT_KEY ]]; then
  echo -e "${red}ERROR: the KEY field is required${none}" >&2
  exit 1
fi

if [[ -n $INPUT_HOST ]]; then
  host="$INPUT_HOST"
  echo -e "${cyan}Use custom Bark server hostname${none}: ${host}"
else
  host="https://api.day.app"
fi

request_url="${host}/${INPUT_KEY}/"

# 创建 JSON 格式的请求体
request_body=$(cat <<EOF
{
  "title": "${INPUT_TITLE}",
  "subtitle": "${INPUT_SUBTITLE}",
  "body": "${INPUT_BODY}",
  "level": "${INPUT_LEVEL}",
  "badge": "${INPUT_BADGE}",
  "autoCopy": "${INPUT_AUTOCOPY}",
  "copy": "${INPUT_COPY}",
  "sound": "${INPUT_SOUND}",
  "call": "${INPUT_CALL}",
  "icon": "${INPUT_ICON}",
  "group": "${INPUT_GROUP}",
  "ciphertext": "${INPUT_CIPHERTEXT}",
  "volume": "${INPUT_VOLUME}",
  "isArchive": "${INPUT_ISARCHIVE}",
  "url": "${INPUT_URL}"
}
EOF
)

echo -e "${cyan}Request url${none}: ${request_url}"
echo -e "${cyan}Request body${none}:\n${request_body//&/\\n}"

# 发送请求
http_code=$(curl -s -o /dev/null -w "%{http_code}" \
  -X POST \
  -H "Content-Type: application/json; charset=utf-8" \
  -d "$request_body" \
  "${request_url}")

if [[ $http_code == 200 ]]; then
  echo -e "${green}Notification sent successfully${none}"
else
  echo -e "${red}Request error! The HTTP code is ${http_code}${none}" >&2
  exit 1
fi
