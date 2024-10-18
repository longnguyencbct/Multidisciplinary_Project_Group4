from pulsar import Function

class SprintZCompression(Function):
    def __init__(self):
        pass

    def process(self, input, context):
        logger = context.get_logger()
        logger.info(f"Received message: {input}")
        return input  # Just pass through for now
