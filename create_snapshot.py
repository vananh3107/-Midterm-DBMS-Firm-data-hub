import mysql.connector
from datetime import date

config = {
    'user': 'root', 
    'password': 'Daohuonggiang25@', # Giang thay mật khẩu máy mình vào nhé
    'host': '127.0.0.1',
    'database': 'vn_firm_panel'
}

def create_snapshot_2022():
    conn = None
    try:
        conn = mysql.connector.connect(**config)
        cursor = conn.cursor()
        
        # Câu lệnh SQL tạo snapshot
        sql = """INSERT INTO fact_data_snapshot 
                 (snapshot_date, fiscal_year, source_id, version_tag, created_by) 
                 VALUES (%s, %s, %s, %s, %s)"""
        
        # Dữ liệu: Ngày hôm nay, Năm 2022, Nguồn 1, Tag mới, Người tạo là Giang
        #
        val = (date.today(), 2022, 1, 'v3.0-final', 'GiangDao')
        
        cursor.execute(sql, val)
        conn.commit()
        
        # Lấy ID tự tăng vừa được tạo
        new_id = cursor.lastrowid
        
        print(f"--- TRẠNG THÁI: TẠO THÀNH CÔNG ---")
        print(f"Năm tài chính: 2022")
        print(f"Mã Snapshot ID mới: {new_id}") # Đây là con số cuối cùng bạn cần!
        
    except mysql.connector.Error as err:
        if err.errno == 1062:
            print("Lỗi: Phiên bản 'v3.0-final' cho năm 2022 đã tồn tại. Hãy đổi tên tag khác trong code.")
        else:
            print(f"Lỗi kết nối: {err}")
    finally:
        if conn and conn.is_connected():
            cursor.close()
            conn.close()

if __name__ == "__main__":
    create_snapshot_2022()