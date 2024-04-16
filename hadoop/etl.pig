DEFINE CSVLoader org.apache.pig.piggybank.storage.CSVLoader();

-- load data as it appears in the CSV
contributions = LOAD '$input_file' USING CSVLoader(',') AS (committee_id:chararray, committee_name:chararray, report_year:chararray, report_type:chararray, image_number:chararray, line_number:chararray, transaction_id:chararray, file_number:chararray, contributor_committee_name:chararray, entity_type:chararray, entity_type_desc:chararray, unused_contbr_id:chararray, contributor_prefix:chararray, contributor_name:chararray, recipient_committee_type:chararray, recipient_committee_org_type:chararray, recipient_committee_designation:chararray, contributor_first_name:chararray, contributor_middle_name:chararray, contributor_last_name:chararray, contributor_suffix:chararray, contributor_street_1:chararray, contributor_street_2:chararray, contributor_city:chararray, contributor_state:chararray, contributor_zip:chararray, contributor_employer:chararray, contributor_occupation:chararray, contributor_id:chararray, receipt_type:chararray, receipt_type_desc:chararray, receipt_type_full:chararray, memo_code:chararray, memo_code_full:chararray, contribution_receipt_date:chararray, contribution_receipt_amount:double, contributor_aggregate_ytd:chararray, candidate_id:chararray, candidate_name:chararray, candidate_first_name:chararray, candidate_last_name:chararray, candidate_middle_name:chararray, candidate_prefix:chararray, candidate_suffix:chararray, candidate_office:chararray, candidate_office_full:chararray, candidate_office_state:chararray, candidate_office_state_full:chararray, candidate_office_district:chararray, conduit_committee_id:chararray, conduit_committee_name:chararray, conduit_committee_street1:chararray, conduit_committee_street2:chararray, conduit_committee_city:chararray, conduit_committee_state:chararray, conduit_committee_zip:chararray, donor_committee_name:chararray, national_committee_nonfederal_account:chararray, election_type:chararray, election_type_full:chararray, fec_election_type_desc:chararray, fec_election_year:chararray, amendment_indicator:chararray, amendment_indicator_desc:chararray, schedule_type_full:chararray, load_date:chararray, original_sub_id:chararray, back_reference_transaction_id:chararray, back_reference_schedule_name:chararray, filing_form:chararray, link_id:chararray, is_individual:chararray, memo_text:chararray, two_year_transaction_period:chararray, schedule_type:chararray, increased_limit:chararray, sub_id:chararray, pdf_url:chararray, line_number_label);

-- remove header
ranked_contributions = rank contributions;
contributions = FILTER ranked_contributions by $0>1;

-- filter out data we don't need and append contribution_week
contributions = foreach contributions generate committee_name, contributor_state, contributor_employer, contributor_occupation, contribution_receipt_amount, $contribution_week as contribution_week;

-- remove commas from fields so that it can be read as a comma-delimited document
contributions = foreach contributions generate REPLACE(committee_name,',','') as committee_name, REPLACE(contributor_state,',','') as contributor_state, REPLACE(contributor_employer,',','') as contributor_employer, REPLACE(contributor_occupation,',','') as contributor_occupation, contribution_receipt_amount, contribution_week;

-- filter out rows with missing values
contributions = FILTER contributions BY committee_name != '';
contributions = FILTER contributions BY contributor_state != '';
contributions = FILTER contributions BY contributor_employer != '';
contributions = FILTER contributions BY contributor_occupation != '';

-- aggregate by grouping fields and summing amounts
grouped_contributions = GROUP contributions BY (committee_name, contributor_state, contributor_employer, contributor_occupation, contribution_week);
aggregated_contributions = FOREACH grouped_contributions GENERATE group, SUM(contributions.contribution_receipt_amount) as amount, COUNT(contributions.contribution_receipt_amount) as num_contributions;

-- convert to proper format before storing
table_format = FOREACH aggregated_contributions GENERATE group.contribution_week as contribution_week, group.contributor_state as contributor_state, group.contributor_employer as contributor_employer, group.contributor_occupation as contributor_occupation, group.committee_name as committee, amount, num_contributions;

-- store data
STORE table_format INTO '/user/root/project/output/$contribution_week' USING PigStorage (',');

