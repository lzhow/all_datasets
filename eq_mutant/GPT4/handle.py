import os

sum = 0
for file in range(200):
    with open(f'zeroshot/{file}.txt', 'r') as f:
        ans = f.read()
    if ans.lower().startswith("no"):
        sum = sum + 1

print(sum)