import os

from datasets.llm import get_answer


def generate(file):
    f = os.path.join("./code", file)
    code = open(f, "r").read()
    question = """You are a C Abstract Syntax Tree (AST) parser. I will give you a  C code file. You give me its 
    AST in Json. Each AST node only has three attributes, children, type and value.

    The input file is """ + \
               """
    ```
    """ + code + """
    ```
    """
    os.makedirs(f"chatgpt_c_tutorial/{file}", exist_ok=True)
    with open(f"chatgpt_c_tutorial/{file}/input.txt", "w") as out:
        out.write(question)

    answer = get_answer(question)

    with open(f"chatgpt_c_tutorial/{file}/my_answer.txt", "w") as out:
        out.write(answer)


if __name__ == "__main__":
    generate("union.c")
