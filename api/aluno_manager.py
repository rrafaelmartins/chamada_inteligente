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

@aluno_blueprint.route('/estatisticas_historico_aluno/<string:id_turma>/<string:id_aluno>', methods=['GET'])
def estatisticas_historico_aluno(id_turma: str, id_aluno: str):
    conexao = open_conexao()
    cursor = conexao.cursor()
    comando = f"""
SELECT 
    (SELECT COUNT(*) FROM Aula WHERE id_turma = {id_turma}) AS Total_Aulas,
    (SELECT COUNT(*) 
     FROM Presencas AS P 
     INNER JOIN Aula AS A ON P.id_aula = A.id_aula 
     WHERE A.id_turma = {id_turma} AND P.id_aluno = {id_aluno}) AS Total_Presencas,
    (SELECT COUNT(*) FROM Aula WHERE id_turma = {id_turma}) - 
    (SELECT COUNT(*) 
     FROM Presencas AS P 
     INNER JOIN Aula AS A ON P.id_aula = A.id_aula 
     WHERE A.id_turma = {id_turma} AND P.id_aluno = {id_aluno}) AS Total_Faltas,
    ROUND(((
        (SELECT COUNT(*) FROM Aula WHERE id_turma = {id_turma}) - 
        (SELECT COUNT(*) 
         FROM Presencas AS P 
         INNER JOIN Aula AS A ON P.id_aula = A.id_aula 
         WHERE A.id_turma = {id_turma} AND P.id_aluno = {id_aluno})
    ) / (SELECT COUNT(*) FROM Aula WHERE id_turma = {id_turma})) * 100, 2) AS Percentual_Faltas
"""
    cursor.execute(comando)
    resultado = cursor.fetchall()
    cursor.close()
    conexao.close()
    return jsonify(resultado), 200

@aluno_blueprint.route('/get_turmas_aluno/<string:id_aluno>', methods=['GET'])
def get_turmas_aluno(id_aluno:str):
    conexao = open_conexao()
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
    conexao.close()
    return jsonify(resultado), 200

@aluno_blueprint.route('/get_nome_matricula_aluno/<string:id_aluno>', methods=['GET'])
def get_nome_matricula_aluno(id_aluno: str):
    conexao = open_conexao()
    cursor = conexao.cursor()
    comando = f"""
            SELECT CONCAT(primeiro_nome, ' ', segundo_nome), matricula
            AS nome_completo 
            FROM Aluno 
            WHERE id_aluno = {id_aluno};
                """
    cursor.execute(comando)
    resultado = cursor.fetchall()
    cursor.close()
    conexao.close()
    return jsonify(resultado), 200

@aluno_blueprint.route('/confirmar_presenca/<string:id_aluno>/<string:id_turma>', methods=['POST'])
def confirmar_presenca(id_aluno:str, id_turma:str):
    conexao = open_conexao()
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
    conexao.close()
    return jsonify({"status": "success", "message": "presenca registrada"}), 200

@aluno_blueprint.route('/verificar_presenca/<string:id_aluno>/<string:id_turma>', methods=['GET'])
def verificar_presenca(id_aluno:str, id_turma:str):
    conexao = open_conexao()
    cursor = conexao.cursor()
    comando = f"""
    SELECT EXISTS (
    SELECT 1 
    FROM Presencas
    INNER JOIN Aula ON Presencas.id_aula = Aula.id_aula
    WHERE Aula.id_turma = {id_turma} 
    AND Aula.situacao = 1 
    AND Presencas.id_aluno = {id_aluno}
    ) AS presenca_confirmada;
    """
    cursor.execute(comando)
    resultado = cursor.fetchall()
    cursor.close()
    conexao.close()
    return jsonify(resultado), 200

@aluno_blueprint.route('/get_nomeprof_by_turmaid/<string:id_turma>', methods=['GET'])
def get_nomeprof_by_turmaid(id_turma:str):
    conexao = open_conexao()
    cursor = conexao.cursor()
    comando = f"""SELECT Professor.primeiro_nome, Professor.segundo_nome
                    FROM Turma
                    JOIN Professor ON Turma.id_professor = Professor.id_professor
                    WHERE Turma.id_turma = {id_turma};
                    """
    cursor.execute(comando)
    resultado = cursor.fetchall()
    cursor.close()
    conexao.close()
    return jsonify(resultado), 200

@aluno_blueprint.route('/get_historico_aluno/<string:id_turma>/<string:id_aluno>', methods=['GET'])
def get_historico_aluno(id_turma: str, id_aluno: str):
    conexao = open_conexao()
    cursor = conexao.cursor()
    comando = f"""SELECT A.id_aula, 
                DATE_FORMAT(A.data_hora_inicio, '%d/%m/%Y') AS data_aula,
                CASE 
                WHEN P.id_aluno IS NOT NULL THEN 'Presente'
                ELSE 'Ausente'
                END AS presenca
                FROM Aula A
                LEFT JOIN Presencas P ON A.id_aula = P.id_aula AND P.id_aluno = {id_aluno}
                WHERE A.id_turma = {id_turma};
                """
    cursor.execute(comando)
    resultado = cursor.fetchall()
    cursor.close()
    conexao.close()
    return jsonify(resultado), 200

@aluno_blueprint.route('/check_open_chamadas/<string:id_turma>', methods=['GET'])
def check_open_chamadas(id_turma: str):
    conexao = open_conexao()
    cursor = conexao.cursor()
    comando = f"""SELECT EXISTS (
                        SELECT 1
                        FROM Aula
                        WHERE id_turma = {id_turma} AND situacao = 1
                    ) AS aula_ativa;"""
    cursor.execute(comando)
    resultado = cursor.fetchall()
    cursor.close()
    conexao.close()
    return jsonify(resultado), 200

@aluno_blueprint.route('/check_open_chamadas_home/<string:id_aluno>', methods=['GET'])
def check_open_chamadas_home(id_aluno: str):
    conexao = open_conexao()
    cursor = conexao.cursor()
    comando = f"""SELECT A.id_turma, D.nome AS nome_disciplina
FROM Aula A
INNER JOIN Turma T ON A.id_turma = T.id_turma
INNER JOIN Inscricao I ON T.id_turma = I.id_turma
INNER JOIN Disciplina D ON T.id_disciplina = D.id_disciplina
WHERE I.id_aluno = {id_aluno} AND A.situacao = 1;"""
    cursor.execute(comando)
    resultado = cursor.fetchall()
    cursor.close()
    conexao.close()
    return jsonify(resultado), 200

@aluno_blueprint.route('/get_localizacao_chamada/<string:id_turma>', methods=['GET'])
def get_localizacao_chamada(id_turma: str):
    conexao = open_conexao()
    cursor = conexao.cursor()
    comando = f"""SELECT localizacao
                    FROM Aula
                    WHERE id_turma = {id_turma} AND situacao = 1;
                """
    cursor.execute(comando)
    resultado = cursor.fetchall()
    cursor.close()
    conexao.close()
    return jsonify(resultado), 200

def consultaAluno(matricula, password):
    conexao = open_conexao()
    cursor = conexao.cursor()
    comando = f'SELECT * from aluno WHERE matricula = "{matricula}" AND senha = "{password}"'
    cursor.execute(comando)
    resultado = cursor.fetchall()
    cursor.close()
    conexao.close()
    return resultado
