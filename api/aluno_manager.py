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
        Turma.codigo_turma,
        Turma.id_turma 
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


@aluno_blueprint.route('/confirmar_presenca/<string:id_aluno>/<string:id_turma>', methods=['POST']) #TO-DO: relacionar aluno à turma
def confirmar_presenca(id_aluno:str, id_turma:str):
    cursor = conexao.cursor()
    comando = f"""INSERT INTO Presencas (id_aula, id_aluno, tempo_presenca)
                SELECT A.id_aula, {id_aluno}, NOW()
                FROM Aula A
                INNER JOIN Inscricao I ON A.id_turma = I.id_turma
                WHERE I.id_aluno = {id_aluno} AND A.id_turma = {id_turma} AND A.situacao = 1
                ORDER BY A.data_hora_inicio ASC
                LIMIT 1;"""
    cursor.execute(comando)
    conexao.commit()
    cursor.close()
    return jsonify({"status": "success", "message": "presenca registrada"}), 200


def consultaAluno(matricula, password):
    cursor = conexao.cursor()
    comando = f'SELECT * from aluno WHERE matricula = "{matricula}" AND senha = "{password}"'
    cursor.execute(comando)
    resultado = cursor.fetchall()
    cursor.close()
    return resultado
