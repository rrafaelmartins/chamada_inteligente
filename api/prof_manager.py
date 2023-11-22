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
    database='intelitestenovo'
)

def open_conexao():
    conexao = mysql.connector.connect(
    host='localhost',
    user='root',
    password=f'{password}',
    database='intelitestenovo'
)
    return conexao

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


@professor_blueprint.route('/get_historico/<string:id_turma>', methods=['GET']) #MUDAR PARA GET_CHAMADA !!!!!!!!! NOME ERRADO !!!!!
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

@professor_blueprint.route('/get_datas_historico_prof/<string:id_turma>', methods=['GET'])
def get_datas_historico_prof(id_turma: str):
    cursor = conexao.cursor()
    comando = f"""SELECT DATE_FORMAT(data_hora_inicio, '%d/%m/%Y') AS data_inicio_formatada
                FROM Aula
                WHERE id_turma = {id_turma} AND data_hora_inicio <= NOW();"""
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


@professor_blueprint.route('/visualizar_chamada/<string:id_turma>/', methods=['GET'])
def visualizar_chamada(id_turma: str):
    print("entrou")
    cursor = conexao.cursor()
    comando = f"""SELECT CONCAT(al.primeiro_nome, ' ', al.segundo_nome) as nome, al.matricula, COALESCE(p.id_presenca, 0) as id_presenca
                FROM Aula a
                INNER JOIN Turma t ON a.id_turma = t.id_turma
                INNER JOIN Inscricao i ON t.id_turma = i.id_turma
                INNER JOIN Aluno al ON i.id_aluno = al.id_aluno
                LEFT JOIN Presencas p ON a.id_aula = p.id_aula AND al.id_aluno = p.id_aluno
                WHERE t.id_turma = {id_turma}
                AND a.situacao = 1 
                ORDER BY al.id_aluno, a.id_aula;"""
    cursor.execute(comando)
    resultado = cursor.fetchall()
    print(resultado)
    cursor.close()
    return jsonify(resultado), 200



@professor_blueprint.route('/iniciar_chamada/<string:id_turma>/', methods=['POST'])
def iniciar_chamada(id_turma: str):
    print("entrou")
    cursor = conexao.cursor()
    localizacao = request.json.get('localizacao')
    print(localizacao)
    comando = f"""INSERT INTO Aula (id_turma, localizacao, data_hora_inicio, situacao) VALUES
                ({id_turma}, "{localizacao}", NOW(), 1)"""
    cursor.execute(comando)
    conexao.commit()
    cursor.close()
    return jsonify({"status": "success", "message": "chamada started"}), 200

@professor_blueprint.route('/finalizar_chamada/<string:id_turma>', methods=['POST'])
def finalizar_chamada(id_turma:str):
    cursor = conexao.cursor()
    comando = f"""UPDATE Aula 
                SET situacao = 0, data_hora_fim = NOW() 
                WHERE id_turma = {id_turma} AND situacao = 1;"""
    cursor.execute(comando)
    conexao.commit()
    cursor.close()
    return jsonify({"status": "success", "message": "chamada ended"}), 200


if __name__ == '__main__':
    professor_blueprint.run(debug=True)
