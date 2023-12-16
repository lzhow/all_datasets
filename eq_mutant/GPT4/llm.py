import openai
import os
from dotenv import load_dotenv, find_dotenv

from langchain.chat_models import ChatOpenAI
from langchain.prompts import ChatPromptTemplate
from langchain.schema import HumanMessage


def get_answer(ques):
    _ = load_dotenv(find_dotenv())  # read local .env file
    openai.api_key = os.environ['OPENAI_API_KEY']
    # openai.api_base = os.environ['OPENAI_ENDPOINT']

    chat = ChatOpenAI(
        model_name="gpt-4",
        temperature=0.0
    )
    msg = [HumanMessage(content=ques)]
    ans = chat(msg)
    print(ans.content)
    return ans.content
