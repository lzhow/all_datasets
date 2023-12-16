from llm import get_answer
import pandas as pd

# 输出文件路径
import csv

summary = "summary.xlsx"

summary_concept = "summary_concept.xlsx"

# 读取Excel文件
df = pd.read_excel(summary)
# 提取question列
summary_questions = df['question'].tolist()


# 读取Excel文件
df = pd.read_excel(summary_concept)
# 提取question列
summary_concept_questions = df['question'].tolist()

output_file_path = 'gpt4_summary.csv'
with open(output_file_path, 'w', newline='', encoding='utf-8') as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(['question', 'answer'])  # 写入标题行

    for i, question in enumerate(summary_questions):
        question_with_prompt = question
        res = get_answer(question_with_prompt)  # 假设这是获取答案的函数

        with open(f'gpt4/no_concept/{i}.txt', 'w') as f:
          f.write(res)

        # 写入每一行数据
        writer.writerow([question, res])

# 重复同样的过程对summary_concept_questions处理
output_file_path_concept = 'gpt4_summary_concept.csv'

with open(output_file_path_concept, 'w', newline='', encoding='utf-8') as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(['question', 'answer'])  # 写入标题行

    for i, question in enumerate(summary_concept_questions):
        question_with_prompt = question
        res = get_answer(question_with_prompt)  # 假设这是获取答案的函数
        with open(f'gpt4/concept/{i}.txt', 'w') as f:
          f.write(res)
        # 写入每一行数据
        writer.writerow([question, res])

print(f"新数据已保存到 {output_file_path} 和 {output_file_path_concept}")
