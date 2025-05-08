-- Getting data about murder on Jan. 15, 2018 in SQL City
SELECT * 
FROM crime_scene_report
WHERE type = 'murder' 
AND city = 'SQL City'
AND date = 20180115;

/*Output:

date	type	description	city
20180115	murder	Security footage shows that there were 2 witnesses. The first witness lives at the last house on "Northwestern Dr". The second witness, named Annabel, lives somewhere on "Franklin Ave".	SQL City
*/

--Finding out who is first witness

SELECT *
FROM person
WHERE address_street_name = "Northwestern Dr"
ORDER BY address_number desc
LIMIT 1;

/*  OUTPUT:
id	name	license_id	address_number	address_street_name	ssn
14887	Morty Schapiro	118009	4919	Northwestern Dr	111564949
*/

-- Finding out who is second witness
SELECT *
FROM person
WHERE address_street_name = "Franklin Ave"
AND name LIKE "%Annabel%";

/*OUTPUT:
id	name	license_id	address_number	address_street_name	ssn
16371	Annabel Miller	490173	103	Franklin Ave	318771143
*/

--Looking into interview of first witness

SELECT *
FROM interview
WHERE person_id = 14887;

/*OUTPUT:

person_id	transcript
14887	I heard a gunshot and then saw a man run out. He had a "Get Fit Now Gym" bag. The membership number on the bag started with "48Z". Only gold members have those bags. The man got into a car with a plate that included "H42W".

*/

--Looking into interview of second witness
SELECT *
FROM interview
WHERE person_id = 16371;

/* OUTPUT:
person_id	transcript
16371	I saw the murder happen, and I recognized the killer from my gym when I was working out last week on January the 9th.
*/


--Look into man with membership number on bag that started with "48Z"
SELECT *
FROM get_fit_now_member
WHERE id LIKE "48Z%";

/* OUTPUT:
id	person_id	name	membership_start_date	membership_status
48Z38	49550	Tomas Baisley	20170203	silver
48Z7A	28819	Joe Germuska	20160305	gold
48Z55	67318	Jeremy Bowers	20160101	gold
*/

--Look into car with plate that included "H42W"
SELECT *
FROM drivers_license
LEFT JOIN person ON drivers_license.id = person.license_id
WHERE plate_number LIKE "%H42W%";

/* OUTPUT:
id	age	height	eye_color	hair_color	gender	plate_number	car_make	car_model	id	name	license_id	address_number	address_street_name	ssn
183779	21	65	blue	blonde	female	H42W0X	Toyota	Prius	78193	Maxine Whitely	183779	110	Fisk Rd	137882671
423327	30	70	brown	brown	male	0H42W2	Chevrolet	Spark LS	67318	Jeremy Bowers	423327	530	Washington Pl, Apt 3A	871539279
664760	21	71	black	black	male	4H42WR	Nissan	Altima	51739	Tushar Chandra	664760	312	Phi St	137882671

*/

--Jeremy Bowers fits for both the gym membership id and license plate from witness 1.

--Looking into information from witness 2.  What to see who was at gym on Jan. 9
SELECT *
FROM get_fit_now_check_in
INNER JOIN get_fit_now_member
ON get_fit_now_check_in.membership_id = get_fit_now_member.id
WHERE check_in_date = 20180109;

/* OUTPUT:

membership_id	check_in_date	check_in_time	check_out_time	id	person_id	name	membership_start_date	membership_status
X0643	20180109	957	1164	X0643	15247	Shondra Ledlow	20170521	silver
UK1F2	20180109	344	518	UK1F2	28073	Zackary Cabotage	20170818	silver
XTE42	20180109	486	1124	XTE42	55662	Sarita Bartosh	20170524	gold
1AE2H	20180109	461	944	1AE2H	10815	Adriane Pelligra	20170816	silver
6LSTG	20180109	399	515	6LSTG	83186	Burton Grippe	20170214	gold
7MWHJ	20180109	273	885	7MWHJ	31523	Blossom Crescenzo	20180309	regular
GE5Q8	20180109	367	959	GE5Q8	92736	Carmen Dimick	20170618	gold
48Z7A	20180109	1600	1730	48Z7A	28819	Joe Germuska	20160305	gold
48Z55	20180109	1530	1700	48Z55	67318	Jeremy Bowers	20160101	gold
90081	20180109	1600	1700	90081	16371	Annabel Miller	20160208	gold

*/

-- Jeremy Bowers also fits for this.  Is there at same time as witness 2.

INSERT INTO solution VALUES (1, 'Jeremy Bowers');
        
        SELECT value FROM solution;

/* Output:

Congrats, you found the murderer! But wait, there's more... If you think you're up for a challenge, try querying the interview transcript of the murderer to find the real villain behind this crime. If you feel especially confident in your SQL skills, try to complete this final step with no more than 2 queries. Use this same INSERT statement with your new suspect to check your answer.
*/

--Look at Jeremy Bowers transcript

SELECT transcript
FROM interview
INNER JOIN person 
ON interview.person_id = person.id
WHERE person.name = 'Jeremy Bowers';

/* OUTPUT:
I was hired by a woman with a lot of money. I don't know her name but I know she's around 5'5" (65") or 5'7" (67"). She has red hair and she drives a Tesla Model S. I know that she attended the SQL Symphony Concert 3 times in December 2017.
*/

SELECT person.name
FROM person
LEFT JOIN drivers_license
ON person.license_id = drivers_license.id
LEFT JOIN facebook_event_checkin
ON person.id = facebook_event_checkin.person_id
WHERE hair_color = 'red' AND car_model = 'Model S'
AND height BETWEEN 65 AND 67
GROUP BY name
HAVING count(event_name = 'SQL Symphony Concert') = 3;

/* OUTPUT:
Miranda Priestly
*/

--Check solution
INSERT INTO solution VALUES (1, 'Miranda Priestly');
        
        SELECT value FROM solution;

/* OUTPUT:
Congrats, you found the brains behind the murder! Everyone in SQL City hails you as the greatest SQL detective of all time. Time to break out the champagne!
*/

--Finished!
