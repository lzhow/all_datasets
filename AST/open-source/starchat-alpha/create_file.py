import os
import pandas as pd

def create_excel(base_dirs, output_file):
    data = []  # 用于存储文件信息的列表

    for base_dir in base_dirs:
        for root, dirs, files in os.walk(base_dir):
            for dir in dirs:
                # 仅处理文件夹中的文件，排除根目录中的文件
                data.append([dir, 1, 1])  # 文件路径，AST合理性，CFG合理性

    # 创建DataFrame
    df = pd.DataFrame(data, columns=['Filename', 'AST Validity', 'CFG Validity'])
    # 保存为Excel文件
    df.to_excel(output_file, index=False)

# 定义要遍历的基础目录
base_dirs = ['C', 'java-basics', 'python', 'solidity']
# 输出文件的名称
output_file = 'file_validity.xlsx'

create_excel(base_dirs, output_file)
