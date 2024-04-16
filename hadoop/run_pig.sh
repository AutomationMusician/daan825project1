#!/bin/bash -ex

filenames=("11-23_11-29.csv" "11-30_12-06.csv" "12-07_12-13.csv" "12-14_12-20.csv" "12-21_12_27.csv")

for i in "${!filenames[@]}"; do 
    week_num=$((i + 1))

    # Clear existing files
    rm -f ~/workspace/hadoop/data/${week_num}.csv
    hadoop fs -rm  -f /user/root/project/output/${week_num}/* 
    hadoop fs -rmdir /user/root/project/output/${week_num} || true

    # Run pig ETL script
    pig -p input_file="/user/root/project/raw/${filenames[$i]}" -p contribution_week=${week_num} -f ~/workspace/hadoop/etl.pig
    
    # Save pig output locally
    hadoop fs -get /user/root/project/output/${week_num}/part-r-00000 ~/workspace/hadoop/data/${week_num}.csv
done