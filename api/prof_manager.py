from flask import request, jsonify, Blueprint
from comandos_bando import conexao
import mysql.connector
from comandos_bando import consultaProfessor

import os
from dotenv import load_dotenv
load_dotenv()
password = os.getenv('PASSWORD')

professor_blueprint = Blueprint('professor_blueprint', __name__)

conexao = mysql.connector.connect(
    host='localhost',
    user='root',
    password=f'{password}',
    database='chamadainteliteste'
)



@professor_blueprint.route('/get_turmas_prof/<string:id_professor>', methods=['GET'])
def get_turmas(id_professor: str):
    cursor = conexao.cursor()
    comando = f'select nome, codigo_turma, id_turma FROM Disciplina JOIN Turma ON Turma.id_disciplina = Disciplina.id_disciplina WHERE id_professor = {id_professor}; '
    cursor.execute(comando)
    resultado = cursor.fetchall()
    print(resultado)
    cursor.close()
    return jsonify(resultado), 200


@professor_blueprint.route('/get_nomedisciplina_by_turmaid/<string:id_turma>', methods=['GET'])
def get_nomedisciplina_by_turmaid(id_turma: str):
    cursor = conexao.cursor()
    comando = f"""SELECT Disciplina.nome
                FROM Turma
                JOIN Disciplina ON Turma.id_disciplina = Disciplina.id_disciplina
                WHERE Turma.id_turma = {id_turma};"""
    cursor.execute(comando)
    resultado = cursor.fetchall()
    print(resultado)
    cursor.close()
    return jsonify(resultado), 200


@professor_blueprint.route('/get_historico/<string:id_turma>', methods=['GET'])
def get_historico(id_turma: str):
    cursor = conexao.cursor()
    comando = f"""SELECT Aluno.matricula, Aluno.primeiro_nome, Aluno.segundo_nome
                FROM Inscricao
                JOIN Aluno ON Inscricao.id_aluno = Aluno.id_aluno
                WHERE Inscricao.id_turma = {id_turma};"""
    cursor.execute(comando)
    resultado = cursor.fetchall()
    print(resultado)
    cursor.close()
    return jsonify(resultado), 200


@professor_blueprint.route('/get_nome_prof/<string:id_prof>', methods=['GET'])
def get_nome_prof(id_prof:str):
    cursor = conexao.cursor()
    comando = f"""SELECT CONCAT(primeiro_nome, ' ', segundo_nome) AS nome_completo_professor
                FROM Professor
                WHERE id_professor = {id_prof};"""
    cursor.execute(comando)
    resultado = cursor.fetchall()
    print(resultado)
    cursor.close()
    return jsonify(resultado), 200

#TO-DO
@professor_blueprint.route('/agendar_chamada', methods=['POST'])
def agendar_chamada():
    # Apenas placeholders em lista
    start_time = request.json.get('start_time')
    end_time = request.json.get('end_time')
    chamadas.professor_blueprintend({"start_time": start_time, "end_time": end_time})
    return jsonify({"status": "success", "message": "chamada agendada com sucesso"}), 200

@professor_blueprint.route('/iniciar_chamada/<string:id_turma>/<string:localizacao>', methods=['POST'])
def iniciar_chamada(id_turma: str, localizacao: str):
    cursor = conexao.cursor()
    comando = f"""INSERT INTO Aula (id_turma, localizacao, data_hora_inicio, situacao) VALUES
                ({id_turma}, '{localizacao}', NOW(), 1),"""
    cursor.execute(comando)
    conexao.commit()
    cursor.close()
    return jsonify({"status": "success", "message": "chamada started"}), 200

@professor_blueprint.route('/terminar_chamada/<string:id_aula>', methods=['POST'])
def finalizar_chamada(id_aula:str):
    cursor = conexao.cursor()
    comando = f"""UPDATE Aula
                SET situacao = 0, data_hora_fim = NOW()
                WHERE id_turma = {id_aula} AND situacao = 1;"""
    cursor.execute(comando)
    conexao.commit()
    cursor.close()
    return jsonify({"status": "success", "message": "chamada ended"}), 200


if __name__ == '__main__':
    professor_blueprint.run(debug=True)
