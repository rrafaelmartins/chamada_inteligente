from flask import request, jsonify, Blueprint
import mysql.connector
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
    conexao = open_conexao()
    cursor = conexao.cursor()
    comando = f'select nome, codigo_turma, id_turma FROM Disciplina JOIN Turma ON Turma.id_disciplina = Disciplina.id_disciplina WHERE id_professor = {id_professor}; '
    cursor.execute(comando)
    resultado = cursor.fetchall()
    cursor.close()
    conexao.close()
    return jsonify(resultado), 200

@professor_blueprint.route('/get_nomedisciplina_by_turmaid/<string:id_turma>', methods=['GET'])
def get_nomedisciplina_by_turmaid(id_turma: str):
    conexao = open_conexao()
    cursor = conexao.cursor()
    comando = f"""SELECT Disciplina.nome
                FROM Turma
                JOIN Disciplina ON Turma.id_disciplina = Disciplina.id_disciplina
                WHERE Turma.id_turma = {id_turma};"""
    cursor.execute(comando)
    resultado = cursor.fetchall()
    cursor.close()
    conexao.close()
    return jsonify(resultado), 200

@professor_blueprint.route('/get_historico/<string:id_turma>', methods=['GET']) #MUDAR PARA GET_CHAMADA !!!!!!!!! NOME ERRADO !!!!!
def get_historico(id_turma: str):
    conexao = open_conexao()
    cursor = conexao.cursor()
    comando = f"""SELECT Aluno.matricula, Aluno.primeiro_nome, Aluno.segundo_nome
                FROM Inscricao
                JOIN Aluno ON Inscricao.id_aluno = Aluno.id_aluno
                WHERE Inscricao.id_turma = {id_turma};"""
    cursor.execute(comando)
    resultado = cursor.fetchall()
    cursor.close()
    conexao.close()
    return jsonify(resultado), 200

@professor_blueprint.route('/get_datas_historico_prof/<string:id_turma>', methods=['GET'])
def get_datas_historico_prof(id_turma: str):
    conexao = open_conexao()
    cursor = conexao.cursor()
    comando = f"""SELECT DATE_FORMAT(data_hora_inicio, '%d/%m/%Y') AS data_inicio_formatada, id_aula
                FROM Aula
                WHERE id_turma = {id_turma} AND data_hora_inicio <= NOW();"""
    cursor.execute(comando)
    resultado = cursor.fetchall()
    cursor.close()
    conexao.close()
    return jsonify(resultado), 200

@professor_blueprint.route('/create_presenca_aluno/<string:id_turma>/<string:matricula>', methods=['POST'])
def create_presenca_aluno(id_turma: str, matricula: str):
    conexao = open_conexao()
    cursor = conexao.cursor()
    comando = f"""
            INSERT INTO Presencas (id_aula, id_aluno)
SELECT 
    (SELECT id_aula FROM Aula WHERE id_turma = {id_turma} AND situacao = 1 ORDER BY data_hora_inicio DESC LIMIT 1), 
    (SELECT id_aluno FROM Aluno WHERE matricula = {matricula});
                """
    cursor.execute(comando)
    conexao.commit()
    cursor.close()
    conexao.close()
    return jsonify({"status": "success", "message": "presenca criada"}), 200
   
@professor_blueprint.route('/delete_presenca_aluno/<string:id_turma>/<string:matricula>', methods=['DELETE'])
def delete_presenca_aluno(id_turma: str, matricula: str):
    conexao = open_conexao()
    cursor = conexao.cursor()
    comando = f"""
            DELETE FROM Presencas
            WHERE 
            id_aluno = (SELECT id_aluno FROM Aluno WHERE matricula = {matricula}) AND
            id_aula = (SELECT id_aula FROM Aula WHERE id_turma = {id_turma} AND situacao = 1 ORDER BY data_hora_inicio DESC LIMIT 1);
                """
    cursor.execute(comando)
    resultado = cursor.fetchall()
    conexao.commit()
    cursor.close()
    conexao.close()
    return jsonify({"status": "success", "message": "presenca retirada"}), 200
   
@professor_blueprint.route('/export_chamada/<string:id_turma>/<string:data>', methods=['GET'])
def export_chamada(id_turma: str, data: str):
    conexao = open_conexao()
    cursor = conexao.cursor()
    comando = f"""
        SELECT 
    CONCAT(al.primeiro_nome, ' ', al.segundo_nome) AS Aluno, 
    al.matricula,
    CASE 
        WHEN p.id_aluno IS NOT NULL THEN 'Presente'
        ELSE 'Ausente' 
        END AS presenca
        INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/{data}.csv'
        FIELDS TERMINATED BY ','
        ENCLOSED BY '"'
        LINES TERMINATED BY '\n'
        FROM 
            Aula a
        JOIN 
            Turma t ON a.id_turma = t.id_turma
        JOIN 
            Inscricao i ON t.id_turma = i.id_turma
        JOIN 
            Aluno al ON i.id_aluno = al.id_aluno
        LEFT JOIN 
            Presencas p ON a.id_aula = p.id_aula AND al.id_aluno = p.id_aluno
        WHERE 
            a.id_turma = {id_turma} 
            AND DATE(a.data_hora_inicio) = '{data}';

        """
    cursor.execute(comando)
    resultado = cursor.fetchall()
    conexao.commit()
    cursor.close()
    conexao.close()
    return jsonify({"status": "success", "message": "arquivo exportado para /MySQL/MySQL Server 8.0/Uploads"}), 200

