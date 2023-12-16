import csv
import pandas as pd
from transformers import AutoTokenizer, AutoModelForCausalLM
import torch
import os
import json

tokenizer = None
model = None

def load_plm(model_name):
  # 确保使用的是AutoModelForMaskedLM来加载掩码语言模型
  tokenizer = AutoTokenizer.from_pretrained(f'/home/zhihao/.cache/huggingface/hub/{model_name}', trust_remote_code=True)
  model = AutoModelForCausalLM.from_pretrained(f'/home/zhihao/.cache/huggingface/hub/{model_name}', trust_remote_code=True)

  device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
  model.to(device)
  return tokenizer, model


def ensure_directory_exists(filepath):
    # 分离文件路径的目录部分
    directory = os.path.dirname(filepath)
    # 如果目录不存在，则创建它（包括任何必需的中间目录）
    if not os.path.exists(directory):
      os.makedirs(directory, exist_ok=True)


def get_answer(code):
  inputs = tokenizer.encode(code, return_tensors="pt").to(model.device)
  outputs = model.generate(inputs, max_length=2048)
  response = tokenizer.decode(outputs[0])

  return response


def modify_name():
    base_path = "/home/zhihao/ChatGPT_analysis_latest/all_datasets/pointer/chatgpt"
    for f in os.listdir(base_path):
        fpath = os.path.join(base_path, f)
        answer_path = fpath + "/question.mdstarchat.txt"
        os.rename(answer_path, fpath + "/starchat.txt")


def update_csv_status(filename, new_status):
    rows = []
    with open(status_file, 'r', newline='', encoding='utf-8') as file:
        reader = csv.reader(file)
        for row in reader:
            if row[0] == filename:
                row[1] = new_status
            rows.append(row)

    with open(status_file, 'w', newline='', encoding='utf-8') as file:
        writer = csv.writer(file)
        writer.writerows(rows)


def do_nothing():
  return

def extract_json_between_markers(file_path, start_marker, end_marker):
    try:
        with open(file_path, 'r', encoding='utf-8') as file:
            content = file.read()
        if json.loads(content) is not None:
          
          name = file_path.split('/')[-2]
          update_csv_status(name, 1)
          return json.loads(content)
    except Exception as e:
        # print(f"Error processing file {file_path}: {e}")
        do_nothing()

    try:
        with open(file_path, 'r', encoding='utf-8') as file:
            content = file.read()
        
        # 查找开始标记后的JSON数据
        start_index = content.find(start_marker)
        if start_index == -1:
            return None

        # 查找结束标记
        end_index = content.find(end_marker, start_index + len(start_marker))
        if end_index == -1:
            return None

        # 提取标记之间的内容
        json_data = content[start_index + len(start_marker):end_index]
        print(json_data)
        
        name = file_path.split('/')[-2]
        update_csv_status(name, 1)
        return json.loads(json_data)
    except json.JSONDecodeError as e:
        print(f"JSON解析错误在文件 {file_path}: {e}")
        # 修改csv的状态
        name = file_path.split('/')[-2]
        update_csv_status(name, 0)
        return None
    except Exception as e:
        print(f"错误处理文件 {file_path}: {e}")
        return None


def run_model():
    base_path = "/home/zhihao/ChatGPT_analysis_latest/all_datasets/pointer/chatgpt"

    # 如果状态文件不存在，创建一个新的CSV文件
    if not os.path.exists(status_file):
        file_status = pd.DataFrame({'filename': os.listdir(base_path), 'processed': [0]*len(os.listdir(base_path))})
        file_status.to_csv(status_file, index=False)  # 保存为CSV文件
    else:
        file_status = pd.read_csv(status_file)  # 读取CSV文件

    for index, row in file_status.iterrows():
        if row['processed'] == 1:  # 如果文件已经处理过，跳过
            continue

        f = row['filename']
        fpath = os.path.join(base_path, f)
        question_path = fpath + "/question.md"
        print(fpath)
        question = open(question_path, "r").read()

        answer = get_answer(question)

        with open(fpath + "/starchat.txt", "w") as out:
            out.write(answer)

        file_status.at[index, 'processed'] = 1  # 更新文件状态为已处理

    # 保存更新后的状态到CSV文件
    file_status.to_csv(status_file, index=False)


# 
# modify_name()
# 测试代码
def format_output():
    base_path = "/home/zhihao/ChatGPT_analysis_latest/all_datasets/pointer/chatgpt"
    for f in os.listdir(base_path):
        fpath = os.path.join(base_path, f)
        file_path = fpath + "/starchat.txt"
        start_marker = "each pointer points to:"
        end_marker = "<|end|>"
        json_content = extract_json_between_markers(file_path, start_marker, end_marker)
        if json_content is not None:
          # print(json_content)
          with open(file_path, 'w', encoding='utf-8') as f:
            output = json.dumps(json_content, indent=2)
            f.write(output)


status_file = "file_status.csv"  # 更改文件扩展名为.csv
# tokenizer, model = load_plm('starchat-alpha')
# run_model()
format_output()