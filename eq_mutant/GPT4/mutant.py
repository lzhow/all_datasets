import pandas as pd
from llm import get_answer
import os

# 
file_few = pd.read_excel("chatgpt4_fewshot_predictions.xlsx")
questions_few = file_few['question']
os.makedirs('questions_few', exist_ok=True)
for i, question in enumerate(questions_few):
    with open(f'questions_few/{i}.txt', 'w') as f:
        f.write(question)

file_zero = pd.read_excel("chatgpt4_zeroshot_predictions.xlsx")
questions_zero = file_zero['question']
os.makedirs('questions_zero', exist_ok=True)
for i, question in enumerate(questions_zero):
    with open(f'questions_zero/{i}.txt', 'w') as f:
        f.write(question)

# predict  isCorrect
file_few['predict'] = ""
file_few['isCorrect'] = ""
# 
file_few.to_excel("chatgpt4_fewshot_predictions.xlsx", index=False)

file_zero['predict'] = ""
file_zero['isCorrect'] = ""
# 
file_zero.to_excel("chatgpt4_zeroshot_predictions.xlsx", index=False)


# question = "You are a mutant test analysis expert\n" + questions_few[120]
#
# get_answer(question)

# for i, question in enumerate(questions_zero):
#     if i!=151:
#         continue
#     print('------------------------')
#     print(f"question:{i}")
#
#     with open(f'questions_zero/{i}.txt', 'r') as f:
#         question = f.read()
#     ans = get_answer(question)
#
#     with open(f'zeroshot/{i}.txt', 'w') as f:
#         f.write(ans)
#
#
for i, question in enumerate(questions_few):
    if i != 151:
        continue
    print('------------------------')
    print(f"question:{i}")
    content = file_few.iloc[i].copy()
    ans = get_answer(question)

    with open(f'fewshot/{i}.txt', 'w') as f:
        f.write(ans)
