import mysql.connector
import pandas as pd

# CẤU HÌNH: Hãy nhập đúng mật khẩu bạn dùng trong MySQL Workbench
config = {
    'user': 'root', 
    'password': 'Daohuonggiang25@', # Ví dụ: '123456'
    'host': '127.0.0.1', # Nếu vẫn lỗi hãy thử đổi thành 'localhost'
    'database': 'vn_firm_panel'
}

def import_firms(file_path):
    conn = None # KHỞI TẠO để tránh lỗi UnboundLocalError
    try:
        conn = mysql.connector.connect(**config)
        cursor = conn.cursor()
        
        # Đọc file CSV
        df = pd.read_csv(file_path)
        firms_to_import = df.head(20) # Lấy 20 tickers thật theo yêu cầu
        
        # Dùng INSERT IGNORE để không bị dừng nếu trùng ticker
        sql = "INSERT IGNORE INTO dim_firm (ticker, company_name, exchange_id) VALUES (%s, %s, %s)"
        
        for _, row in firms_to_import.iterrows():
            cursor.execute(sql, (row['ticker'], row['company_name'], row['exchange_id']))
        
        conn.commit()
        print(f"--- KẾT QUẢ ---")
        print(f"Trạng thái: Thành công")
        print(f"Đã xử lý: {len(firms_to_import)} dòng dữ liệu.")
        
    except mysql.connector.Error as err:
        print(f"Lỗi MySQL: {err}")
    except Exception as e:
        print(f"Lỗi khác: {e}")
    finally:
        # Kiểm tra conn tồn tại trước khi đóng
        if conn and conn.is_connected():
            cursor.close()
            conn.close()

if __name__ == "__main__":
    import_firms('firms.csv')