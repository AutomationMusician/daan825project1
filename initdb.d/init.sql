\c postgres

DROP DATABASE IF EXISTS warehouse;

CREATE DATABASE warehouse;

\c warehouse;

-- contributor_employer
CREATE TABLE contributor_employer (
    id serial,
    "name" VARCHAR(50) UNIQUE,
    CONSTRAINT contributor_employer_pk PRIMARY KEY (id)
);
CREATE INDEX contributor_employer_name_idx ON contributor_employer("name");

-- contributor_occupation
CREATE TABLE contributor_occupation (
    id serial,
    "name" VARCHAR(50) UNIQUE,
    CONSTRAINT contributor_occupation_pk PRIMARY KEY (id)
);
CREATE INDEX contributor_occupation_name_idx ON contributor_occupation("name");

-- contributor_state
CREATE TABLE contributor_state (
    id serial,
    "name" VARCHAR(50) UNIQUE,
    CONSTRAINT contributor_state_pk PRIMARY KEY (id)
);
CREATE INDEX contributor_state_name_idx ON contributor_state("name");

-- committee
CREATE TABLE committee (
    id serial,
    "name" VARCHAR(50) UNIQUE,
    party CHAR(1), -- 'D' or 'R'
    CONSTRAINT committee_pk PRIMARY KEY (id)
);
CREATE INDEX committee_name_idx ON committee("name");
CREATE INDEX committee_party_idx ON committee(party);

-- fact table
CREATE TABLE contribution_fact (
    id serial,
    contribution_week INT,
    contributor_state_id INT,
    contributor_zip INT,
    contributor_employer_id INT,
    contributor_occupation_id INT,
    committee_id INT,
    amount NUMERIC(8,2),
    num_contributions INT,
    CONSTRAINT contribution_fact_pk PRIMARY KEY(id),
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
            REFERENCES committee(id)
);
CREATE INDEX contribution_fact_committee_id_idx ON contribution_fact(committee_id);
CREATE INDEX contribution_fact_contributor_state_id_idx ON contribution_fact(contributor_state_id);
CREATE INDEX contribution_fact_contributor_zip_idx ON contribution_fact(contributor_zip);
CREATE INDEX contribution_fact_contributor_employer_id_idx ON contribution_fact(contributor_employer_id);
CREATE INDEX contribution_fact_contributor_occupation_id_idx ON contribution_fact(contributor_occupation_id);
CREATE INDEX contribution_fact_contribution_week_idx ON contribution_fact(contribution_week);