from flask import request, jsonify, Blueprint
import mysql.connector
import os
from dotenv import load_dotenv
load_dotenv()
password = os.getenv('PASSWORD')

aluno_blueprint = Blueprint('aluno_blueprint', __name__)

conexao = mysql.connector.connect(
    host='localhost',
    user='root',
    password=f'{password}',
    database='chamadainteliteste'
)

# Placeholders. Na realidade, isso virá do banco de dados
turmas = [
    {'codigo': 'TCC00123', 'nome': 'Introdução à Programação', 'turma': 'Turma A1 - 2023.2'},
    {'codigo': 'TCC00456', 'nome': 'Banco de Dados', 'turma': 'Turma B1 - 2023.2'}
]

presencas = {}  #placeholder

@aluno_blueprint.route('/get_turmas_aluno/<string:id_aluno>', methods=['GET'])
def get_turmas_aluno(id_aluno:str):
    cursor = conexao.cursor()
    comando = f"""
    SELECT 
        Disciplina.nome, 
        Turma.codigo_turma 
    FROM 
        Inscricao
    JOIN 
        Turma ON Inscricao.id_turma = Turma.id_turma
    JOIN 
        Disciplina ON Turma.id_disciplina = Disciplina.id_disciplina
    WHERE 
        Inscricao.id_aluno = {id_aluno};

    """
    cursor.execute(comando)
    resultado = cursor.fetchall()
    print(resultado)
    cursor.close()
    return jsonify(resultado), 200

@aluno_blueprint.route('/confirmar_presenca/<string:codigo_turma>', methods=['POST']) #TO-DO: relacionar aluno à turma
def confirmar_presenca(codigo_turma):
    presence_status = request.json.get('presence')
    presencas[codigo_turma] = presence_status
    return jsonify({"status": "success", "message": f"Presence for {codigo_turma} marked as {presence_status}"}), 200


def consultaAluno(matricula, password):
    cursor = conexao.cursor()
    comando = f'SELECT * from aluno WHERE matricula = "{matricula}" AND senha = "{password}"'
    cursor.execute(comando)
    resultado = cursor.fetchall()
    cursor.close()
    return resultado

if __name__ == '__main__':
    app.run(debug=True)
