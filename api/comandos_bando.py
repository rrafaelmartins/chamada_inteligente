#import do driver mysql
import mysql.connector


#Não precisamos passar o ID pois é auto_increment
class Aluno:
    def __init__(self, matricula, nome, cpf):
        self.matricula = matricula
        self.nome = nome
        self.cpf = cpf


new_aluno = Aluno('123456','João','96325478')

#Conectando com o banco de dados, acho que o ideal seria criar um banco para o projeto
#Aqui estamos acessando ao meu banco próprio


conexao = mysql.connector.connect(
    host='localhost',
    user='root',
    password='200810@Romano',
    database='chamadainteligente'
)

#Executa os comandos da conexão
cursor = conexao.cursor()

#Escrever o comando em SQL aqui
comando = f'INSERT INTO aluno (matricula,nome,cpf) VALUES ("{new_aluno.matricula}","{new_aluno.nome}","{new_aluno.cpf}")'

#Caso seja o comando de edição usar commit, leitura usar fetchall
cursor.execute(comando)

#Para editar o banco de dados
conexao.commit()

#Para ler o banco de dados
resultado = cursor.fetchall()


#Fecha o cursor
cursor.close()
#Encerra a conexão
conexao.close()
#




