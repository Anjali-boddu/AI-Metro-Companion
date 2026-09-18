use metro_companion;

show tables;

describe stations1;

describe routes1;

describe bookings;

select count(*) as station_count from stations1;
select count(*) as route_count from routes1;

select city,line_name, count(*) as stations from stations1 group by city, line_name order by city,line_name;

USE metro_companion;

CREATE TABLE IF NOT EXISTS metro_systems (
    metro_id INT AUTO_INCREMENT PRIMARY KEY,
    metro_name VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    country VARCHAR(50) DEFAULT 'India'
);

DESCRIBE metro_systems;

INSERT INTO metro_systems
(metro_name, city, state, country)
VALUES
('Bengaluru Metro', 'Bengaluru', 'Karnataka', 'India'),
('Chennai Metro', 'Chennai', 'Tamil Nadu', 'India'),
('Delhi Metro', 'Delhi', 'Delhi', 'India'),
('Hyderabad Metro', 'Hyderabad', 'Telangana', 'India');

SELECT * FROM metro_systems;

USE metro_companion;

CREATE TABLE IF NOT EXISTS stations_india (
    station_id INT AUTO_INCREMENT PRIMARY KEY,
    metro_id INT NOT NULL,
    station_name VARCHAR(150) NOT NULL,
    city VARCHAR(100) NOT NULL,
    line_name VARCHAR(100) NOT NULL,

    FOREIGN KEY (metro_id)
        REFERENCES metro_systems(metro_id)
);

DESCRIBE stations_india;

SELECT COUNT(*) AS total_stations
FROM stations_india;

SELECT * 
FROM metro_systems
ORDER BY metro_id;

INSERT INTO stations_india
    (metro_id, station_name, city, line_name)
SELECT
    CASE
        WHEN city = 'Bengaluru' THEN 1
        WHEN city = 'Chennai' THEN 2
        WHEN city = 'Delhi' THEN 3
        WHEN city = 'Hyderabad' THEN 4
    END AS metro_id,
    station_name,
    city,
    line_name
FROM stations1;

SELECT COUNT(*) AS total_stations
FROM stations_india;

USE metro_companion;

CREATE TABLE IF NOT EXISTS routes_india (
    route_id INT AUTO_INCREMENT PRIMARY KEY,
    source_station_id INT NOT NULL,
    destination_station_id INT NOT NULL,
    fare DECIMAL(10,2) NOT NULL,
    travel_time INT NOT NULL,
    distance DECIMAL(10,2) NOT NULL,

    FOREIGN KEY (source_station_id)
        REFERENCES stations_india(station_id),

    FOREIGN KEY (destination_station_id)
        REFERENCES stations_india(station_id)
);

SELECT COUNT(*) AS total_routes
FROM routes_india;

select station_id,station_name,city,line_name from stations1 order by city,line_name,station_id;

SELECT 
    r.route_id,
    s1.station_name AS source,
    s2.station_name AS destination,
    r.fare,
    r.travel_time,
    r.distance
FROM routes1 r
JOIN stations1 s1 ON r.source_station = s1.station_id
JOIN stations1 s2 ON r.destination_station = s2.station_id
ORDER BY r.route_id;

USE metro_companion;

SELECT city, line_name, station_name, COUNT(*) AS count
FROM stations1
GROUP BY city, line_name, station_name
HAVING COUNT(*) > 1;

SELECT station_id, station_name, city, line_name
FROM stations1
WHERE city = 'Bengaluru'
ORDER BY line_name, station_id;

SELECT station_id, station_name, line_name
FROM stations1
WHERE city = 'Bengaluru'
ORDER BY station_id;

describe stations1;
describe routes1;

SELECT city, line_name, COUNT(*) AS stations
FROM stations1
GROUP BY city, line_name
ORDER BY city, line_name;

USE metro_companion;

SELECT city, line_name, station_name
FROM stations1
WHERE city = 'Bengaluru'
ORDER BY line_name, station_id;

