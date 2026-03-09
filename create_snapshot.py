import mysql.connector
from datetime import date

# CẤU HÌNH: Giang hãy sửa mật khẩu đúng của máy mình ở đây
config = {
    'user': 'root', 
    'password': 'Daohuonggiang25@', # <== THAY MẬT KHẨU WORKBENCH VÀO ĐÂY
    'host': '127.0.0.1',
    'database': 'vn_firm_panel'
}

def create_snapshot_2022():
    conn = None # Khởi tạo để tránh lỗi UnboundLocalError
    try:
        conn = mysql.connector.connect(**config)
        cursor = conn.cursor()
        
        # Câu lệnh Insert (nhớ để version_tag khác với các bản đã có để tránh lỗi 1062)
        sql = """INSERT INTO fact_data_snapshot 
                 (snapshot_date, fiscal_year, source_id, version_tag, created_by) 
                 VALUES (%s, %s, %s, %s, %s)"""
        
        # Dữ liệu: Ngày hôm nay, Năm 2022, Nguồn 1, Tag 'v1.0-python', Người tạo Giang
        data = (date.today(), 2022, 1, 'v2.0-final', 'GiangDao')
        
        cursor.execute(sql, data)
        conn.commit()
        
        # Lấy ID tự tăng vừa được tạo
        snapshot_id = cursor.lastrowid
        
        print(f"--- THÔNG TIN SNAPSHOT MỚI ---")
        print(f"Năm tài chính: 2022")
        print(f"Snapshot ID vừa tạo: {snapshot_id}") # <== IN RA THEO YÊU CẦU
        
    except mysql.connector.Error as err:
        if err.errno == 1062:
            print("Lỗi: Snapshot năm 2022 với tag này đã tồn tại trong DB.")
        else:
            print(f"Lỗi kết nối: {err}")
    finally:
        if conn and conn.is_connected():
            cursor.close()
            conn.close()

if __name__ == "__main__":
    create_snapshot_2022()