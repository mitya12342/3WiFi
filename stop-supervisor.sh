#!/bin/bash

printf "READY\n";

while read line; do
  kill -3 1
done < /dev/stdin