@professor_blueprint.route('/get_nome_prof/<string:id_prof>', methods=['GET'])
def get_nome_prof(id_prof:str):
    conexao = open_conexao()
    cursor = conexao.cursor()
    comando = f"""SELECT CONCAT(primeiro_nome, ' ', segundo_nome) AS nome_completo_professor
                FROM Professor
                WHERE id_professor = {id_prof};"""
    cursor.execute(comando)
    resultado = cursor.fetchall()
    cursor.close()
    conexao.close()
    return jsonify(resultado), 200

@professor_blueprint.route('/get_situacao/<string:id_turma>', methods=['GET'])
def get_situacao(id_turma:str):
    conexao = open_conexao()
    cursor = conexao.cursor()
    comando = f"""SELECT 
    CONCAT(A.primeiro_nome, ' ', A.segundo_nome) AS Nome_Aluno,
    CASE
        WHEN (
            (
                SELECT COUNT(*) 
                FROM Aula 
                WHERE id_turma = {id_turma}
            ) - (
                SELECT COUNT(*) 
                FROM Presencas AS P 
                INNER JOIN Aula AS AA ON P.id_aula = AA.id_aula 
                WHERE AA.id_turma = {id_turma} AND P.id_aluno = A.id_aluno
            )
        ) >= 8 THEN 'Reprovado'
        ELSE ''
    END AS Situacao_Aluno
FROM 
    Aluno A
WHERE EXISTS (
    SELECT 1
    FROM Inscricao I
    WHERE I.id_aluno = A.id_aluno AND I.id_turma = {id_turma}
)
ORDER BY 
    Nome_Aluno;
"""
    cursor.execute(comando)
    resultado = cursor.fetchall()
    cursor.close()
    conexao.close()
    return jsonify(resultado), 200

@professor_blueprint.route('/agendar_chamada', methods=['POST'])
def agendar_chamada():
    start_time = request.json.get('start_time')
    end_time = request.json.get('end_time')
    chamadas.professor_blueprintend({"start_time": start_time, "end_time": end_time})
    return jsonify({"status": "success", "message": "chamada agendada com sucesso"}), 200

@professor_blueprint.route('/visualizar_chamada/<string:id_turma>/', methods=['GET'])
def visualizar_chamada(id_turma: str):
    conexao = open_conexao()
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
    cursor.close()
    conexao.close()
    return jsonify(resultado), 200

@professor_blueprint.route('/chamada_passada/<string:id_turma>/<string:id_aula>', methods=['GET'])
def chamada_passada(id_turma: str, id_aula:str):
    conexao = open_conexao()
    cursor = conexao.cursor()
    comando = f"""SELECT 
    CONCAT(al.primeiro_nome, ' ', al.segundo_nome) AS Aluno, 
    al.matricula,
    CASE 
        WHEN p.id_aluno IS NOT NULL THEN 'Presente'
        ELSE 'Ausente' 
    END AS presenca
FROM 
    Aula a
JOIN 
    Turma t ON a.id_turma = t.id_turma
JOIN 
    Inscricao i ON t.id_turma = i.id_turma
JOIN 
    Aluno al ON i.id_aluno = al.id_aluno
LEFT JOIN 
    Presencas p ON a.id_aula = p.id_aula AND al.id_aluno = p.id_aluno
WHERE 
    a.id_turma = {id_turma} 
    AND a.id_aula = {id_aula};"""
    cursor.execute(comando)
    resultado = cursor.fetchall()
    cursor.close()
    conexao.close()
    return jsonify(resultado), 200


@professor_blueprint.route('/get_numero_alunos/<string:id_turma>', methods=['GET'])
def get_numero_alunos(id_turma: str):
    conexao = open_conexao()
    cursor = conexao.cursor()
    comando = f"""SELECT COUNT(id_aluno) AS numero_de_alunos_inscritos
                FROM Inscricao
                WHERE id_turma = {id_turma};"""
    cursor.execute(comando)
    resultado = cursor.fetchall()
    cursor.close()
    conexao.close()
    return jsonify(resultado), 200

@professor_blueprint.route('/get_numero_aulas/<string:id_turma>', methods=['GET'])
def get_numero_aulas(id_turma: str):
    conexao = open_conexao()
    cursor = conexao.cursor()
    comando = f"""SELECT COUNT(id_aula) AS quantidade_de_aulas
                FROM Aula
                WHERE id_turma = {id_turma};"""
    cursor.execute(comando)
    resultado = cursor.fetchall()
    cursor.close()
    conexao.close()
    return jsonify(resultado), 200

