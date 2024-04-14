#!/bin/bash -ex

hadoop fs -mkdir /user
hadoop fs -mkdir /user/root
hadoop fs -mkdir /user/root/project
hadoop fs -mkdir /user/root/project/raw/

hadoop fs -put /root/workspace-parent/11-23_11-29.csv /user/root/project/raw/11-23_11-29.csv
hadoop fs -put /root/workspace-parent/11-30_12-06.csv /user/root/project/raw/11-30_12-06.csv
hadoop fs -put /root/workspace-parent/12-07_12-13.csv /user/root/project/raw/12-07_12-13.csv
hadoop fs -put /root/workspace-parent/12-14_12-20.csv /user/root/project/raw/12-14_12-20.csv
hadoop fs -put /root/workspace-parent/12-21_12_27.csv /user/root/project/raw/12-21_12_27.csv

hadoop fs -ls /user/root/project/raw
