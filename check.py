import pandas as pd

# Thay tên file của bạn vào đây
file_path = 'datatype.xlsx' 
df = pd.read_excel(file_path)

print("--- DANH SÁCH CỘT MÀ PYTHON TÌM THẤY ---")
print(df.columns.tolist())