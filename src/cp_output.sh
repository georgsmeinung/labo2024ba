#!/bin/bash
OUTPUTDIR=$(cat nohup.out | grep "exp_wf_init()" | awk '{print $NF}')
TARGET="$HOME/buckets/b1/flow/${OUTPUTDIR}/"
echo "Copying file to $TARGET"
cp ./nohup.out "$TARGET"
