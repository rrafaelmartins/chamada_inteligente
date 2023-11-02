from flask import Flask

class FlaskSingleton:
    instance = None
    def __init__(self):
        if FlaskSingleton.instance != None:
            raise Exception("This class is a singleton.")
        else:
            FlaskSingleton.instance = Flask(__name__)

    @staticmethod
    def get_instance():
        if FlaskSingleton.instance == None:
            FlaskSingleton()
        return FlaskSingleton.instance
    
app = FlaskSingleton.get_instance()
