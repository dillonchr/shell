#!/bin/bash

crashreport () {
  pbpaste > ~/Documents/$(date +"%Y-%m-%d_%H-%M").txt
}

