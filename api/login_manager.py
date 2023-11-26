from flask import request, jsonify, Blueprint
import mysql.connector
import os
from dotenv import load_dotenv
load_dotenv()
password = os.getenv('PASSWORD')

login_blueprint = Blueprint('login_blueprint', __name__)

conexao = mysql.connector.connect(
    host='localhost',
    user='root',
    password=f'{password}',
    database='intelitestenovo'
)

@login_blueprint.route('/LoginAluno', methods=['POST'])
def login():
    matricula = request.json.get('matricula')
    password = request.json.get('senha')
    response = consultaAluno(matricula, password)
    if response == []:
        return jsonify({"status": "error", "message": "Invalid credentials"}), 401
    else:
        return jsonify(response)
    
@login_blueprint.route('/LoginProfessor', methods=['POST'])
def loginProfessor():
    matricula = request.json.get('matricula')
    password = request.json.get('senha')
    response = consultaProfessor(matricula, password)
    if response == []:
        return jsonify({"status": "error", "message": "Invalid credentials"}), 401
    else:
        return jsonify(response)

def consultaAluno(matricula, password):
    cursor = conexao.cursor()
    comando = f'SELECT * from aluno WHERE matricula = "{matricula}" AND senha = "{password}"'
    cursor.execute(comando)
    resultado = cursor.fetchall()
    cursor.close()
    return resultado

def consultaProfessor(matricula, password):
    cursor = conexao.cursor()
    comando = f'SELECT * from professor WHERE matricula = "{matricula}" AND senha = "{password}"'
    cursor.execute(comando)
    resultado = cursor.fetchall()
    cursor.close()
    return resultado