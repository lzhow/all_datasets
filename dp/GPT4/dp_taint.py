import os
import json
from llm import get_answer
import time


def write_file(content, line=True):
    with open('myapp.log', 'a') as file:
        file.write(content)
        if line:
            file.write('\n')


def handle(output_dir, file_name):
    os.makedirs(output_dir, exist_ok=True)
    os.makedirs(output_dir + '/dp', exist_ok=True)
    os.makedirs(output_dir + '/taint', exist_ok=True)

    with open(file_name, 'r') as f:
        contents = json.load(f)

    dp = contents[0]
    taint = contents[1]

    write_file("dp")
    for i, dp_item in enumerate(dp):
        write_file(f'{i} ', False)
        prompt = dp_item[1][0] + dp_item[1][1]

        attempt = 0
        while attempt <= 3:
            try:
                res = get_answer(prompt)
                break
            except Exception as e:
                write_file(f'Error on dp {i}: {e}. Retrying after 10 seconds...')
                time.sleep(10)
                attempt += 1

        with open(f'{output_dir}/dp/{i}.txt', 'w') as f:
            f.write(res)

    write_file("taint")
    for i, taint_item in enumerate(taint):
        write_file(f'{i} ', False)
        prompt = taint_item[1][0] + taint_item[1][1]

        attempt = 0
        while attempt <= 3:
            try:
                res = get_answer(prompt)
                break
            except Exception as e:
                write_file(f'Error on taint {i}: {e}. Retrying after 10 seconds...')
                time.sleep(10)
                attempt += 1

        with open(f'{output_dir}/taint/{i}.txt', 'w') as f:
            f.write(res)


# The file processing part is not executed here to avoid performing file operations.
# The code is ready to be used in an environment where the `llm.get_answer` function and the file system are accessible.


# File paths
for file_dir in sorted(os.listdir('.')):
    if not os.path.isdir(file_dir):
        continue

    if file_dir in ['0x1887118e49e0f4a78bd71b792a49de03504a764d', '0x3d5bc3c8d13dcb8bf317092d84783c2697ae9258', '0x4e68ccd3e89f51c3074ca5072bbac773960dfa36' ,'0x7efaef62fddcca950418312c6c91aef321375a00']:
        continue

    write_file('---------------------------------')
    write_file(file_dir)

    path_contract = f'{file_dir}/formatted/facts_contract_sample_50.json'
    path_function = f'{file_dir}/formatted/facts_function_sample_50.json'


    handle(f"{file_dir}/contract", path_contract)

    handle(f"{file_dir}/function", path_function)


# res = get_answer("hello")
# print(res)
