

from transformers import AutoTokenizer, AutoModelForCausalLM
import torch
import os

def load_plm(model_name):
  # 确保使用的是AutoModelForMaskedLM来加载掩码语言模型
  tokenizer = AutoTokenizer.from_pretrained(f'/home/zhihao/.cache/huggingface/hub/{model_name}', trust_remote_code=True)
  model = AutoModelForCausalLM.from_pretrained(f'/home/zhihao/.cache/huggingface/hub/{model_name}', trust_remote_code=True)

  device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
  model.to(device)
  return tokenizer, model

tokenizer, model = load_plm('starchat-alpha')

instruction_AST = """
  
  You are an Abstract Syntax Tree (AST) parser. I will give you a code file. You give me its 
          AST in Json. Each AST node only has three attributes, children, type and value."""

instruction_CFG = """
  You are a control flow graph analyzer for programs. I will give you a program and you tell me its control flow graph in JSON format. The output format is json file, including nodes and edges. 
    Each statement can be presented as a node. Each node has three attributes: id,type and label; Each edge contains two attributes: source, target.
"""

instruction_CG = """
  You are a call graph analyzer for programs. I will give you a program and you tell me its call graph. The output format is json file, including nodes and edges.
"""

def get_prompt(instruction, code):
  prompt = f"""
    {instruction}\n
    Here's your input file: {code}\n
    Here's your output:\n
  """
  return prompt


def getAST(code):
  inputs = tokenizer.encode(get_prompt(instruction_AST, code), return_tensors="pt").to(model.device)
  outputs = model.generate(inputs, max_length=2048)
  response = tokenizer.decode(outputs[0])

  return response


def getCFG(code):
  inputs = tokenizer.encode(get_prompt(instruction_CFG, code), return_tensors="pt").to(model.device)
  outputs = model.generate(inputs, max_length=2048)
  response = tokenizer.decode(outputs[0])

  return response


def getCG(code):
  inputs = tokenizer.encode(get_prompt(instruction_CG, code), return_tensors="pt").to(model.device)
  outputs = model.generate(inputs, max_length=2048)
  response = tokenizer.decode(outputs[0])

  return response


def ensure_directory_exists(filepath):
    # 分离文件路径的目录部分
    directory = os.path.dirname(filepath)
    # 如果目录不存在，则创建它（包括任何必需的中间目录）
    if not os.path.exists(directory):
      os.makedirs(directory, exist_ok=True)



if __name__ == "__main__":
  base_path = "/home/zhihao/ChatGPT_analysis_latest/all_datasets/"
  language_path = ["C/code", "java-basics/code", "python/code", "solidity/code"]
  # language_path = ["solidity/code"]
  for language in language_path:
    path = os.path.join(base_path, language)
    for f in os.listdir(path):
        fpath = os.path.join(path, f)
        print(fpath)

        lan = language.split('/')[0]
        # ignore = [
        #    "/home/zhihao/ChatGPT_analysis_latest/all_datasets/solidity/code/error.sol",
        #    "/home/zhihao/ChatGPT_analysis_latest/all_datasets/solidity/code/whileloopdo.sol"
        # ]
        # if fpath in ignore:
        #   continue
        code = open(fpath, "r").read()
        os.makedirs(f"{lan}/{f}", exist_ok=True)

        if language != "C/code":
          
          answer = getAST(code)
          with open(f"{lan}/{f}/AST.txt", "w") as out:
            out.write(answer)

          answer = getCFG(code)
          with open(f"{lan}/{f}/CFG.txt", "w") as out:
            out.write(answer)

        answer = getCG(code)
        with open(f"{lan}/{f}/CG.txt", "w") as out:
            out.write(answer)