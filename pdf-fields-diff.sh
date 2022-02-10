#!/bin/bash

diffforms () {
  pdffields "$1" > /tmp/a.txt
  pdffields "$2" > /tmp/b.txt
  git diff -b /tmp/a.txt /tmp/b.txt
}
