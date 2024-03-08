SELECT 
    contribution_fact.amount, contribution_fact.num_contributions, contribution_fact.contributor_zip, contribution_fact.contribution_week,
    contributor_employer.name as employer,
    contributor_occupation.name as occupation,
    contributor_state.name as "state",
    committee.name as committee, committee.party as party
FROM contribution_fact

JOIN contributor_employer
ON contribution_fact.contributor_employer_id=contributor_employer.id

JOIN contributor_occupation
ON contribution_fact.contributor_occupation_id=contributor_occupation.id

JOIN contributor_state
ON contribution_fact.contributor_state_id=contributor_state.id

JOIN committee
ON contribution_fact.committee_id=committee.id

ORDER BY contribution_fact.num_contributions DESC

LIMIT 1;
