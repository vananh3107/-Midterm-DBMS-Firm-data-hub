def insert_market_test(data):
    
    conn = None
    try:
        conn = mysql.connector.connect(**config) # Dùng chung config của Giang
        cursor = conn.cursor()
        
        # Câu lệnh SQL với đầy đủ 10 cột theo yêu cầu
        sql = """
        INSERT INTO fact_market_year (
            firm_id, fiscal_year, snapshot_id, shares_outstanding, 
            price_reference, share_price, market_value_equity, 
            dividend_cash_paid, eps_basic, currency_code
        ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
        """
        
        # Trích xuất đầy đủ các biến
        values = (
            data['firm_id'], 
            data['fiscal_year'], 
            data['snapshot_id'], 
            data.get('shares_outstanding'),
            data.get('price_reference'),
            data.get('share_price'),
            data.get('market_value_equity'),
            data.get('dividend_cash_paid'),
            data.get('eps_basic'),
            data.get('currency_code', 'VND') # Mặc định là VND nếu thiếu
        )
        
        cursor.execute(sql, values)
        conn.commit()
        print(f"--- Test Insert Market thành công cho Firm {data['firm_id']}! ---")
        
    except mysql.connector.Error as err:
        print(f"Lỗi (Market): {err}")
    finally:
        if conn and conn.is_connected():
            cursor.close()
            conn.close()
if __name__ == "__main__":
    sample_data = {
        'firm_id': 1, 
        'fiscal_year': 2024, 
        'snapshot_id': 1,
        # Biến Market
        'shares_outstanding': 100000000, 
        'price_reference': 'close_year_end',
        'share_price': 50000.0, 
        'market_value_equity': 5000000000000.0,
        'dividend_cash_paid': 2000.0, 
        'eps_basic': 4500.0,
        'currency_code': 'VND'
    }
    
    insert_market_test(sample_data)
