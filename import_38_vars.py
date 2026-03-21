import os
import mysql.connector
import pandas as pd
import numpy as np
from dotenv import load_dotenv

load_dotenv()

config = {
    'host': os.getenv('DB_HOST'),
    'user': os.getenv('DB_USER'),
    'password': os.getenv('DB_PASS'),
    'database': os.getenv('DB_NAME')
}

def import_clean_data():
    file_path = 'panel_2020_2024.xlsx'
    
    try:
        conn = mysql.connector.connect(**config)
        cursor = conn.cursor()
        
        # 1. XÓA SẠCH DỮ LIỆU LỖI TRONG BẢNG TRƯỚC
        cursor.execute("TRUNCATE TABLE fact_firm_data")
        print("--- Đã quét sạch bảng fact_firm_data để nạp mới ---")

        # 2. Đọc file (Vì file này đã điền ticker đủ nên không cần ffill nữa)
        df = pd.read_excel(file_path, header=0)
        df.columns = df.columns.str.strip()
        
        # 3. Xử lý giá trị trống
        df = df.astype(object).where(pd.notnull(df), None)
        df = df.replace(['Null', 'NULL', 'nan', 'NaN'], None)

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

        # 4. Câu lệnh SQL INSERT
        columns_sql = "ticker, snapshot_id, fiscal_year, " + ", ".join(vars_38)
        placeholders = ", ".join(["%s"] * (len(vars_38) + 3))
        sql = f"INSERT INTO fact_firm_data ({columns_sql}) VALUES ({placeholders})"
        
        count = 0
        for _, row in df.iterrows():
            if row['ticker'] is not None:
                # Lấy dữ liệu theo thứ tự: ticker, snapshot_id (42), fiscal_year, + 38 biến
                values = [row['ticker'], 42, row['fiscal_year']] + [row[v] for v in vars_38]
                cursor.execute(sql, values)
                count += 1
        
        conn.commit()
        print(f"--- THÀNH CÔNG RỰC RỠ ---")
        print(f"Đã nạp lại {count} dòng dữ liệu CHUẨN ĐÉT vào Database.")

    except Exception as e:
        print(f"Lỗi rồi Giang ơi: {e}")
    finally:
        if 'conn' in locals() and conn.is_connected():
            cursor.close()
            conn.close()

if __name__ == "__main__":
    import_clean_data()
