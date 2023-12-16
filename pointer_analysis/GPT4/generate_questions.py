import os

from llm import get_answer

if __name__ == "__main__":
    for f in os.listdir("chatgpt/"):
        fpath = os.path.join("chatgpt/", f, "question.md")
        question = open(fpath, "r").read()
        print(question)

        # answer = get_answer(question)
        # #
        # with open(f"chatgpt/{f}/my_answer.txt", "w") as out:
        #     out.write(answer)