SELECT city, line_name, COUNT(*) AS stations
FROM stations1
WHERE city = 'Bengaluru'
GROUP BY city, line_name;

USE metro_companion;

INSERT INTO stations1 (station_name, city, line_name)
VALUES
('Madavara', 'Bengaluru', 'Green'),
('Chikkabidarakallu', 'Bengaluru', 'Green'),
('Nagasandra', 'Bengaluru', 'Green'),
('Dasarahalli', 'Bengaluru', 'Green'),
('Jalahalli', 'Bengaluru', 'Green'),
('Peenya Industry', 'Bengaluru', 'Green'),
('Peenya', 'Bengaluru', 'Green'),
('Goraguntepalya', 'Bengaluru', 'Green'),
('Yeshwanthpur', 'Bengaluru', 'Green'),
('Sandal Soap Factory', 'Bengaluru', 'Green'),
('Mahalakshmi', 'Bengaluru', 'Green'),
('Rajajinagar', 'Bengaluru', 'Green'),
('Mahakavi Kuvempu Road', 'Bengaluru', 'Green'),
('Srirampura', 'Bengaluru', 'Green'),
('Mantri Square Sampige Road', 'Bengaluru', 'Green'),
('Nadaprabhu Kempegowda Station Majestic', 'Bengaluru', 'Green'),
('Chickpet', 'Bengaluru', 'Green'),
('Krishna Rajendra Market', 'Bengaluru', 'Green'),
('National College', 'Bengaluru', 'Green'),
('Lalbagh', 'Bengaluru', 'Green'),
('South End Circle', 'Bengaluru', 'Green'),
('Jayanagar', 'Bengaluru', 'Green'),
('Rashtreeya Vidyalaya Road', 'Bengaluru', 'Green'),
('Banashankari', 'Bengaluru', 'Green'),
('JP Nagar', 'Bengaluru', 'Green'),
('Yelachenahalli', 'Bengaluru', 'Green'),
('Konanakunte Cross', 'Bengaluru', 'Green'),
('Doddakallasandra', 'Bengaluru', 'Green'),
('Vajarahalli', 'Bengaluru', 'Green'),
('Thalaghattapura', 'Bengaluru', 'Green'),
('Silk Institute', 'Bengaluru', 'Green');

SELECT *
FROM routes1
LIMIT 5;

SELECT route_id, source_station, destination_station, fare, travel_time, distance
FROM routes1
WHERE source_station LIKE '%Majestic%'
   OR destination_station LIKE '%Majestic%';
   
   SELECT *
FROM routes1
WHERE source_station IS NOT NULL
LIMIT 10;

SELECT station_id, station_name, city, line_name
FROM stations1
WHERE city = 'Bengaluru'
  AND line_name = 'Green'
  AND station_name LIKE '%Majestic%';
  
  USE metro_companion;

