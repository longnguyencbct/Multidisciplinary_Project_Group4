from pulsar import Function

class SprintZCompression(Function):
    def __init__(self):
        pass

    def process(self, input, context):
        # Check if context is None
        if context is not None:
            logger = context.get_logger()
            logger.info(f"Received message: {input}")
        else:
            print(f"Received message (No logger): {input}")
        return input  # Just pass through for now
