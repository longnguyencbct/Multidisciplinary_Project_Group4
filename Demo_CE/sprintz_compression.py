from pulsar import Function

class SprintZCompression(Function):
    def __init__(self):
        pass

    def process(self, input, context):
        return input  # For now, just pass the data unchanged
