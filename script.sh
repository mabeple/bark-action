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

request_body=""
[[ -n "$INPUT_TITLE" ]] && request_body+="title=${INPUT_TITLE}&"
[[ -n "$INPUT_SUBTITLE" ]] && request_body+="subtitle=${INPUT_SUBTITLE}&"
[[ -n "$INPUT_BODY" ]] && request_body+="body=${INPUT_BODY}&"
[[ -n "$INPUT_LEVEL" ]] && request_body+="level=${INPUT_LEVEL}&"
[[ -n "$INPUT_BADGE" ]] && request_body+="badge=${INPUT_BADGE}&"
[[ -n "$INPUT_AUTOCOPY" ]] && request_body+="autoCopy=${INPUT_AUTOCOPY}&"
[[ -n "$INPUT_COPY" ]] && request_body+="copy=${INPUT_COPY}&"
[[ -n "$INPUT_SOUND" ]] && request_body+="sound=${INPUT_SOUND}&"
[[ -n "$INPUT_CALL" ]] && request_body+="call=${INPUT_CALL}&"
[[ -n "$INPUT_ICON" ]] && request_body+="icon=${INPUT_ICON}&"
[[ -n "$INPUT_GROUP" ]] && request_body+="group=${INPUT_GROUP}&"
[[ -n "$INPUT_CIPHERTEXT" ]] && request_body+="ciphertext=${INPUT_CIPHERTEXT}&"
[[ -n "$INPUT_VOLUME" ]] && request_body+="volume=${INPUT_VOLUME}&"
[[ -n "$INPUT_ISARCHIVE" ]] && request_body+="isArchive=${INPUT_ISARCHIVE}&"
[[ -n "$INPUT_URL" ]] && request_body+="url=${INPUT_URL}"

request_body=${request_body%&}

echo -e "${cyan}Request url${none}: ${request_url}"
echo -e "${cyan}Request body${none}:\n${request_body//&/\\n}"

request_auth=""
if [[ -n "$INPUT_AUTH" ]]; then
  request_auth="Authorization: Basic ${INPUT_AUTH}"
fi

http_code=$(curl -s -o /dev/null -w "%{http_code}" \
  -X POST \
  ${request_auth:+-H "$request_auth"} \
  -d "$request_body" \
  "${request_url}")

if [[ $http_code == 200 ]]; then
  echo -e "${green}Notification sent successfully${none}"
else
  echo -e "${red}Request error! The HTTP code is ${http_code}${none}" >&2
  exit 1
fi