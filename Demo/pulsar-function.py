from pulsar import Function
import json

class Chat(Function):
    def __init__(self):
        pass

def process(self,input,context):
    logger=context.get_logger()
    logger.info("Message Content: {0}".format(input))
    msg_id = context.get_message_id()
    row={}
    row['id']=str(msg_id)
    json_string=json.dumps(row)
    return json_string
