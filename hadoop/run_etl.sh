#!/bin/bash -ex

pig -p input_file="/user/root/project/raw/11-23_11-29.csv" -p contribution_week=1 -f ~/workspace/hadoop/etl.pig
