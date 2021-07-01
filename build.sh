#!/bin/bash

find . -name '*.DS_Store' -type f -delete

if [ -d "~/data/db" ]; then
  find ~/data/db -name '*.DS_Store' -type f -delete
fi
