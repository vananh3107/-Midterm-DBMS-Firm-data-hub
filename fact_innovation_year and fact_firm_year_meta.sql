CREATE TABLE fact_innovation_year(
		firm_id BIGINT NOT NULL,
        fiscal_year SMALLINT NOT NULL,
        snapshot_id BIGINT NOT NULL,
        product_innovation TINYINT NULL,
        process_innovation TINYINT NULL,
        evidence_source_id SMALLINT NULL,
        evidence_note VARCHAR(500) NULL,
        created_at TIMESTAMP NULL,
        
        PRIMARY KEY (firm_id, fiscal_year, snapshot_id),
        
        FOREIGN KEY (firm_id) REFERENCES dim_firm(firm_id),
        FOREIGN KEY (snapshot_id) REFERENCES fact_data_snapshot(snapshot_id),
        FOREIGN KEY (evidence_source_id) REFERENCES dim_data_source(source_id));
        
CREATE TABLE fact_firm_year_meta(
		firm_id BIGINT NOT NULL,
        fiscal_year SMALLINT NOT NULL,
        snapshot_id BIGINT NOT NULL,
        employees_count INT NULL,
        firm_age SMALLINT NULL,
        created_at TIMESTAMP NULL,
        
        PRIMARY KEY (firm_id, fiscal_year, snapshot_id),
        FOREIGN KEY (firm_id) REFERENCES dim_firm(firm_id),
        FOREIGN KEY (snapshot_id) REFERENCES fact_data_snapshot(snapshot_id));