INSERT INTO routes1
(source_station, destination_station, fare, travel_time, distance)
VALUES
('Madavara', 'Chikkabidarakallu', 10, 3, 2),
('Chikkabidarakallu', 'Nagasandra', 10, 3, 2),
('Nagasandra', 'Dasarahalli', 10, 3, 2),
('Dasarahalli', 'Jalahalli', 10, 3, 2),
('Jalahalli', 'Peenya Industry', 10, 3, 2),
('Peenya Industry', 'Peenya', 10, 3, 2),
('Peenya', 'Goraguntepalya', 10, 3, 2),
('Goraguntepalya', 'Yeshwanthpur', 10, 3, 2),
('Yeshwanthpur', 'Sandal Soap Factory', 10, 3, 2),
('Sandal Soap Factory', 'Mahalakshmi', 10, 3, 2),
('Mahalakshmi', 'Rajajinagar', 10, 3, 2),
('Rajajinagar', 'Mahakavi Kuvempu Road', 10, 3, 2),
('Mahakavi Kuvempu Road', 'Srirampura', 10, 3, 2),
('Srirampura', 'Mantri Square Sampige Road', 10, 3, 2),
('Mantri Square Sampige Road', 'Nadaprabhu Kempegowda Station Majestic', 10, 3, 2),
('Nadaprabhu Kempegowda Station Majestic', 'Chickpet', 10, 3, 2),
('Chickpet', 'Krishna Rajendra Market', 10, 3, 2),
('Krishna Rajendra Market', 'National College', 10, 3, 2),
('National College', 'Lalbagh', 10, 3, 2),
('Lalbagh', 'South End Circle', 10, 3, 2),
('South End Circle', 'Jayanagar', 10, 3, 2),
('Jayanagar', 'Rashtreeya Vidyalaya Road', 10, 3, 2),
('Rashtreeya Vidyalaya Road', 'Banashankari', 10, 3, 2),
('Banashankari', 'JP Nagar', 10, 3, 2),
('JP Nagar', 'Yelachenahalli', 10, 3, 2),
('Yelachenahalli', 'Konanakunte Cross', 10, 3, 2),
('Konanakunte Cross', 'Doddakallasandra', 10, 3, 2),
('Doddakallasandra', 'Vajarahalli', 10, 3, 2),
('Vajarahalli', 'Thalaghattapura', 10, 3, 2),
('Thalaghattapura', 'Silk Institute', 10, 3, 2);

describe routes1;

SELECT station_id, station_name
FROM stations1
WHERE city = 'Bengaluru'
  AND line_name = 'Green'
ORDER BY station_id;

USE metro_companion;

INSERT INTO routes1
(source_station, destination_station, fare, travel_time, distance)
VALUES
(72, 73, 10, 3, 2),
(73, 74, 10, 3, 2),
(74, 75, 10, 3, 2),
(75, 76, 10, 3, 2),
(76, 77, 10, 3, 2),
(77, 78, 10, 3, 2),
(78, 79, 10, 3, 2),
(79, 80, 10, 3, 2),
(80, 81, 10, 3, 2),
(81, 82, 10, 3, 2),
(82, 83, 10, 3, 2),
(83, 84, 10, 3, 2),
(84, 85, 10, 3, 2),
(85, 86, 10, 3, 2),
(86, 87, 10, 3, 2),
(87, 88, 10, 3, 2),
(88, 89, 10, 3, 2),
(89, 90, 10, 3, 2),
(90, 91, 10, 3, 2),
(91, 92, 10, 3, 2),
(92, 93, 10, 3, 2),
(93, 94, 10, 3, 2),
(94, 95, 10, 3, 2),
(95, 96, 10, 3, 2),
(96, 97, 10, 3, 2),
(97, 98, 10, 3, 2),
(98, 99, 10, 3, 2),
(99, 100, 10, 3, 2),
(100, 101, 10, 3, 2),
(101, 102, 10, 3, 2);

SELECT station_id, station_name
FROM stations1
WHERE city = 'Bengaluru'
  AND line_name = 'Purple'
  AND station_name LIKE '%Majestic%';
  
  SELECT station_id, station_name
FROM stations1
WHERE city = 'Bengaluru'
  AND line_name = 'Purple'
ORDER BY station_id;

SELECT station_id, station_name, city, line_name
FROM stations1
ORDER BY station_id;

SELECT station_id, station_name, city, line_name
FROM stations1
WHERE city = 'Bengaluru';

SELECT station_id, station_name, city, line_name
FROM stations1 
where station_id in (48,72,102);

INSERT INTO routes1
(source_station, destination_station, fare, travel_time, distance)
VALUES
(48, 87, 0, 2, 0);

USE metro_companion;

