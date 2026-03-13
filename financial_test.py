def insert_financial_test(data):
    
    conn = None
    try:
        conn = mysql.connector.connect(**config)
        cursor = conn.cursor()
        
        
        sql = """
        INSERT INTO fact_market_year (
            firm_id, fiscal_year, snapshot_id, unit_scale, 
            currency_code, net_sales, total_assets, 
            selling_expenses, general_admin_expenses, intangible_assets_net, 
            manufacturing_overhead, net_operating_income, raw_material_consumption,
            merchandise_purchase_year, wip_goods_purchase, outside_manufacturing_expenses,
            production_cost, rnd_expenses, net_income, total_equity, total_liabilities,
            cash_and_equivalents, long_term_debt, current_assets, current_liabilities,
            growth_ratio, inventory, net_ppe, created_at
        ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
        """

        
        # Trích xuất đầy đủ các biến
        values = (
            data['firm_id'], 
            data['fiscal_year'], 
            data['snapshot_id'], 
            data['unit_scale'],
            data['currency_code', 'VND'],
            data['created_at'],
            data.get('net_sales'),
            data.get('total_assets'),
            data.get('selling_expenses'),
            data.get('general_admin_expenses'),
            data.get('intangible_assets_net'),
            data.get('manufacturing_overhead'),
            data.get('net_operating_income'),
            data.get('raw_material_consumption'),
            data.get('merchandise_purchase_year'),
            data.get('wip_goods_purchase'),
            data.get('outside_manufacturing_expenses'),
            data.get('production_cost'),
            data.get('rnd_expenses'),
            data.get('net_income'),
            data.get('total_equity'),
            data.get('total_liabilities'),
            data.get('cash_and_equivalents'),
            data.get('long_term_debt'),
            data.get('current_assets'),
            data.get('current_liabilities'),
            data.get('growth_ratio'),
            data.get('inventory'),
            data.get('net_ppe'),
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
        'unit_scale':1000000000,
        'currency_code':'VND',
        'net_sales': 145.00,
        'total_assets': 275.00,
        'selling_expenses': 6.60,
        'general_admin_expenses': 7.80,
        'intangible_assets_net': 3.70,
        'manufacturing_overhead': 9.20,
        'net_operating_income': 25.00,
        'raw_material_consumption': 60.00,
        'merchandise_purchase_year': 12.50,
        'wip_goods_purchase': 2.00,
        'outside_manufacturing_expenses': 1.15,
        'production_cost': 86.00,
        'rnd_expenses': 1.20,
        'net_income': 15.00,
        'total_equity': 112.00,
        'total_liabilities': 163.00,
        'cash_and_equivalents': 12.00,
        'long_term_debt': 33.00,
        'current_assets': 95.00,
        'current_liabilities': 56.00,
        'growth_ratio': 0.115385,
        'inventory': 29.00,
        'net_ppe': 72.00,
        'created_at': '2026-01-22 00:00:00'
    }
    
    insert_financial_test(sample_data)
