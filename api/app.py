from flask import Flask
from flask_cors import CORS
from login_manager import login_blueprint
from aluno_manager import aluno_blueprint
from prof_manager import professor_blueprint
import socket
from dotenv import dotenv_values, set_key

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


def get_host_ip():
    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        s.connect(("8.8.8.8", 80))
        ip = s.getsockname()[0]
        s.close()
        return ip
    except Exception as e:
        return "127.0.0.1" 
    

def write_ip_to_env(ip, file_path='chamada_inteligente/.env'):
    url_exists = False

    updated_lines = []

    with open(file_path, 'r') as file:
        lines = file.readlines()
        for line in lines:
            if line.startswith('URL='):
                updated_lines.append(f'URL={ip}:5000\n')
                url_exists = True
            else:
                updated_lines.append(line)
    
    if not url_exists:
        updated_lines.append(f'URL={ip}:5000\n')

    with open(file_path, 'w') as file:
        file.writelines(updated_lines)

url = get_host_ip()
write_ip_to_env(url)


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)