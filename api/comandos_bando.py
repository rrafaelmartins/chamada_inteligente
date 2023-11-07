#import do driver mysql
import mysql.connector

import os
from dotenv import load_dotenv
load_dotenv()
password = os.getenv('PASSWORD')

#Conectando com o banco de dados, acho que o ideal seria criar um banco para o projeto
#Aqui estamos acessando ao meu banco próprio. Substitua pela sua senha de conexão para o MySQL
conexao = mysql.connector.connect(
    host='localhost',
    user='root',
    password=f'{password}',
    database='chamadainteligente'
)

#Classe para instanciar um Aluno -- Talvez não precise dessa classe, não pensei em algo mais eficiente
#Não precisamos passar o ID pois é auto_increment
class Aluno:
    def __init__(self, matricula, nome, cpf, senha):
        self.matricula = matricula
        self.nome = nome
        self.cpf = cpf
        self.senha = senha
       

class Professor:
    def __init__(self, nome, matricula, departamento, senha):
        self.nome = nome
        self.matricula = matricula
        self.departamento = departamento
        self.senha =  senha

class Turma:
    def __init__(self, id, disciplina_id, data_inicio, professor_id):
        self.id = id
        self.disciplina_id = disciplina_id
        self.data_inicio = data_inicio
        self.professor_id = professor_id

class Chamada:
    def __init__(self, id, turma_id, data_chamada, abertura_chamada, fechamento_chamada):
        self.id = id
        self.turma_id = turma_id
        self.data_chamada = data_chamada
        self.abertura_chamada = abertura_chamada
        self.fechamento_chamada = fechamento_chamada

class ChamadaAluno:
    def __init__(self, id, turma_id, data_chamada, abertura_chamada, fechamento_chamada):
        self.id = id
        self.turma_id = turma_id
        self.data_chamada = data_chamada
        self.abertura_chamada = abertura_chamada
        self.fechamento_chamada = fechamento_chamada
        
class Disciplina:
    def __init__(self, id, nome, tipo):
        self.id = id
        self.nome = nome
        self.tipo = tipo

#Função para adicionar Aluno no banco
def insereAluno(matricula, nome, cpf, senha):
    new_aluno = Aluno(matricula, nome, cpf, senha)
    cursor = conexao.cursor()
    comando = f'INSERT INTO aluno (matricula,nome,cpf,senha) VALUES ("{new_aluno.matricula}","{new_aluno.nome}","{new_aluno.cpf}","{new_aluno.senha}")'
    cursor.execute(comando)
    conexao.commit()
    cursor.close()
    #conexao.close()
    return new_aluno

#Função para adicionar um Professor no banco
def insereProfessor(nome, matricula, departamento, senha):
    new_professor = Professor(nome, matricula, departamento, senha)
    cursor = conexao.cursor()
    comando = f'INSERT INTO professor (nome, matricula,departamento,senha) VALUES ("{new_professor.nome}","{new_professor.matricula}","{new_professor.departamento}","{new_professor.senha}")'
    cursor.execute(comando)
    conexao.commit()
    cursor.close()
    #conexao.close()
    return new_professor

#Função para adicionar uma Turma no banco
def insereTurma(id, disciplina_id, data_inicio, professor_id):
    new_turma = Turma(id, disciplina_id, data_inicio, professor_id)
    cursor = conexao.cursor()
    comando = f'INSERT INTO turma (id, disciplina_id, data_inicio, professor_id) VALUES ("{new_turma.id}","{new_turma.disciplina_id}","{new_turma.data_inicio}","{new_turma.professor_id}")'
    cursor.execute(comando)
    conexao.commit() #pois é uma operacao de escrita
    cursor.close()
    return new_turma

#Função para consultar um Aluno no banco
def consultaAluno():
    cursor = conexao.cursor()
    comando = 'select * from aluno'
    cursor.execute(comando)
    resultado = cursor.fetchall()
    print(resultado)
    cursor.close()
    #conexao.close()

#Função para consultar um Professor no banco
def consultaProfessor():
    cursor = conexao.cursor()
    comando = 'select * from professor'
    cursor.execute(comando)
    resultado = cursor.fetchall()
    print(resultado)
    cursor.close()
    conexao.close()



"""insereAluno('15848232','Juliana','19571','senhateste')
insereProfessor('Leonardo Murta','1238547','Computação','123senha')

consultaAluno()
consultaProfessor()
"""
#Executa os comandos da conexão
#cursor = conexao.cursor()

#Escrever o comando em SQL aqui
#comando = f'INSERT INTO aluno (matricula,nome,cpf) VALUES ("{new_aluno.matricula}","{new_aluno.nome}","{new_aluno.cpf}")'

#Caso seja o comando de edição usar commit, leitura usar fetchall
#cursor.execute(comando)

#Para editar o banco de dados
#conexao.commit()

#Para ler o banco de dados
#resultado = cursor.fetchall()


#Fecha o cursor
#cursor.close()
#Encerra a conexão
#conexao.close()
#