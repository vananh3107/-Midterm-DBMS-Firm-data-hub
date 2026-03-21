DROP DATABASE IF EXISTS vn_firm_panel;
CREATE DATABASE vn_firm_panel;
USE vn_firm_panel;

SET FOREIGN_KEY_CHECKS=0;

-- =========================
-- DIM TABLES
-- =========================

CREATE TABLE dim_exchange (
  exchange_id TINYINT NOT NULL AUTO_INCREMENT,
  exchange_code VARCHAR(10) NOT NULL,
  exchange_name VARCHAR(100),
  PRIMARY KEY (exchange_id),
  UNIQUE (exchange_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


CREATE TABLE dim_data_source (
  source_id SMALLINT NOT NULL AUTO_INCREMENT,
  source_name VARCHAR(100) NOT NULL,
  source_type ENUM('market','financial_statement','ownership','text_report','manual') NOT NULL,
  provider VARCHAR(150),
  note VARCHAR(255),
  PRIMARY KEY (source_id),
  UNIQUE (source_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


CREATE TABLE dim_industry_l2(
  industry_l2_id SMALLINT NOT NULL,
  industry_l2_name VARCHAR(150) UNIQUE,
  PRIMARY KEY(industry_l2_id)
) ENGINE=InnoDB;


CREATE TABLE dim_firm (
  firm_id BIGINT NOT NULL AUTO_INCREMENT,
  ticker VARCHAR(20) NOT NULL,
  company_name VARCHAR(255) NOT NULL,
  exchange_id TINYINT NOT NULL,
  industry_l2_id SMALLINT,
  founded_year SMALLINT, 
  listed_year SMALLINT,
  status ENUM('active','delisted','inactive'),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP,
  PRIMARY KEY (firm_id),
  UNIQUE (ticker),
  FOREIGN KEY (exchange_id) REFERENCES dim_exchange(exchange_id),
  FOREIGN KEY (industry_l2_id) REFERENCES dim_industry_l2(industry_l2_id)
) ENGINE=InnoDB;


-- =========================
-- SNAPSHOT TABLE
-- =========================

CREATE TABLE fact_data_snapshot (
  snapshot_id BIGINT NOT NULL AUTO_INCREMENT,
  snapshot_date DATE NOT NULL,
  period_from DATE,
  period_to DATE,
  fiscal_year SMALLINT NOT NULL,
  source_id SMALLINT NOT NULL,
  version_tag VARCHAR(50) NOT NULL DEFAULT 'v1',
  created_by VARCHAR(80),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (snapshot_id),
  UNIQUE (source_id,fiscal_year,version_tag),
  FOREIGN KEY (source_id) REFERENCES dim_data_source(source_id)
) ENGINE=InnoDB;


-- =========================
-- FACT TABLES
-- =========================

CREATE TABLE fact_financial_year(
  firm_id BIGINT NOT NULL,
  fiscal_year SMALLINT NOT NULL,
  snapshot_id BIGINT NOT NULL,
  unit_scale BIGINT NOT NULL,
  currency_code CHAR(3) NOT NULL DEFAULT 'VND',
  net_sales DECIMAL(20,2),
  total_assets DECIMAL(20,2),
  selling_expenses DECIMAL(20,2),
  general_admin_expenses DECIMAL(20,2),
  intangible_assets_net DECIMAL(20,2),
  manufacturing_overhead DECIMAL(20,2),
  net_operating_income DECIMAL(20,2),
  raw_material_consumption DECIMAL(20,2),
  merchandise_purchase_year DECIMAL(20,2),
  wip_goods_purchase DECIMAL(20,2),
  outside_manufacturing_expenses DECIMAL(20,2),
  production_cost DECIMAL(20,2),
  rnd_expenses DECIMAL(20,2),
  net_income DECIMAL(20,2),
  total_equity DECIMAL(20,2),
  total_liabilities DECIMAL(20,2),
  growth_ratio DECIMAL(10,6),
  inventory DECIMAL(20,2),
  net_ppe DECIMAL(20,2),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (firm_id,fiscal_year,snapshot_id),
  FOREIGN KEY (firm_id) REFERENCES dim_firm(firm_id),
  FOREIGN KEY (snapshot_id) REFERENCES fact_data_snapshot(snapshot_id)
);


CREATE TABLE fact_market_year (
  firm_id BIGINT NOT NULL,
  fiscal_year SMALLINT NOT NULL,
  snapshot_id BIGINT NOT NULL,
  shares_outstanding BIGINT,
  price_reference ENUM('close_year_end','avg_year','close_fiscal_end'),
  share_price DECIMAL(20,4),
  market_value_equity DECIMAL(20,2),
  dividend_cash_paid DECIMAL(20,2),
  eps_basic DECIMAL(20,6),
  currency_code CHAR(3) NOT NULL DEFAULT 'VND',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (firm_id,fiscal_year,snapshot_id),
  FOREIGN KEY (firm_id) REFERENCES dim_firm(firm_id),
  FOREIGN KEY (snapshot_id) REFERENCES fact_data_snapshot(snapshot_id)
);


CREATE TABLE fact_ownership_year (
  firm_id BIGINT NOT NULL,
  fiscal_year SMALLINT NOT NULL,
  snapshot_id BIGINT NOT NULL,
  managerial_inside_own DECIMAL(10,6),
  state_own DECIMAL(10,6),
  institutional_own DECIMAL(10,6),
  foreign_own DECIMAL(10,6),
  note VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (firm_id,fiscal_year,snapshot_id),
  FOREIGN KEY (firm_id) REFERENCES dim_firm(firm_id),
  FOREIGN KEY (snapshot_id) REFERENCES fact_data_snapshot(snapshot_id)
);


CREATE TABLE fact_innovation_year(
  firm_id BIGINT NOT NULL,
  fiscal_year SMALLINT NOT NULL,
  snapshot_id BIGINT NOT NULL,
  product_innovation TINYINT,
  process_innovation TINYINT,
  evidence_source_id SMALLINT,
  evidence_note VARCHAR(500),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (firm_id,fiscal_year,snapshot_id),
  FOREIGN KEY (firm_id) REFERENCES dim_firm(firm_id),
  FOREIGN KEY (snapshot_id) REFERENCES fact_data_snapshot(snapshot_id),
  FOREIGN KEY (evidence_source_id) REFERENCES dim_data_source(source_id)
);


CREATE TABLE fact_firm_year_meta(
  firm_id BIGINT NOT NULL,
  fiscal_year SMALLINT NOT NULL,
  snapshot_id BIGINT NOT NULL,
  employees_count INT,
  firm_age SMALLINT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (firm_id,fiscal_year,snapshot_id),
  FOREIGN KEY (firm_id) REFERENCES dim_firm(firm_id),
  FOREIGN KEY (snapshot_id) REFERENCES fact_data_snapshot(snapshot_id)
);


CREATE TABLE fact_value_override_log(
  override_id BIGINT NOT NULL AUTO_INCREMENT,
  firm_id BIGINT NOT NULL,
  fiscal_year SMALLINT NOT NULL,
  table_name VARCHAR(80) NOT NULL,
  column_name VARCHAR(80) NOT NULL,
  old_value VARCHAR(255),
  new_value VARCHAR(255),
  reason VARCHAR(255),
  changed_by VARCHAR(80),
  changed_at TIMESTAMP,
  PRIMARY KEY (override_id),
  FOREIGN KEY (firm_id) REFERENCES dim_firm(firm_id)
);

CREATE TABLE fact_cashflow_year (
  firm_id BIGINT NOT NULL,
  fiscal_year SMALLINT NOT NULL,
  snapshot_id BIGINT NOT NULL,
  unit_scale BIGINT,
  currency_code CHAR(3) DEFAULT 'VND',
  net_cfo DECIMAL(20,2),
  capex DECIMAL(20,2),
  net_cfi DECIMAL(20,2),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (firm_id, fiscal_year, snapshot_id),
  FOREIGN KEY (firm_id) REFERENCES dim_firm(firm_id),
  FOREIGN KEY (snapshot_id) REFERENCES fact_data_snapshot(snapshot_id)
);


-- =========================
-- SEED TEST
-- =========================

INSERT IGNORE INTO dim_exchange(exchange_id,exchange_code, exchange_name)
VALUES (1,'HOSE', 'Ho Chi Minh Stock Exchange');
INSERT IGNORE INTO dim_exchange(exchange_id,exchange_code, exchange_name)
VALUES (2,'HNX', 'Hanoi Stock Exchange');

INSERT IGNORE INTO dim_data_source(source_id,source_name,source_type, provider, note)
VALUES (1, 'FiinPro', 'ownership', 'FiinGroup', 'Ownership ratios (end-of-year snapshot)');
INSERT IGNORE INTO dim_data_source(source_id,source_name,source_type, provider, note)
VALUES (2, 'BCTC_Audited', 'financial_statement', 'Company/Exchange', 'Audited financial statements');
INSERT IGNORE INTO dim_data_source(source_id,source_name,source_type, provider, note)
VALUES (3, 'Vietstock', 'market', 'Vietstock', 'Market fields (price, shares, dividend, EPS)');
INSERT IGNORE INTO dim_data_source(source_id,source_name,source_type, provider, note)
VALUES (4, 'AnnualReport', 'text_report', 'Company', 'Annual report / disclosures for innovation & headcount');

INSERT IGNORE INTO dim_industry_l2(industry_l2_id,industry_l2_name)
VALUES (2, 'Thực phẩm và đồ uống');
SET FOREIGN_KEY_CHECKS=1;