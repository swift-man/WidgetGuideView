#!/usr/bin/env bash

set -euo pipefail

SUPPORT_ARTICLE_ID="${SUPPORT_ARTICLE_ID:-118610}"
CURL_CONNECT_TIMEOUT="${CURL_CONNECT_TIMEOUT:-10}"
CURL_MAX_TIME="${CURL_MAX_TIME:-30}"

developer_urls=(
  "https://developer.apple.com/documentation/widgetkit/widgetfamily/systemsmall"
  "https://developer.apple.com/documentation/widgetkit/widgetfamily/systemmedium"
  "https://developer.apple.com/documentation/widgetkit/widgetfamily/systemlarge"
  "https://developer.apple.com/documentation/widgetkit/widgetfamily/accessorycircular"
  "https://developer.apple.com/documentation/widgetkit/widgetfamily/accessoryrectangular"
)

support_locales=(
  "ar-ae" "ar-bh" "ar-eg" "ar-jo" "ar-kw" "ar-om" "ar-qa" "ar-sa"
  "cs-cz"
  "da-dk"
  "de-at" "de-ch" "de-de" "de-li" "de-lu"
  "el-cy" "el-gr"
  "en-ae" "en-al" "en-am" "en-au" "en-az" "en-bh" "en-bn" "en-bw"
  "en-by" "en-ca" "en-eg" "en-gb" "en-ge" "en-gu" "en-gw" "en-hk"
  "en-ie" "en-il" "en-in" "en-is" "en-jo" "en-ke" "en-kg" "en-kw"
  "en-kz" "en-lb" "en-lk" "en-md" "en-me" "en-mk" "en-mn" "en-mo"
  "en-mt" "en-my" "en-mz" "en-ng" "en-nz" "en-om" "en-ph" "en-qa"
  "en-sa" "en-sg" "en-tj" "en-tm" "en-ug" "en-us" "en-uz" "en-vn"
  "en-za"
  "es-cl" "es-co" "es-es" "es-mx" "es-us"
  "fi-fi"
  "fr-be" "fr-ca" "fr-cf" "fr-ch" "fr-ci" "fr-cm" "fr-fr" "fr-gn"
  "fr-gq" "fr-lu" "fr-ma" "fr-mg" "fr-ml" "fr-mu" "fr-ne" "fr-sn"
  "fr-tn"
  "he-il"
  "hr-hr"
  "hu-hu"
  "id-id"
  "it-it"
  "ja-jp"
  "ko-kr"
  "nl-be" "nl-nl"
  "no-no"
  "pl-pl"
  "pt-br" "pt-pt"
  "ro-md" "ro-ro"
  "ru-ru"
  "sk-sk"
  "sv-se"
  "th-th"
  "tr-tr"
  "uk-ua"
  "vi-vn"
  "zh-cn" "zh-hk" "zh-mo" "zh-tw"
)

checked_count=0
failure_count=0

validate_url() {
  local url="$1"
  local expected_effective_url="${2:-}"
  local response
  local http_code
  local effective_url

  checked_count=$((checked_count + 1))

  if ! response="$(
    curl \
      --location \
      --silent \
      --show-error \
      --output /dev/null \
      --write-out "%{http_code} %{url_effective}" \
      --retry 2 \
      --retry-delay 1 \
      --connect-timeout "$CURL_CONNECT_TIMEOUT" \
      --max-time "$CURL_MAX_TIME" \
      "$url"
  )"; then
    echo "::error::Request failed: $url"
    failure_count=$((failure_count + 1))
    return
  fi

  http_code="${response%% *}"
  effective_url="${response#* }"

  if [[ ! "$http_code" =~ ^[23][0-9][0-9]$ ]]; then
    echo "::error::Unexpected HTTP status $http_code for $url"
    failure_count=$((failure_count + 1))
    return
  fi

  if [[ -n "$expected_effective_url" && "$effective_url" != "$expected_effective_url" ]]; then
    echo "::error::Unexpected redirect for $url"
    echo "Expected: $expected_effective_url"
    echo "Actual:   $effective_url"
    failure_count=$((failure_count + 1))
    return
  fi

  echo "OK $http_code $url"
}

for url in "${developer_urls[@]}"; do
  validate_url "$url"
done

for locale in "${support_locales[@]}"; do
  url="https://support.apple.com/$locale/$SUPPORT_ARTICLE_ID"
  validate_url "$url" "$url"
done

if (( failure_count > 0 )); then
  echo "::error::$failure_count of $checked_count official URLs failed validation"
  exit 1
fi

echo "Validated $checked_count official URLs."
