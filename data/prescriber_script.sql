--Question 1 
--David has the most total claims at 4538
select p.total_claim_count, p2.npi
from prescription as p
left join prescriber as p2
on p.npi = p2.npi
order by p.total_claim_count desc

--Question 1(extended)
select p.total_claim_count, p2.npi, p2.nppes_provider_first_name, p2.nppes_provider_last_org_name,p2.specialty_description
from prescription as p
left join prescriber as p2
on p.npi = p2.npi
order by p.total_claim_count desc

--Question 2 A
--Family practice has the most claims at 9752347
select sum(p.total_claim_count) as total_claims, p2.specialty_description
from prescription as p
left join prescriber as p2
on p.npi = p2.npi
group by p2.specialty_description
order by total_claims DESC

--Question 2 B
--Nurse practitioner with 900845
select sum(p.total_claim_count) as total_claims, p2.specialty_description, d.opioid_drug_flag
from prescription as p
left join prescriber as p2
on p.npi = p2.npi
left join drug as d
on p.drug_name = d.drug_name
where d.opioid_drug_flag = 'Y'
group by p2.specialty_description, d.opioid_drug_flag
order by total_claims DESC
limit 10

--Question 3 A
-- Insulin was by far the most exp.
select d.generic_name, sum(p.total_drug_cost) as cost
from prescription as p
left join drug as d
on p.drug_name = d.drug_name
group by d.generic_name
order by cost desc

--Question 3 B
--NOT Finished/correct
select d.generic_name, round(sum(p.total_drug_cost)/sum(p.total_claim_count),2) as daily_cost
from prescription as p
left join drug as d
on p.drug_name = d.drug_name
group by d.generic_name, p.total_drug_cost, p.total_claim_count
order by daily_cost desc
 
--Question 4 A
select drug_name,
case 
when opioid_drug_flag = 'Y' then 'opioid'
when antibiotic_drug_flag = 'Y' then 'antibiotic'
else 'neither'
end as drug_type
from drug 
limit 10

--Question 4 B
select drug_name, p.total_drug_cost 
case 
when opioid_drug_flag = 'Y' then 'opioid'
when antibiotic_drug_flag = 'Y' then 'antibiotic'
else 'neither'
end as drug_type
from drug 

limit 10