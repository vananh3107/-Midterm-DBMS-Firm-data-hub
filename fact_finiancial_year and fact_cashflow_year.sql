-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema ffinyear_fcashyear
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema ffinyear_fcashyear
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `ffinyear_fcashyear` DEFAULT CHARACTER SET utf8 ;
USE `ffinyear_fcashyear` ;

-- -----------------------------------------------------
-- Table `ffinyear_fcashyear`.`fact_financial_year`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ffinyear_fcashyear`.`fact_financial_year` (
  `firm_id` BIGINT NOT NULL,
  `fiscal_year` SMALLINT NOT NULL,
  `snapshot_id` BIGINT NOT NULL,
  `unit_scale` BIGINT NOT NULL,
  `currency_code` CHAR(3) NOT NULL,
  `net_sales` DECIMAL(20,2) NULL,
  `total_assets` DECIMAL(20,2) NULL,
  `selling_expenses` DECIMAL(20,2) NULL,
  `general_admin_expenses` DECIMAL(20,2) NULL,
  `intangible_assets_net` DECIMAL(20,2) NULL,
  `manufacturing_overhead` DECIMAL(20,2) NULL,
  `net_operating_income` DECIMAL(20,2) NULL,
  `raw_material_consumption` DECIMAL(20,2) NULL,
  `merchandise_purchase_year` DECIMAL(20,2) NULL,
  `wip_goods_purchase` DECIMAL(20,2) NULL,
  `outside_manufacturing_expenses` DECIMAL(20,2) NULL,
  `production_cost` DECIMAL(20,2) NULL,
  `rnd_expenses` DECIMAL(20,2) NULL,
  `net_income` DECIMAL(20,2) NULL,
  `total_equity` DECIMAL(20,2) NULL,
  `total_liabilities` DECIMAL(20,2) NULL,
  `cash_and_equivalents` DECIMAL(20,2) NULL,
  `long_term_debt` DECIMAL(20,2) NULL,
  `current_assets` DECIMAL(20,2) NULL,
  `current_liabilities` DECIMAL(20,2) NULL,
  `growth_ratio` DECIMAL(20,2) NULL,
  `inventory` DECIMAL(20,2) NULL,
  `net_ppe` DECIMAL(20,2) NULL,
  `created_at` TIMESTAMP NULL,
  PRIMARY KEY (`firm_id`, `fiscal_year`, `snapshot_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ffinyear_fcashyear`.`fact_cashflow_year`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ffinyear_fcashyear`.`fact_cashflow_year` (
  `firm_id` BIGINT NOT NULL,
  `fiscal_year` SMALLINT NOT NULL,
  `snapshot_id` BIGINT NOT NULL,
  `unit_scale` BIGINT NULL,
  `currency_code` CHAR(3) NULL,
  `net_cfo` DECIMAL(20,2) NULL,
  `capex` DECIMAL(20,2) NULL,
  `net_cfi` DECIMAL(20,2) NULL,
  `created_at` TIMESTAMP NULL,
  PRIMARY KEY (`firm_id`, `fiscal_year`, `snapshot_id`))
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
