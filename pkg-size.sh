#!/bin/bash

pkgSize () {
  curl -s "https://packagephobia.com/v2/api.json?p=${1}" | jq
}
