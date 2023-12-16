import os
for file_dir in sorted(os.listdir('chatgpt')):
  ans_file = f'chatgpt/{file_dir}/gpt4_answer.md'

  with open(ans_file, 'r') as f:
    content = f.read()
  content = content.replace('```json\n', '')
  content = content.replace('```', '')

  with open(ans_file, 'w') as f:
    f.write(content)