INSERT INTO stations1 (station_name, city, line_name)
VALUES
('RV Road', 'Bengaluru', 'Yellow'),
('Ragigudda', 'Bengaluru', 'Yellow'),
('Jayadeva Hospital', 'Bengaluru', 'Yellow'),
('BTM Layout', 'Bengaluru', 'Yellow'),
('Central Silk Board', 'Bengaluru', 'Yellow'),
('Bommanahalli', 'Bengaluru', 'Yellow'),
('Hongasandra', 'Bengaluru', 'Yellow'),
('Kudlu Gate', 'Bengaluru', 'Yellow'),
('Singasandra', 'Bengaluru', 'Yellow'),
('Hosa Road', 'Bengaluru', 'Yellow'),
('Beratena Agrahara', 'Bengaluru', 'Yellow'),
('Electronic City', 'Bengaluru', 'Yellow'),
('Infosys Foundation Konappana Agrahara', 'Bengaluru', 'Yellow'),
('Huskur Road', 'Bengaluru', 'Yellow');

SELECT station_id, station_name
FROM stations1
WHERE city = 'Bengaluru'
  AND line_name = 'Yellow'
ORDER BY station_id;

USE metro_companion;

INSERT INTO routes1
(source_station, destination_station, fare, travel_time, distance)
VALUES
(103, 104, 10, 3, 2),
(104, 105, 10, 3, 2),
(105, 106, 10, 3, 2),
(106, 107, 10, 3, 2),
(107, 108, 10, 3, 2),
(108, 109, 10, 3, 2),
(109, 110, 10, 3, 2),
(110, 111, 10, 3, 2),
(111, 112, 10, 3, 2),
(112, 113, 10, 3, 2),
(113, 114, 10, 3, 2),
(114, 115, 10, 3, 2),
(115, 116, 10, 3, 2);

SELECT station_id, station_name, city, line_name
FROM stations1
WHERE city = 'Bengaluru'
  AND station_name = 'Rashtreeya Vidyalaya Road';
  
  INSERT INTO routes1
(source_station, destination_station, fare, travel_time, distance)
VALUES
(94, 103, 0, 2, 0);

USE metro_companion;

INSERT INTO stations1 (station_name, city, line_name)
VALUES
('St. Thomas Mount', 'Chennai', 'Green'),
('Alandur', 'Chennai', 'Green'),
('Guindy', 'Chennai', 'Green'),
('Little Mount', 'Chennai', 'Green'),
('Saidapet', 'Chennai', 'Green'),
('Nandanam', 'Chennai', 'Green'),
('Teynampet', 'Chennai', 'Green'),
('AG-DMS', 'Chennai', 'Green'),
('Thousand Lights', 'Chennai', 'Green'),
('LIC', 'Chennai', 'Green'),
('Government Estate', 'Chennai', 'Green'),
('Puratchi Thalaivar Dr. M.G. Ramachandran Central Metro', 'Chennai', 'Green');

SELECT station_id, station_name
FROM stations1
WHERE city = 'Chennai'
  AND line_name = 'Green'
ORDER BY station_id;

USE metro_companion;

INSERT INTO routes1
(source_station, destination_station, fare, travel_time, distance)
VALUES
(117, 118, 10, 3, 2),
(118, 119, 10, 3, 2),
(119, 120, 10, 3, 2),
(120, 121, 10, 3, 2),
(121, 122, 10, 3, 2),
(122, 123, 10, 3, 2),
(123, 124, 10, 3, 2),
(124, 125, 10, 3, 2),
(125, 126, 10, 3, 2),
(126, 127, 10, 3, 2),
(127, 128, 10, 3, 2);

SELECT station_id, station_name, city, line_name
FROM stations1
WHERE city = 'Chennai'
  AND station_name = 'Alandur';
  
  SELECT station_id, station_name, city, line_name
FROM stations1
WHERE city = 'Chennai'
  AND line_name = 'Blue'
  AND station_name LIKE '%Alandur%';
  
  SELECT station_id, station_name, city, line_name
FROM stations1
WHERE city = 'Chennai'
  AND line_name = 'Blue'
ORDER BY station_id;

SELECT DISTINCT city, line_name
FROM stations1
ORDER BY city, line_name;

SELECT station_id, station_name
FROM stations1
WHERE city = 'Chennai'
  AND line_name = 'Blue'
ORDER BY station_id;

