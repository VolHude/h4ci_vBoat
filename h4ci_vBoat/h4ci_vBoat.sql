CREATE TABLE `boat` (
  `name` varchar(60) NOT NULL,
  `model` varchar(60) NOT NULL,
  `price` int(11) NOT NULL,
  `category` varchar(60) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `boat` (`name`, `model`, `price`, `category`) VALUES
('Jetmax', 'jetmax', 10000, 'bateaux'),
('Seashark', 'seashark', 7500, 'jetski');


CREATE TABLE `boat_categories` (
  `name` varchar(60) NOT NULL,
  `label` varchar(60) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `boat_categories` (`name`, `label`) VALUES
('bateaux', 'Bateaux'),
('jetski', 'Jetski');


ALTER TABLE `boat`
  ADD PRIMARY KEY (`model`);

ALTER TABLE `boat_categories`
  ADD PRIMARY KEY (`name`);
COMMIT;


CREATE TABLE IF NOT EXISTS `owned_boat` (
	`owner` varchar(40) NOT NULL,
	`plate` varchar(12) NOT NULL,
	`vehicle` longtext,
	`type` varchar(20) NOT NULL DEFAULT 'car',
	`job` varchar(20) NOT NULL DEFAULT 'civ',
	`stored` tinyint(1) NOT NULL DEFAULT '1',
	
	PRIMARY KEY (`plate`)
);