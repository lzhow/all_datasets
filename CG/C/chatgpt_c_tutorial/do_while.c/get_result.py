import os

from datasets.llm import get_answer

if __name__ == "__main__":
    question = """
        You are a C Abstract Syntax Tree (AST) parser. I will give you a  C code file. You give me its 
        AST in Json. Each AST node only has three attributes, children, type and value.
        
        The input file is 
        ```
        #include <stdio.h>

int main(void)
{
    int c = 0;
    do {
        printf("%d\n", c);
    } while (c++ < 5);
}
        ```
        
        """

    answer = get_answer(question)

    with open("my_answer2.txt", "w") as out:
        out.write(answer)
