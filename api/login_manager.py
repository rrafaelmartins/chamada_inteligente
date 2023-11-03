#TO-DO response tem que ser em formato JSON
from flask import request, jsonify
from app import  app
from comandos_bando import conexao
from flask_cors import CORS
from app import app
import mysql.connector

CORS(app)
""" ... """

conexao = mysql.connector.connect(
    host='localhost',
    user='root',
    password='xd3ibcx3',
    database='chamadainteligente'
)


@app.route('/Login', methods=['POST'])
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


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
