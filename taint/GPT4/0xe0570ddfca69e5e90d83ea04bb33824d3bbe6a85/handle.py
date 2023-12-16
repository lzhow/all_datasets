import json

dir = ['contract/dp', 'contract/taint', 'function/dp', 'function/taint']

for d in dir:
    with open(f'{d}/ans.txt', 'r') as f:
        content = json.load(f)

    for i in range(len(content)):
        with open(f'{d}/{i}.txt', 'w') as f:
            f.write(f'{content[i]}\n')
