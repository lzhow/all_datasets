from parser_imp_js.code2jsonTree import getTreeJson
from parser_imp_js.tree_matcher import  build_express_tree
import collections
from utils import log
import re
import json
logger=log.setup_custom_logger("Check Finance Models")

def removeTypeConversion(code):
    code = code.replace("uint", "")
    return code

def removecaller(code):
    result1 = re.findall(r'\w+(?:\.\w+)+\(', code)
    for r in result1:
        r=r.replace("(", "")
        rs = r.split(".")[-1]
        code = code.replace(r, rs)
    return code


import os
import glob
import json
import re
import collections

def collect_equations(project_chatgpt):
    euqations_similar = collections.defaultdict(list)
    for answer_file in glob.glob(f"{project_chatgpt}/**/answer_*.md", recursive=True):
        try:
            content = open(answer_file).read()
            # Search for the word in the input string
            match = re.search(r'"Reason":', content)
            if match:
                start_index = match.start()
                content = content[:start_index].strip()[:-1] + "}"
                #print(content)
            #content = extract_json(content) #content[:last_comma_index+1]
            answer = json.loads(content)
            if "similar_expressions" not in answer:
                continue
            expressions = answer["similar_expressions"]
            if len(expressions) == 0:
                continue
            folder = os.path.dirname(answer_file)
            info_file = os.path.join(folder, "info.json")
            data = json.load(open(info_file))
            equation = data["eq"]
            equation_name = data["eid"]
            file_name = data["file"]
            # for ex in expressions:
            #     matched_funcation = ex["function_name"]
            #     matched_expression = ex["expression"]
            euqations_similar[equation_name].append( {"equation": equation, "equation_name":equation_name, "expressions_matched":expressions, "file_name":file_name} )
        except:
            print(f"Not Json {answer_file}")
    return euqations_similar

def process_code(chat_gpt_output_file):
    data = collect_equations(chat_gpt_output_file) #json.load(open(chat_gpt_output_file))
    res ={}
    print(data.keys())
    for fn_name in data:
        print(fn_name)
        statements = data[fn_name]
        res[fn_name] = {"check_eq":[]}
        for egg in statements:
            finance_eq = egg["equation"] 
            finance_eq = finance_eq.split("=")[-1]
            finance_eq = finance_eq.replace(";", "")
            finance_eq = finance_eq.replace("\n", "")
            expressions_matched = egg["expressions_matched"] 
            file_name = egg["file_name"]
            if "finance_G" not in res[fn_name]:
                finance_expression = getTreeJson( finance_eq )
                try:
                    finance_G = build_express_tree(finance_expression)
                    res[fn_name]["finance_G"] = {"G":finance_G, "JS":finance_expression, "expression":finance_eq}
                except Exception as e:
                    logger.info(f"== {finance_eq}")
                    assert False
            for matched_egg in expressions_matched:
                checked_fn = matched_egg["function_name"]
                checked_expression = matched_egg["expression"]
                checked_expression = checked_expression.replace(";", "")
                checked_expression = checked_expression.split("=")[-1]
                checked_expression = checked_expression.replace("\n", "")
                checked_expression = checked_expression.replace("return", "")
                cleanedchecked_expression = removecaller(checked_expression)
                cleanedchecked_expression = removeTypeConversion(cleanedchecked_expression)
                cleanedchecked_expression = cleanedchecked_expression.split("=")[-1]
                try:
                    expressionJS = getTreeJson( cleanedchecked_expression )
                    checked_G = build_express_tree(expressionJS)
                    res[fn_name]["check_eq"].append({"G":checked_G, "JS":expressionJS, "expression":checked_expression, "function_name":checked_fn, "file_name":file_name})
                except Exception as e:
                    logger.info(f"{matched_egg}")
     
    return res
    


import argparse
import pickle
import os
if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("-i", "--input", type=str, help="chatgpt result file")
    parser.add_argument("-o", "--output", type=str, help="pickle file with Graph Type")    
    args = parser.parse_args()
    data = process_code(args.input)
    #print(os.getcwd())
    pickle.dump(data, open(args.output, "wb"))


