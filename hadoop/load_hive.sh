#!/bin/bash -ex

# create bl alias
shopt -s expand_aliases
alias bl='beeline -u jdbc:hive2://localhost:10000 -n root'

# load schema
bl -f ~/workspace/hadoop/schema.hql

# load data
for file in ~/workspace/hadoop/data/*; do
    bl -e "load data local inpath '$file' into table contribution_fact;"
done;

# output the number of lines in the contribution_fact table
bl -e "select count(*) from contribution_fact;"
