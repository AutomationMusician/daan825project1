DROP TABLE IF EXISTS contribution_fact;

CREATE TABLE contribution_fact (
    contribution_week INT,
    contributor_state VARCHAR(2),
    contributor_employer VARCHAR(50),
    contributor_occupation VARCHAR(50),
    committee VARCHAR(50),
    amount NUMERIC(8,2),
    num_contributions INT
)
ROW FORMAT
DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

DESCRIBE contribution_fact;