@professor_blueprint.route('/get_percentual_presenca_turma/<string:id_turma>', methods=['GET'])
def get_percentual_presenca_turma(id_turma: str):
    conexao = open_conexao()
    cursor = conexao.cursor()
    comando = f"""SELECT 
    CASE 
        WHEN COUNT(i.id_aluno) > 0 THEN 
            ROUND(COUNT(p.id_presenca) * 100.0 / COUNT(i.id_aluno), 2) 
        ELSE 
            0 
    END AS Percentual_Presença
FROM 
    Aula a
INNER JOIN 
    Turma t ON a.id_turma = t.id_turma
LEFT JOIN 
    Inscricao i ON t.id_turma = i.id_turma
LEFT JOIN 
    Presencas p ON a.id_aula = p.id_aula AND i.id_aluno = p.id_aluno
WHERE 
    a.id_turma = {id_turma}
GROUP BY 
    a.id_aula
"""
    cursor.execute(comando)
    resultado = cursor.fetchall()
    cursor.close()
    conexao.close()
    return jsonify(resultado), 200

@professor_blueprint.route('/estatisticas_prof/<string:id_turma>/', methods=['GET'])
def estatisticas_prof(id_turma: str):
    conexao = open_conexao()
    cursor = conexao.cursor()
    comando = f"""
                SELECT 
    CONCAT(A.primeiro_nome, ' ', A.segundo_nome) AS Nome_Aluno,
    A.matricula AS Matricula,
    ROUND(
        (
            (
                SELECT COUNT(*) 
                FROM Presencas AS P 
                INNER JOIN Aula AS AA ON P.id_aula = AA.id_aula 
                WHERE AA.id_turma = {id_turma} AND P.id_aluno = A.id_aluno
            ) / 
            (SELECT COUNT(*) FROM Aula WHERE id_turma = {id_turma})
        ) * 100,
    2) AS Percentual_Presenca,
    (
        SELECT COUNT(*) 
        FROM Presencas AS P 
        INNER JOIN Aula AS AA ON P.id_aula = AA.id_aula 
        WHERE AA.id_turma = {id_turma} AND P.id_aluno = A.id_aluno
    ) AS Numero_de_Presencas,
    (
        (
            SELECT COUNT(*) 
            FROM Aula 
            WHERE id_turma = {id_turma}
        ) - (
            SELECT COUNT(*) 
            FROM Presencas AS P 
            INNER JOIN Aula AS AA ON P.id_aula = AA.id_aula 
            WHERE AA.id_turma = {id_turma} AND P.id_aluno = A.id_aluno
        )
    ) AS Numero_de_Faltas,
    CASE
        WHEN (
            (
                SELECT COUNT(*) 
                FROM Aula 
                WHERE id_turma = {id_turma}
            ) - (
                SELECT COUNT(*) 
                FROM Presencas AS P 
                INNER JOIN Aula AS AA ON P.id_aula = AA.id_aula 
                WHERE AA.id_turma = {id_turma} AND P.id_aluno = A.id_aluno
            )
        ) >= 8 THEN 'Reprovado por falta'
        ELSE '-'
    END AS Situacao_Aluno
FROM 
    Aluno A
WHERE EXISTS (
    SELECT {id_turma}
    FROM Inscricao I
    WHERE I.id_aluno = A.id_aluno AND I.id_turma = {id_turma}
)
ORDER BY 
    Nome_Aluno;
                """
    cursor.execute(comando)
    resultado = cursor.fetchall()
    cursor.close()
    conexao.close()
    return jsonify(resultado), 200



@professor_blueprint.route('/iniciar_chamada/<string:id_turma>/', methods=['POST'])
def iniciar_chamada(id_turma: str):
    conexao = open_conexao()
    cursor = conexao.cursor()
    localizacao = request.json.get('localizacao')
    comando = f"""INSERT INTO Aula (id_turma, localizacao, data_hora_inicio, situacao) VALUES
                ({id_turma}, "{localizacao}", NOW(), 1)"""
    cursor.execute(comando)
    conexao.commit()
    cursor.close()
    conexao.close()
    return jsonify({"status": "success", "message": "chamada started"}), 200

@professor_blueprint.route('/finalizar_chamada/<string:id_turma>', methods=['POST'])
def finalizar_chamada(id_turma:str):
    conexao = open_conexao()
    cursor = conexao.cursor()
    comando = f"""UPDATE Aula 
                SET situacao = 0, data_hora_fim = NOW() 
                WHERE id_turma = {id_turma} AND situacao = 1;"""
    cursor.execute(comando)
    conexao.commit()
    cursor.close()
    conexao.close()
    return jsonify({"status": "success", "message": "chamada ended"}), 200


@professor_blueprint.route('/get_nome_matricula_professor/<string:id_professor>', methods=['GET'])
def get_nome_matricula_professor(id_professor: str):
    conexao = open_conexao()
    cursor = conexao.cursor()
    comando = f"""
            SELECT CONCAT(primeiro_nome, ' ', segundo_nome) as Nome, matricula
            FROM Professor 
            WHERE id_professor = {id_professor};
                """
    cursor.execute(comando)
    resultado = cursor.fetchall()
    cursor.close()
    conexao.close()
    return jsonify(resultado), 200


if __name__ == '__main__':
    professor_blueprint.run(debug=True)