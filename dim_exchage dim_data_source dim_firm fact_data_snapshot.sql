-- 1. Tạo bảng dim_exchange
CREATE TABLE IF NOT EXISTS `dim_exchange` (
  `exchange_id` TINYINT NOT NULL AUTO_INCREMENT,
  `exchange_code` VARCHAR(10) NOT NULL,
  `exchange_name` VARCHAR(100) DEFAULT NULL,
  PRIMARY KEY (`exchange_id`),
  UNIQUE KEY `uq_exchange_code` (`exchange_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 2. Tạo bảng dim_data_source
CREATE TABLE IF NOT EXISTS `dim_data_source` (
  `source_id` SMALLINT NOT NULL AUTO_INCREMENT,
  `source_name` VARCHAR(100) NOT NULL,
  `source_type` ENUM('market','financial_statement','ownership','text_report','manual') NOT NULL,
  `provider` VARCHAR(150) DEFAULT NULL,
  PRIMARY KEY (`source_id`),
  UNIQUE KEY `uq_source_name` (`source_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 3. Tạo bảng dim_firm
CREATE TABLE IF NOT EXISTS `dim_firm` (
  `firm_id` BIGINT NOT NULL AUTO_INCREMENT,
  `ticker` VARCHAR(20) NOT NULL,
  `company_name` VARCHAR(255) NOT NULL,
  `exchange_id` TINYINT NOT NULL,
  `industry_l2_id` SMALLINT DEFAULT NULL,
  PRIMARY KEY (`firm_id`),
  UNIQUE KEY `uq_ticker` (`ticker`),
  CONSTRAINT `fk_firm_exchange` FOREIGN KEY (`exchange_id`) REFERENCES `dim_exchange` (`exchange_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 4. Tạo bảng fact_data_snapshot
CREATE TABLE IF NOT EXISTS `fact_data_snapshot` (
  `snapshot_id` BIGINT NOT NULL AUTO_INCREMENT,
  `snapshot_date` DATE NOT NULL,
  `fiscal_year` SMALLINT NOT NULL,
  `source_id` SMALLINT NOT NULL,
  `version_tag` VARCHAR(50) NOT NULL DEFAULT 'v1',
  PRIMARY KEY (`snapshot_id`),
  UNIQUE KEY `uq_snapshot` (`source_id`, `fiscal_year`, `version_tag`),
  CONSTRAINT `fk_snapshot_source` FOREIGN KEY (`source_id`) REFERENCES `dim_data_source` (`source_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;