
def insert_market_test(data):
    conn = None
    try:
        conn = mysql.connector.connect(**config)
        cursor = conn.cursor()
        
        sql = """
        INSERT INTO fact_market_year (
            firm_id, fiscal_year, snapshot_id, shares_outstanding, 
            price_reference, share_price, market_value_equity, 
            dividend_cash_paid, eps_basic
        ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
        """
        values = (
            data['firm_id'], 
            data['fiscal_year'], 
            data['snapshot_id'], 
            data.get('shares_outstanding'),
            data.get('price_reference'),
            data.get('share_price'),
            data.get('market_value_equity'),
            data.get('dividend_cash_paid'),
            data.get('eps_basic')
        )
        
        cursor.execute(sql, values)
        conn.commit()
        print(f"---Test Insert Market thành công cho Firm {data['firm_id']}! ---")
        
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
        'shares_outstanding': 100000000, 
        'price_reference': 'close_year_end',
        'share_price': 50000, 
        'market_value_equity': 5000000000000,
        'dividend_cash_paid': 2000, 
        'eps_basic': 4500,
    }

    insert_market_test(sample_data)
