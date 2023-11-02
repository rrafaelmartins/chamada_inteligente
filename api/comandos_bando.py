#import do driver mysql
import mysql.connector

#Conectando com o banco de dados, acho que o ideal seria criar um banco para o projeto
#Aqui estamos acessando ao meu banco próprio
conexao = mysql.connector.connect(
    host='localhost',
    user='root',
    password='200810@Romano',
    database='chamadainteligente'
)
#Classe para instanciar um Aluno -- Talvez não precise dessa classe, não pensei em algo mais eficiente
#Não precisamos passar o ID pois é auto_increment
class Aluno:
    def __init__(self, matricula, nome, cpf):
        self.matricula = matricula
        self.nome = nome
        self.cpf = cpf

class Professor:
    def __init__(self, nome, matricula, departamento):
        self.nome = nome
        self.matricula = matricula
        self.departamento = departamento

#class Turma: 

#Função para adicionar Aluno no banco
def insereAluno(matricula, nome, cpf):
    new_aluno = Aluno(matricula, nome, cpf)
    cursor = conexao.cursor()
    comando = f'INSERT INTO aluno (matricula,nome,cpf) VALUES ("{new_aluno.matricula}","{new_aluno.nome}","{new_aluno.cpf}")'
    cursor.execute(comando)
    conexao.commit()
    cursor.close()
    conexao.close()
    return new_aluno

#Função para adicionar um Professor no banco
def insereProfessor(nome, matricula, departamento):
    new_professor = Professor(nome, matricula, departamento)
    cursor = conexao.cursor()
    comando = f'INSERT INTO professor (nome, matricula,departamento) VALUES ("{new_professor.nome}","{new_professor.matricula}","{new_professor.departamento}")'
    cursor.execute(comando)
    conexao.commit()
    cursor.close()
    conexao.close()
    return new_professor


def consultaAluno():
    cursor = conexao.cursor()
    comando = 'select * from aluno'
    cursor.execute(comando)
    resultado = cursor.fetchall()
    print(resultado)
    cursor.close()
    conexao.close()

def consultaProfessor():
    cursor = conexao.cursor()
    comando = 'select * from professor'
    cursor.execute(comando)
    resultado = cursor.fetchall()
    print(resultado)
    cursor.close()
    conexao.close()


#insereAluno('15848232','Juliana','19571')
#insereProfessor('Leonardo Murta','1238547','Computação')
#consultaAluno()
consultaProfessor()

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