SELECT station_id, station_name, city, line_name
FROM stations1
WHERE city = 'Chennai';

INSERT INTO routes1
(source_station, destination_station, fare, travel_time, distance)
VALUES
(64, 128, 0, 2, 0);

SELECT station_id, station_name, city, line_name
FROM stations1
WHERE city = 'Delhi'
ORDER BY station_id;

USE metro_companion;

INSERT INTO stations1 (station_name, city, line_name)
VALUES
('Samaypur Badli', 'Delhi', 'Yellow'),
('Rohini Sector 18, 19', 'Delhi', 'Yellow'),
('Haiderpur Badli Mor', 'Delhi', 'Yellow'),
('Jahangirpuri', 'Delhi', 'Yellow'),
('Adarsh Nagar', 'Delhi', 'Yellow'),
('Azadpur', 'Delhi', 'Yellow'),
('Model Town', 'Delhi', 'Yellow'),
('Vishwavidyalaya', 'Delhi', 'Yellow'),
('Vidhan Sabha', 'Delhi', 'Yellow'),
('Civil Lines', 'Delhi', 'Yellow'),
('Kashmere Gate', 'Delhi', 'Yellow'),
('Chandni Chowk', 'Delhi', 'Yellow'),
('Chawri Bazar', 'Delhi', 'Yellow'),
('New Delhi', 'Delhi', 'Yellow'),
('Rajiv Chowk', 'Delhi', 'Yellow'),
('Patel Chowk', 'Delhi', 'Yellow'),
('Central Secretariat', 'Delhi', 'Yellow'),
('Udyog Bhawan', 'Delhi', 'Yellow'),
('Lok Kalyan Marg', 'Delhi', 'Yellow'),
('Jor Bagh', 'Delhi', 'Yellow'),
('INA', 'Delhi', 'Yellow'),
('AIIMS', 'Delhi', 'Yellow'),
('Green Park', 'Delhi', 'Yellow'),
('Hauz Khas', 'Delhi', 'Yellow'),
('Malviya Nagar', 'Delhi', 'Yellow'),
('Saket', 'Delhi', 'Yellow'),
('Qutab Minar', 'Delhi', 'Yellow'),
('Chhatarpur', 'Delhi', 'Yellow'),
('Sultanpur', 'Delhi', 'Yellow'),
('Ghitorni', 'Delhi', 'Yellow'),
('Arjan Garh', 'Delhi', 'Yellow'),
('Guru Dronacharya', 'Delhi', 'Yellow'),
('Sikandarpur', 'Delhi', 'Yellow'),
('MG Road', 'Delhi', 'Yellow'),
('IFFCO Chowk', 'Delhi', 'Yellow'),
('Huda City Centre', 'Delhi', 'Yellow');

SELECT station_id, station_name
FROM stations1
WHERE city = 'Delhi'
  AND line_name = 'Yellow'
ORDER BY station_id;

SELECT city, line_name, COUNT(*) AS total
FROM stations1
WHERE city = 'Delhi'
GROUP BY city, line_name;

SELECT station_name, COUNT(*) AS count
FROM stations1
WHERE city = 'Delhi'
  AND line_name = 'Yellow'
GROUP BY station_name
HAVING COUNT(*) > 1;

SELECT station_id, station_name
FROM stations1
WHERE city = 'Delhi'
  AND line_name = 'Yellow'
ORDER BY station_id;

SELECT MIN(station_id) AS first_id,
       MAX(station_id) AS last_id,
       COUNT(*) AS total
FROM stations1
WHERE city = 'Delhi'
  AND line_name = 'Yellow';
  
  SELECT station_id, station_name
FROM stations1
WHERE city = 'Delhi'
  AND line_name = 'Yellow'
ORDER BY station_id
LIMIT 40;

SELECT station_name, GROUP_CONCAT(station_id ORDER BY station_id) AS ids
FROM stations1
WHERE city = 'Delhi'
  AND line_name = 'Yellow'
