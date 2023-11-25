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
    comando = f"""SELECT DATE_FORMAT(data_hora_inicio, '%d/%m/%Y') AS data_inicio_formatada
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
            INSERT INTO Presencas (id_aula, id_aluno, tempo_presenca)
SELECT 
    (SELECT id_aula FROM Aula WHERE id_turma = {id_turma} ORDER BY data_hora_inicio DESC LIMIT 1), 
    (SELECT id_aluno FROM Aluno WHERE matricula = {matricula}),
    '00:00:00';
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
    print(resultado)
    conexao.commit()
    cursor.close()
    conexao.close()
    return jsonify({"status": "success", "message": "presenca retirada"}), 200
   



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

@professor_blueprint.route('/chamada_passada/<string:id_turma>/<string:data>', methods=['GET'])
def chamada_passada(id_turma: str, data:str):
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
    AND DATE(a.data_hora_inicio) = '{data}';"""
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

@professor_blueprint.route('/get_percentual_presenca_turma/<string:id_turma>', methods=['GET'])
def get_percentual_presenca_turma(id_turma: str):
    conexao = open_conexao()
    cursor = conexao.cursor()
    comando = f"""SELECT 
    ROUND(COUNT(p.id_presenca) * 100.0 / COUNT(i.id_aluno), 2) AS Percentual_Presença
FROM 
    Aula a
INNER JOIN 
    Turma t ON a.id_turma = t.id_turma
INNER JOIN 
    Inscricao i ON t.id_turma = i.id_turma
LEFT JOIN 
    Presencas p ON a.id_aula = p.id_aula AND i.id_aluno = p.id_aluno
WHERE 
    a.id_turma = {id_turma}
GROUP BY 
    a.id_aula;"""
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
                    A.matricula AS Matricula_Aluno,
                    IFNULL(ROUND((COUNT(P.id_presenca) / COUNT(DISTINCT AU.id_aula)) * 100, 2), 0) AS Porcentagem_Presenca,
                    SUM(CASE WHEN P.id_presenca IS NOT NULL THEN 1 ELSE 0 END) AS Presencas,
                    (COUNT(AU.id_aula) - SUM(CASE WHEN P.id_presenca IS NOT NULL THEN 1 ELSE 0 END)) AS Faltas,
                    CASE 
                        WHEN (COUNT(AU.id_aula) - SUM(CASE WHEN P.id_presenca IS NOT NULL THEN 1 ELSE 0 END)) >= 8 THEN 'Reprovado por faltas'
                        ELSE NULL
                    END AS Situacao
                FROM 
                    Aluno A
                LEFT JOIN 
                    Inscricao I ON A.id_aluno = I.id_aluno
                LEFT JOIN 
                    Turma T1 ON I.id_turma = T1.id_turma
                LEFT JOIN 
                    Aula AU ON T1.id_turma = AU.id_turma
                LEFT JOIN 
                    Presencas P ON AU.id_aula = P.id_aula AND A.id_aluno = P.id_aluno
                WHERE 
                    T1.id_turma = {id_turma}
                GROUP BY 
                    A.id_aluno, Nome_Aluno, Matricula_Aluno

                UNION

                SELECT 
                    CONCAT(AL.primeiro_nome, ' ', AL.segundo_nome) AS Nome_Aluno,
                    AL.matricula AS Matricula_Aluno,
                    0 AS Porcentagem_Presenca,
                    SUM(CASE WHEN PR.id_presenca IS NOT NULL THEN 1 ELSE 0 END) AS Presencas,
                    (COUNT(AU2.id_aula) - SUM(CASE WHEN PR.id_presenca IS NOT NULL THEN 1 ELSE 0 END)) AS Faltas,
                    CASE 
                        WHEN (COUNT(AU2.id_aula) - SUM(CASE WHEN PR.id_presenca IS NOT NULL THEN 1 ELSE 0 END)) >= 8 THEN 'Reprovado por faltas'
                        ELSE NULL
                    END AS Situacao
                FROM 
                    Aluno AL
                LEFT JOIN 
                    Inscricao INSC ON AL.id_aluno = INSC.id_aluno
                LEFT JOIN 
                    Aula AU2 ON INSC.id_turma = AU2.id_turma
                LEFT JOIN 
                    Presencas PR ON AU2.id_aula = PR.id_aula AND AL.id_aluno = PR.id_aluno
                WHERE 
                    INSC.id_turma = {id_turma}
                GROUP BY 
                    AL.id_aluno, Nome_Aluno, Matricula_Aluno
                ORDER BY 
                    Nome_Aluno, Matricula_Aluno;


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