import os

from llm import get_answer

# 
base_dirs = ['C', 'java', 'python', 'solidity']
original_cwd = os.getcwd()

for base_dir in base_dirs:
    subdir_path = os.path.join('.', base_dir)
    os.chdir(subdir_path)

    for f in os.listdir("./code"):
        fpath = os.path.join("./code", f)
        ignores = [
        ]
        print(f)
        if f in ignores:
            continue
        code = open(fpath, "r").read()
        question = """You are a call graph analyzer for programs. I will give you a program 
        and you tell me its call graph. Here's an example output:
        ```
        {
          "nodes": [
            {
              "id": "main",
              "label": "main"
            },
            {
              "id": "readin",
              "label": "readin"
            },
            {
              "id": "printEmp",
              "label": "printEmp"
            },
            {
              "id": "search",
              "label": "search"
            },
            {
              "id": "addEmployee",
              "label": "addEmployee"
            }
          ],
          "edges": [
            {
              "from": "main",
              "to": "readin"
            },
            {
              "from": "main",
              "to": "search"
            },
            {
              "from": "search",
              "to": "addEmployee"
            },
            {
              "from": "main",
              "to": "printEmp"
            }
          ]
        }
        ```

        The input file is """ + \
                   """
        ```
        """ + code + """
        ```
        """
        os.makedirs(f"chatgpt/{f}", exist_ok=True)
        # with open(f"chatgpt/{f}/input.txt", "w") as out:
        #     # do something
        #     out.write(question)
        # with open(f"chatgpt/{f}/gpt4_answer.txt", "w") as out:
        #     # do something
        #     print('')
        response = get_answer(question)
        with open(f"chatgpt/{f}/my_answer.txt", "w") as out:
            out.write(response)

    os.chdir(original_cwd)
