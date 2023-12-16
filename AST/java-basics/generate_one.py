import os

from datasets.llm import get_answer


def generate(files):
    for file in files:
        f = os.path.join("./java_tutorial", file)
        code = open(f, "r").read()
        question = """You are a Java Abstract Syntax Tree (AST) parser. I will give you a Java class file. You give 
            me its AST in Json format. Each AST node only has three attributes, children, type and value.
    
        The input file is """ + \
                   """
        ```
        """ + code + """
        ```
        """
        os.makedirs(f"chatgpt_java_tutorial/{file}", exist_ok=True)
        with open(f"chatgpt_java_tutorial/{file}/input.txt", "w") as out:
            out.write(question)

        answer = get_answer(question)

        with open(f"chatgpt_java_tutorial/{file}/my_answer.txt", "w") as out:
            out.write(answer)


if __name__ == "__main__":
    generate(["generics.java", "try_catch.java"])
