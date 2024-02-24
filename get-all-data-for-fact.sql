SELECT 
    contribution_fact.amount as amount, contribution_fact.contributor_zip as zip, 
    contribution_date.date as "date", contribution_date.week_num as week_num,
    contributor_employer.name as employer,
    contributor_occupation.name as occupation,
    contributor_state.name as "state",
    committee.name as committee, committee.party as party,
    contributor.contributor_name as contributor_name, contributor.contributor_street_1 as contributor_street_1, contributor.contributor_street_2 as contributor_street_2, contributor.contributor_city as contributor_city
FROM contribution_fact

JOIN contribution_date
ON contribution_fact.contribution_date_id=contribution_date.id

JOIN contributor_employer
ON contribution_fact.contributor_employer_id=contributor_employer.id

JOIN contributor_occupation
ON contribution_fact.contributor_occupation_id=contributor_occupation.id

JOIN contributor_state
ON contribution_fact.contributor_state_id=contributor_state.id

JOIN committee
ON contribution_fact.committee_id=committee.id

JOIN contributor
ON contribution_fact.contributor_id = contributor.id

WHERE contribution_fact.id = 1;
