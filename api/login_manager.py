#TO-DO response tem que ser em formato JSON
from flask import request, jsonify, Blueprint
from comandos_bando import conexao
import mysql.connector


login_blueprint = Blueprint('login_blueprint', __name__)

conexao = mysql.connector.connect(
    host='localhost',
    user='root',
    password='xd3ibcx3',
    database='chamadainteligente'
)


@login_blueprint.route('/Login', methods=['POST'])
def login():
    matricula = request.json.get('matricula')
    password = request.json.get('senha')
    response = consultaAluno(matricula, password)
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
