import os


for f in os.listdir("./recurisive"):
    fpath = os.path.join("./recurisive", f)
    code=open(fpath, "r").read()
    question = """You are a call graph analyzer for Java programs. I will give you a Java program and you tell me its call graph. The output format is json file, including nodes and edges.
    
    The input file is """ + \
    """
    ```
    """ + code + """
    ```
    """
    os.makedirs(f"chatgpt/{f}", exist_ok=True)
    with open(f"chatgpt/{f}/input.txt", "w") as out:
        out.write(question)
    with open(f"chatgpt/{f}/answer.txt", "w") as out:
        out.write("")