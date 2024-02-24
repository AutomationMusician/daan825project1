\c postgres

DROP DATABASE IF EXISTS warehouse;

CREATE DATABASE warehouse;

\c warehouse;

-- contribution_date
CREATE TABLE contribution_date (
    id serial,
    "date" DATE UNIQUE,
    week_num NUMERIC(1),
    CONSTRAINT contribution_date_pk PRIMARY KEY (id)
);
CREATE INDEX contribution_date_idx ON contribution_date("date");
CREATE INDEX contribution_date_week_num_idx ON contribution_date(week_num);

-- contributor_employer
CREATE TABLE contributor_employer (
    id serial,
    "name" VARCHAR(50),
    CONSTRAINT contributor_employer_pk PRIMARY KEY (id)
);
CREATE INDEX contributor_employer_name_idx ON contributor_employer("name");

-- contributor_occupation
CREATE TABLE contributor_occupation (
    id serial,
    "name" VARCHAR(50),
    CONSTRAINT contributor_occupation_pk PRIMARY KEY (id)
);
CREATE INDEX contributor_occupation_name_idx ON contributor_occupation("name");

-- contributor_state
CREATE TABLE contributor_state (
    id serial,
    "name" VARCHAR(50),
    CONSTRAINT contributor_state_pk PRIMARY KEY (id)
);
CREATE INDEX contributor_state_name_idx ON contributor_state("name");

-- committee
CREATE TABLE committee (
    id serial,
    "name" VARCHAR(50),
    party CHAR(1), -- 'D' or 'R'
    CONSTRAINT committee_pk PRIMARY KEY (id)
);
CREATE INDEX committee_name_idx ON committee("name");
CREATE INDEX committee_party_idx ON committee(party);

-- contributor
CREATE TABLE contributor (
    id serial,
    contributor_name VARCHAR(50),
    contributor_street_1 VARCHAR(50),
    contributor_street_2 VARCHAR(50),
    contributor_city VARCHAR(50),
    contributor_state CHAR(2),
    contributor_zip NUMERIC(5),
    CONSTRAINT contributor_pk PRIMARY KEY (id)
);

-- fact table
CREATE TABLE contribution_fact (
    id serial,
    contribution_date_id INT,
    contributor_state_id INT,
    contributor_zip NUMERIC(5),
    contributor_employer_id INT,
    contributor_occupation_id INT,
    committee_id INT,
    contributor_id INT,
    amount NUMERIC(8,2),
    CONSTRAINT contribution_fact_pk PRIMARY KEY(id),
    CONSTRAINT contribution_fact_contribution_date_fk
        FOREIGN KEY(contribution_date_id)
            REFERENCES contribution_date(id),
    CONSTRAINT contribution_fact_contributor_state_fk
        FOREIGN KEY(contributor_state_id)
            REFERENCES contributor_state(id),
    CONSTRAINT contribution_fact_contributor_employer_fk
        FOREIGN KEY(contributor_employer_id)
            REFERENCES contributor_employer(id),
    CONSTRAINT contribution_fact_contributor_occupation_fk
        FOREIGN KEY(contributor_occupation_id)
            REFERENCES contributor_occupation(id),
    CONSTRAINT contribution_fact_committee_fk
        FOREIGN KEY(committee_id)
            REFERENCES committee(id),
    CONSTRAINT contribution_fact_contributor_fk
        FOREIGN KEY(contributor_id)
            REFERENCES contributor(id)
);
CREATE INDEX contribution_fact_committee_id_idx ON contribution_fact(committee_id);
CREATE INDEX contribution_fact_contributor_id_idx ON contribution_fact(contributor_id);
CREATE INDEX contribution_fact_contributor_state_id_idx ON contribution_fact(contributor_state_id);
CREATE INDEX contribution_fact_contributor_zip_idx ON contribution_fact(contributor_zip);
CREATE INDEX contribution_fact_contributor_employer_id_idx ON contribution_fact(contributor_employer_id);
CREATE INDEX contribution_fact_contributor_occupation_id_idx ON contribution_fact(contributor_occupation_id);
CREATE INDEX contribution_fact_contribution_date_id_idx ON contribution_fact(contribution_date_id);