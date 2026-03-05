USE vn_firm_panel;

-- ---------------------------------------------------------
-- BƯỚC 1: CHUẨN BỊ DỮ LIỆU NỀN (CHO KHÓA NGOẠI)
-- ---------------------------------------------------------
INSERT IGNORE INTO dim_exchange (exchange_id, exchange_code) VALUES (1, 'HOSE');
INSERT IGNORE INTO dim_data_source (source_id, source_name, source_type) VALUES (1, 'BCTC_Source', 'financial_statement');

-- ---------------------------------------------------------
-- BƯỚC 2: INSERT DUMMY THEO YÊU CẦU CÔNG VIỆC
-- ---------------------------------------------------------

-- 1. Insert 1 firm dummy
INSERT INTO dim_firm (ticker, company_name, exchange_id) 
VALUES ('DUMMY_TICKER', 'Công ty Giả định Test', 1);

-- 2. Insert 1 snapshot dummy
INSERT INTO fact_data_snapshot (snapshot_date, fiscal_year, source_id, version_tag)
VALUES (CURDATE(), 2024, 1, 'v1.0-test');

-- ---------------------------------------------------------
-- BƯỚC 3: CÁC CÂU LỆNH KIỂM TRA (CHẠY ĐỂ TEST CONSTRAINT)
-- ---------------------------------------------------------

-- Test UNIQUE Ticker: Lệnh này PHẢI báo lỗi (Duplicate entry)
-- INSERT INTO dim_firm (ticker, company_name, exchange_id) VALUES ('DUMMY_TICKER', 'Mã bị trùng', 1);

-- Test UNIQUE Snapshot: Lệnh này PHẢI báo lỗi (Duplicate entry)
-- INSERT INTO fact_data_snapshot (snapshot_date, fiscal_year, source_id, version_tag) VALUES (CURDATE(), 2024, 1, 'v1.0-test');

-- ---------------------------------------------------------
-- BƯỚC 4: XEM KẾT QUẢ
-- ---------------------------------------------------------
SELECT * FROM dim_firm;
SELECT * FROM fact_data_snapshot;