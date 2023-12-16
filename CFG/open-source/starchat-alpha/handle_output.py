import os
import json
import re

def extract_json_after_marker(file_path, marker):
    try:
        with open(file_path, 'r', encoding='utf-8') as file:
            lines = file.readlines()

        start_index = -1
        for i, line in enumerate(lines):
            if marker in line:
                start_index = i + 1
                break

        if start_index == -1:
            return None

        # 尝试逐行解析JSON
        for i in range(start_index, len(lines)):
            try:
                json_data = ''.join(lines[start_index:i+1])
                return json.loads(json_data)
            except json.JSONDecodeError:
                continue  # 继续读取下一行

        return None
    except Exception as e:
        print(f"Error processing file {file_path}: {e}")
        return None

def process_files(base_dirs, file_names, marker):
    for base_dir in base_dirs:
        for root, dirs, files in os.walk(base_dir):
            for file in files:
                if file in file_names:
                    file_path = os.path.join(root, file)
                    
                    # if file_path != 'C/for_loop.c/CFG.txt':
                    #     continue
                    # print(f"正在处理文件: {file_path}")
                    json_content = extract_json_after_marker(file_path, marker)
                    # print(json_content)
                    if json_content is None:
                        # 如果没有找到标记，尝试直接解析整个文件
                        with open(file_path, 'r', encoding='utf-8') as f:
                            try:
                                json_content = json.load(f)
                                
                            except json.JSONDecodeError:
                                print(f"文件 {file_path} 不包含有效的JSON或已处理。")
                                continue
                    if json_content: 
                        try:
                            # 如果JSON内容是数组，将其包裹在一个新对象中
                            is_array = isinstance(json_content, list)
                            if is_array:
                                json_content = {"type": "Program", "value": "", "children": json_content}
                            formatted_json = json.dumps(json_content, indent=2)

                            # 替换原始文件中的JSON内容
                            updated_content = formatted_json + '\n'
                            with open(file_path, 'w', encoding='utf-8') as f:
                                f.write(updated_content)
                        except json.JSONDecodeError as e:
                            print(f"JSON解析错误在文件 {file_path}: {e}")

# 定义要遍历的目录
base_dirs = ['C', 'java-basics', 'python', 'solidity']
# 定义要处理的文件名
file_names = ['AST.txt', 'CFG.txt']
# 定义要查找的标记
marker = "Here's your output:"

process_files(base_dirs, file_names, marker)
# file_path = "/home/zhihao/huggingface/available/starchat-alpha/java-basics/innerclass.java/AST.txt"
# json_content = extract_json_after_marker(file_path, marker)