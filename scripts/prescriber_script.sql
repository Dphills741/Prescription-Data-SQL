--Question 1 
select sum(p.total_claim_count), p2.npi
from prescription as p
left join prescriber as p2
on p.npi = p2.npi
group by p2.npi,p.total_claim_count
order by p.total_claim_count desc


--Question 1(extended)
select sum(p.total_claim_count) as total_claims, p2.npi, p2.nppes_provider_first_name, p2.nppes_provider_last_org_name,p2.specialty_description
from prescription as p
inner join prescriber as p2
on p.npi = p2.npi
group by p2.npi,p.total_claim_count,p2.nppes_provider_first_name,p2.nppes_provider_last_org_name,p2.specialty_description
order by total_claims desc

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
select d.generic_name, round(sum(total_drug_cost)/sum(total_daily_supply) as daily_cost
from prescription as p
left join drug as d
on p.drug_name = d.drug_name
group by d.generic_name
order by daily_cost desc
 
--Question 4 A
select drug_name, 
case 
when opioid_drug_flag = 'Y' then 'opioid'
when antibiotic_drug_flag = 'Y' then 'antibiotic'
else 'neither'
end as drug_type
from drug 



--Question 4 B not correct
select d.drug_name, sum(p.total_drug_cost) as money, 
(case when opioid_drug_flag = 'Y' then 'opioid' end) as opioids,
(case when antibiotic_drug_flag = 'Y' then 'antibiotics' end) as antibiotics
from drug as d
left join prescription as p
on d.drug_name = p.drug_name
group by opioids,d.drug_name,antibiotic_drug_flag


--question 5 a
-- 10
select count(distinct cbsaname)
from cbsa
where cbsaname like '%TN%'

--question 5b
--memphis has highest poulation at 937847
--Nashville davidson has 8773
select sum(p.population) as total_pop, c.cbsaname, c.cbsa
from cbsa as c
inner join population as p
on c.fipscounty = p.fipscounty
where p.population is not null
group by p.population, c.cbsaname, c.cbsa
order by p.population --desc

--question 5c --dunno
select p.population, c.cbsaname, p.fipscounty, f.county, c.cbsa
from cbsa as c
left join population as p
on c.fipscounty = p.fipscounty
left join fips_county as f
on c.fipscounty = f.fipscounty
where p.population is not null 
group by p.population, c.cbsaname, p.fipscounty, f.county, c.cbsa
order by p.population desc

--question 6a
select total_claim_count, drug_name
from prescription
where total_claim_count >= 3000

--queston 6b
select p.total_claim_count, d.drug_name,
case 
when opioid_drug_flag = 'Y' then 'opioid'
else 'not opioid' 
end as opioid
from prescription as p
left join drug as d
on p.drug_name = d.drug_name
where total_claim_count >= 3000 

--question 6c
select p.total_claim_count, d.drug_name, p2.nppes_provider_first_name, p2.nppes_provider_last_org_name,
case 
when opioid_drug_flag = 'Y' then 'opioid'
else 'not opioid' 
end as opioid
from prescription as p
left join drug as d
on p.drug_name = d.drug_name
left join prescriber as p2
on p.npi = p2.npi
where total_claim_count >= 3000 

--question 7a
select p.npi, d.drug_name
from prescriber as p
cross join drug as d
where specialty_description = 'Pain Management' AND nppes_provider_city = 'NASHVILLE' and opioid_drug_flag = 'Y'

--question 7b
select p.npi, d.drug_name, coalesce(total_claim_count,0) as claims
from prescriber as p
cross join drug as d
cross join prescription as p2
where specialty_description = 'Pain Management' AND nppes_provider_city = 'NASHVILLE' and opioid_drug_flag = 'Y'
group by p.npi,d.drug_name,total_claim_count