GROUP BY station_name
HAVING COUNT(*) > 1;

DELETE FROM stations1
WHERE city = 'Delhi'
  AND line_name = 'Yellow'
  AND station_id BETWEEN 165 AND 200;
  
  SELECT city, line_name, COUNT(*) AS total
FROM stations1
WHERE city = 'Delhi'
GROUP BY city, line_name;

SELECT station_id, station_name
FROM stations1
WHERE city = 'Delhi'
  AND line_name = 'Yellow'
ORDER BY station_id;

USE metro_companion;

INSERT INTO routes1
(source_station, destination_station, fare, travel_time, distance)
VALUES
(129,130,10,3,2),
(130,131,10,3,2),
(131,132,10,3,2),
(132,133,10,3,2),
(133,134,10,3,2),
(134,135,10,3,2),
(135,136,10,3,2),
(136,137,10,3,2),
(137,138,10,3,2),
(138,139,10,3,2),
(139,140,10,3,2),
(140,141,10,3,2),
(141,142,10,3,2),
(142,143,10,3,2),
(143,144,10,3,2),
(144,145,10,3,2),
(145,146,10,3,2),
(146,147,10,3,2),
(147,148,10,3,2),
(148,149,10,3,2),
(149,150,10,3,2),
(150,151,10,3,2),
(151,152,10,3,2),
(152,153,10,3,2),
(153,154,10,3,2),
(154,155,10,3,2),
(155,156,10,3,2),
(156,157,10,3,2),
(157,158,10,3,2),
(158,159,10,3,2),
(159,160,10,3,2),
(160,161,10,3,2),
(161,162,10,3,2),
(162,163,10,3,2),
(163,164,10,3,2);

SELECT station_id, station_name
FROM stations1
WHERE city = 'Delhi'
  AND line_name = 'Yellow'
  AND station_name = 'Rajiv Chowk';
  
  INSERT INTO routes1
(source_station, destination_station, fare, travel_time, distance)
VALUES
(56, 143, 0, 2, 0);

SELECT station_id, station_name, city, line_name
FROM stations1
WHERE city = 'Hyderabad'
ORDER BY station_id;

SELECT station_id, station_name, line_name
FROM stations1
WHERE city = 'Hyderabad'
ORDER BY station_id;

SELECT station_id, station_name, line_name
FROM stations1
WHERE city = 'Hyderabad'
  AND station_name = 'Ameerpet';
  
  SELECT station_id, station_name
FROM stations1
WHERE city = 'Hyderabad'
  AND line_name = 'Blue'
ORDER BY station_id;

SELECT DISTINCT city, line_name
FROM stations1
WHERE city = 'Hyderabad';

SELECT station_id, station_name
FROM stations1
WHERE city = 'Hyderabad'
  AND line_name = 'Blue'
ORDER BY station_id;

SELECT station_id, station_name, CONCAT('[', line_name, ']') AS line_check
FROM stations1
WHERE city = 'Hyderabad';

SELECT station_id, station_name
FROM stations1
WHERE station_id BETWEEN 28 AND 47
ORDER BY station_id;

SELECT station_id, station_name, line_name
FROM stations1
WHERE city = 'Hyderabad'
  AND station_name IN (
      SELECT station_name
      FROM stations1
      WHERE city = 'Hyderabad'
      GROUP BY station_name
      HAVING COUNT(DISTINCT line_name) > 1
  )
ORDER BY station_name, line_name;

SELECT *
FROM routes1
WHERE source_station BETWEEN 28 AND 47
   OR destination_station BETWEEN 28 AND 47;
   
   SELECT station_id, station_name, line_name
FROM stations1
WHERE city = 'Hyderabad'
  AND station_name LIKE '%Ameerpet%';
  
  INSERT INTO routes1
(source_station, destination_station, fare, travel_time, distance)
VALUES
(11, 28, 0, 2, 0);

INSERT INTO routes1
(source_station, destination_station, fare, travel_time, distance)
VALUES
(28, 11, 0, 2, 0);