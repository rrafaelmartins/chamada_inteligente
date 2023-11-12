from flask import Flask
from flask_cors import CORS
from login_manager import login_blueprint
from aluno_manager import aluno_blueprint
from prof_manager import professor_blueprint

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


app.register_blueprint(login_blueprint)
app.register_blueprint(aluno_blueprint)
app.register_blueprint(professor_blueprint)

CORS(app)
""" ... """

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)

