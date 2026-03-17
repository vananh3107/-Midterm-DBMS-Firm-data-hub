import mysql.connector
import pandas as pd
import numpy as np

config = {
    'user': 'root', 
    'password': 'Daohuonggiang25@', # GIANG NHỚ SỬA PASS MÁY MÌNH NHÉ
    'host': '127.0.0.1',
    'database': 'vn_firm_panel'
}

def import_data():
    file_path = 'panel_2020_2024.xlsx'
    snapshot_id = 42
    
    conn = None
    try:
        conn = mysql.connector.connect(**config)
        cursor = conn.cursor()
        
        # 1. Đọc file - Lấy dòng thứ 2 (header=1) làm tiêu đề để tìm thấy chữ 'ticket'
        df = pd.read_excel(file_path, header=1)
        
        # 2. Chuẩn hóa tên cột: xóa khoảng trắng và đổi ticket -> ticker cho đồng bộ
        df.columns = df.columns.str.strip().str.lower()
        if 'ticker' in df.columns:
            df.rename(columns={'ticket': 'ticker'}, inplace=True)
            print("--- Đã tìm thấy cột 'ticket' và đổi tên thành 'ticker' để nạp vào DB ---")
        
        # 3. Xử lý giá trị trống
        df = df.replace(['Null', 'NULL', 'nan', 'NaN'], np.nan)
        df = df.where(pd.notnull(df), None)
        
        # Danh sách 38 biến tài chính
        vars_38 = [
            'managerial_inside_own', 'state_own', 'institutional_own', 'foreign_own', 
            'shares_outstanding', 'net_sales', 'total_assets', 'selling_expenses', 
            'general_admin_expenses', 'intangible_assets_net', 'manufacturing_overhead', 
            'net_operating_income', 'raw_material_consumption', 'merchandise_purchase_year', 
            'wip_goods_purchase', 'outside_manufacturing_expenses', 'production_cost', 
            'rnd_expenses', 'product_innovation', 'process_innovation', 'net_income', 
            'total_equity', 'market_value_equity', 'total_liabilities', 'net_cfo', 'capex', 
            'net_cfi', 'cash_and_equivalents', 'long_term_debt', 'current_assets', 
            'current_liabilities', 'growth_ratio', 'inventory', 'dividend_cash_paid', 
            'eps_basic', 'employees_count', 'net_ppe', 'firm_age'
        ]

        # Kiểm tra xem các cột có đủ trong Excel không
        missing_cols = [v for v in vars_38 if v not in df.columns]
        if missing_cols:
            print(f"Cảnh báo: Thiếu các cột sau trong Excel: {missing_cols}")
            # Loại bỏ các cột thiếu khỏi danh sách nạp để tránh lỗi
            vars_38 = [v for v in vars_38 if v in df.columns]

        # Câu lệnh SQL INSERT
        columns_sql = "ticker, snapshot_id, fiscal_year, " + ", ".join(vars_38)
        placeholders = ", ".join(["%s"] * (len(vars_38) + 3))
        sql = f"INSERT INTO fact_firm_data ({columns_sql}) VALUES ({placeholders})"
        
        count = 0
        for _, row in df.iterrows():
            if row['ticker'] is not None:
                # Lấy dữ liệu: ticker, snapshot_id, fiscal_year, 38 biến
                values = [row['ticker'], snapshot_id, row['fiscal_year']] + [row[v] for v in vars_38]
                cursor.execute(sql, values)
                count += 1
        
        conn.commit()
        print(f"--- THÀNH CÔNG RỰC RỠ ---")
        print(f"Đã nạp {count} dòng dữ liệu vào bảng fact_firm_data.")

    except Exception as e:
        print(f"Lỗi: {e}")
    finally:
        if conn and conn.is_connected():
            cursor.close()
            conn.close()

if __name__ == "__main__":
    import_data()