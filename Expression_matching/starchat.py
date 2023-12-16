import json
import collections
import os
import json
import glob
from global_logger import Log

logger = Log.get_logger()
import os
from utils.tree_sitter_utils import split_functions, solidity_parser
import matplotlib.pyplot as plt
from utils.ExpressionVisitor import TypedVisitor
from transformers import AutoTokenizer, AutoModelForCausalLM
import torch
def read_expressions(file):
    code = open(file).read()
    tree = solidity_parser.parse(bytes(code,'utf8')) 
    type_visitor = TypedVisitor()
    type_visitor.walk(tree)
    check_expression = []
    vars = ["variable_declaration_statement", "expression_statement", "binary_expression", "call_expression", "variable_declaration_statement", "return_statement", "assignment_expression"]
    for v in vars:
        for ex in type_visitor.type_to_node[v]:
            et = ex.text.decode().strip()
            et = " ".join(et.split())
            check_expression.append(et)
    return check_expression

def codeModelMatcher(model, tokenizer, expr1, expr2, max_len=512):
    '''
    use NLP code models to compute the similarity between expr1 and expr2
    '''
    print('-------------')
    print(f"expr1 = {expr1}\n expr2 = {expr2}")
    expr1_tokens = [tokenizer.cls_token] + tokenizer.tokenize(expr1)[:max_len-2] +[tokenizer.eos_token]
    expr2_tokens = [tokenizer.cls_token] + tokenizer.tokenize(expr2)[:max_len-2] +[tokenizer.eos_token]
    expr1_tokens = [token for token in expr1_tokens if token is not None]
    expr2_tokens = [token for token in expr2_tokens if token is not None]

    print('-------------')
    print(f"expr1_tokens = {expr1_tokens}\n expr2_tokens = {expr2_tokens}")
    expr1_ids = tokenizer.convert_tokens_to_ids(expr1_tokens)
    expr2_ids = tokenizer.convert_tokens_to_ids(expr2_tokens)
    
    expr1_ids = torch.tensor(expr1_ids)[None, :].to(device)
    expr2_ids = torch.tensor(expr2_ids)[None, :].to(device)

    expr1_emb = model(expr1_ids)[0][:,0,:]
    expr2_emb = model(expr2_ids)[0][:,0,:]
    emb = torch.nn.functional.cosine_similarity(expr1_emb, expr2_emb)
    return emb.item()

import operator
def codebert_score(checkedequations, project_codes, output_dir):
    output_dir_path = f"{output_dir}/"
    for eq_name in checkedequations:
            eq_code = checkedequations[eq_name]
            res = {}
            os.makedirs(f"{output_dir_path}/{eq_name}", exist_ok=True)
            for sol_file in project_codes:
                expressions = project_codes[sol_file]
                for ex in expressions:
                    score = codeModelMatcher(model, tokenizer, eq_code, ex)
                    res[ex] =f'{score:.6f}'  #score
                sorted_d = dict( sorted(res.items(), key=operator.itemgetter(1),reverse=True))
                json.dump(sorted_d, open( os.path.join(f"{output_dir_path}/{eq_name}",f"{sol_file}_score.txt" ), "w" ), indent=4 )
           

def load_projects(project_folder, checkfile):
    res = {}
    filenames = [ l.strip() for l in open(checkfile, "r").readlines() ]
    print(filenames)
    for fpath in glob.glob(f"{project_folder}/**/*.sol", recursive=True):
        fname = os.path.basename(fpath)
        if fname in filenames:
            res[fname] = read_expressions(fpath)
    return res
    
def load_euqations(equations_file):
    code = open(equations_file).read()
    checkedeqs = split_functions(code, type="dict")
    res = {}
    for fn in checkedeqs:
        print(fn)
        code=" ".join(checkedeqs[fn].split("{", maxsplit=1)[1:]).strip()
        code=code[:-1]
        res[fn] = code
    return res


def process_solidity_chat(project_folder, euqations_file, checkfile, outfolder):
    pcode = load_projects( project_folder, checkfile )
    checkedequations = load_euqations(euqations_file)
    output_folder = os.path.join(outfolder, f"starchat/")
    os.makedirs(output_folder, exist_ok=True) 
    codebert_score(checkedequations, pcode, output_folder)



import argparse
debug = False
config_name = "starchat-alpha"
tokenizer = AutoTokenizer.from_pretrained(f'huggingface/hub/{config_name}', trust_remote_code=True)
model = AutoModelForCausalLM.from_pretrained(f'huggingface/hub/{config_name}', trust_remote_code=True)

if torch.cuda.is_available():
    device = torch.device("cuda")
    print("Running on the GPU")
else:
    device = torch.device("cpu")
    print("Running on the CPU")

model.to(device)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("-p", "--project", type=str, required=True, help="Project Folders")
    parser.add_argument("-e", "--equations", type=str, required=True, help="Equations")
    parser.add_argument("-c", "--checklist", type=str, required=True, help="checklist")
    parser.add_argument("-o", "--output", type=str, required=True, help="outputfolder")
    args = parser.parse_args()
    args = parser.parse_args()
    process_solidity_chat(args.project, args.equations, args.checklist, args.output)
   









    


