import os

from llm import get_answer

if __name__ == '__main__':
    for f in os.listdir("./code"):
        # f为slice.py
        fpath = os.path.join("./code", f)
        
        print(fpath)
        try:
            code = open(fpath, "r").read()
            question = """
                You are a Solidity Abstract Syntax Tree (AST) parser. I will give you a Java class file. You give 
                me its AST in Json format. Each AST node only has three attributes, children, type and value.

                The input file is 
                    ```
                """ + code + """
                ```
            """
            dir_name = f"chatgpt/AST/{f.split('.')[0]}"
            os.makedirs(dir_name, exist_ok=True)

            answer = get_answer(question)

            with open(os.path.join(dir_name, "my_answer.txt"), "w") as out:
                out.write(answer)
        except Exception as e:
            print(f"处理文件 {fpath} 时发生错误: {e}")
