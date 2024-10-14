#!/bin/bash
cp ./nohup.out ~/buckets/b1/flow/`cat nohup.out | grep "exp_wf_init()" | awk '{print $NF}'`

