# CodeUp-Llama-2-13b-chat-hf
from transformers import AutoTokenizer, AutoModelForCausalLM
import torch

def load_plm(model_name):
  # 确保使用的是AutoModelForMaskedLM来加载掩码语言模型
  tokenizer = AutoTokenizer.from_pretrained(f'/home/zhihao/.cache/huggingface/hub/{model_name}', trust_remote_code=True)
  model = AutoModelForCausalLM.from_pretrained(f'/home/zhihao/.cache/huggingface/hub/{model_name}', trust_remote_code=True)

  device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
  model.to(device)
  return tokenizer, model


tokenizer, model = load_plm('starchat-alpha')

# remember adding a language tag for better performance
# prompt = "# language: Python\n# write a bubble sort function\n"
def printAST():
  prompt = """
  You are a C Abstract Syntax Tree (AST) parser. I will give you a  C code file. You give me its 
          AST in Json. Each AST node only has three attributes, children, type and value.
          
          The input file is 
          ```
          #include <stdio.h>
  int main(void)
  {
      float arr[3]; 
      arr[0] = 1;
      int mul_arr[][COL] = {{1,2}, {3,4}};
      static int array[] = {12, 23, 54,};
      return (0);
  }
  
          ```
          
  """
  inputs = tokenizer.encode(prompt, return_tensors="pt").to(model.device)
  outputs = model.generate(inputs, max_length=2048, top_k=1)
  response = tokenizer.decode(outputs[0])
  
  with open("starchat-alpha_AST.txt", "w") as out:
    out.write(response)


def printCFG():
  prompt = """
  You are a control flow graph analyzer for C programs. I will give you a C program and you tell me its control flow graph in JSON format. The output format is json file, including nodes and edges. 
  Each statement can be presented as a node.
    The input file is 
    ```
    // c program to introduce the concept of arrays in the c programming language
#include <stdio.h>
#include <stdlib.h>

int main(void)
{
    int arr[3]; // [] [] [] allocates 3 memory spaces for 3 integers in contagion memery addresses
    arr[0] = 1;
    float float_array[30]; // declares an array of 30 floats
    int mul_arr[][COL] = {{1,2}, {3,4}};
    static int array[] = {12, 23, 54, 65, 23, 45};

    return (0);
}

    ```
    
          
  """
  inputs = tokenizer.encode(prompt, return_tensors="pt").to(model.device)
  outputs = model.generate(inputs, max_length=2048, top_k=1)
  response = tokenizer.decode(outputs[0])
  
  with open("starchat-alpha_CFG.txt", "w") as out:
    out.write(response)


printAST()
printCFG()
