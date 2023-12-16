import os

if __name__ == "__main__":

    for f in os.listdir("./code"):
      fpath = os.path.join("./code", f)
      
      
      try:

        # 
        dir_name = f"chatgpt/AST/{f.split('.')[0]}"
        os.makedirs(dir_name, exist_ok=True)

        with open(os.path.join(dir_name, "gpt4_answer.txt"), "w") as out:
          # do nothing
          print(fpath)
      
      except Exception as e:
          print(f" {fpath} : {e}")
