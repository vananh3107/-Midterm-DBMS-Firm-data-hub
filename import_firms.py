import mysql.connector
import pandas as pd

config = {
    'user': 'root', 
    'password': 'Daohuonggiang25@', # Thay pass của Giang vào nhé
    'host': '127.0.0.1',
    'database': 'vn_firm_panel'
}

def import_firms(file_path):
    conn = None
    try:
        conn = mysql.connector.connect(**config)
        cursor = conn.cursor()
        
        # Đọc CSV
        df = pd.read_csv(file_path)
        
        # Xử lý khoảng trắng thừa ở tiêu đề cột (để tránh lỗi NULL)
        df.columns = df.columns.str.strip()
        
        # Chuyển các ô trống thành None để MySQL hiểu là NULL
        df = df.where(pd.notnull(df), None)
        
        # Lấy 10 dòng dữ liệu bạn vừa gửi
        firms_to_import = df.head(10)
        
        # Câu lệnh SQL nạp ĐẦY ĐỦ các cột có trong CSV của bạn
        sql = """INSERT IGNORE INTO dim_firm 
                 (firm_id, ticker, company_name, exchange_id, industry_l2_id, 
                  founded_year, listed_year, status, created_at, updated_at) 
                 VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"""
        
        for _, row in firms_to_import.iterrows():
            data = (
                row['firm_id'], row['ticker'], row['company_name'], 
                row['exchange_id'], row['industry_l2_id'], row['founded_year'], 
                row['listed_year'], row['status'], row['created_at'], row['updated_at']
            )
            cursor.execute(sql, data)
        
        conn.commit()
        print("--- THÀNH CÔNG RỰC RỠ ---")
        print(f"Đã nạp đầy đủ 10 cột thông tin cho {len(firms_to_import)} doanh nghiệp.")
        
    except Exception as e:
        print(f"Lỗi: {e}")
    finally:
        if conn and conn.is_connected():
            cursor.close()
            conn.close()

if __name__ == "__main__":
    import_firms('firms.csv')