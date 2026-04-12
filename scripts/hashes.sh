#!/bin/bash

awk '{print "  [" $1 "]=\"" $2 "\""}' data.txt
