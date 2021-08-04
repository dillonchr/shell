#!/bin/bash

ip () {
  curl -s "http://ip-api.com/json/${1}?fields=country,regionName,city,timezone,zip,isp,org" | python -m json.tool
}

