import os
from llm import get_answer

if __name__ == "__main__":

    for f in os.listdir("./code"):
        fpath = os.path.join("./code", f)
        
        print(fpath)
        try:
            with open(fpath, "r", encoding="utf-8") as file:
                code = file.read()

            question = """
                You are a C Abstract Syntax Tree (AST) parser. I will give you a C code file. You give me its 
                AST in Json. Each AST node only has three attributes, children, type and value.

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
            print(f" {fpath} : {e}")
