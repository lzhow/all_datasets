import os
from llm import get_answer

flag = 0
for f in sorted(os.listdir('chatgpt')):
    file = os.path.join('chatgpt', f, 'question.md')
    with open(file) as fp:
        ques = fp.read()
    ques = ques + """\nYou must only output the JSON format.And here's an example: 
{
  "a": ["k"],
  "b": []
}
"""
    if f == "swap4-contextindirect":
        flag = 1
    if flag == 0:
        continue
    # print(f)
    ans = get_answer(ques)
    with open(os.path.join('chatgpt', f, 'gpt4_answer.md'), 'w') as fp:
        fp.write(ans)
