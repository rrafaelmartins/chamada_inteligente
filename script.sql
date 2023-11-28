-- BANCO DE DADOS ATUAL

create schema ChamadaInteligente;	

use ChamadaInteligente;

CREATE TABLE Professor (
	id_professor INT AUTO_INCREMENT,
	primeiro_nome VARCHAR(40) NOT NULL,
	segundo_nome VARCHAR(40) NOT NULL,
	matricula INT NOT NULL,
	departamento VARCHAR(40) NOT NULL,
	senha VARCHAR(40) NOT NULL,
	PRIMARY KEY (id_professor)
);

CREATE TABLE Aluno (
	id_aluno INT AUTO_INCREMENT,
	primeiro_nome VARCHAR(40) NOT NULL,
	segundo_nome VARCHAR(40) NOT NULL,
	matricula INT NOT NULL,
	senha VARCHAR(40) NOT NULL,
    switch BOOL NOT NULL,
	PRIMARY KEY (id_aluno)
);

CREATE TABLE Disciplina (
	id_disciplina INT AUTO_INCREMENT,
	nome VARCHAR(40),
	PRIMARY KEY (id_disciplina)
);

CREATE TABLE Turma (
	id_turma INT AUTO_INCREMENT,
	codigo_turma VARCHAR(2),
	id_professor INT,
	id_disciplina INT,
	PRIMARY KEY (id_turma),
	FOREIGN KEY (id_professor) REFERENCES Professor(id_professor),
	FOREIGN KEY (id_disciplina) REFERENCES Disciplina(id_disciplina)
);

CREATE TABLE Inscricao (
	id_inscricao INT AUTO_INCREMENT,
	id_aluno INT,
	id_turma INT,
	PRIMARY KEY (id_inscricao),
	FOREIGN KEY (id_aluno) REFERENCES Aluno(id_aluno),
	FOREIGN KEY (id_turma) REFERENCES Turma(id_turma)
);
CREATE TABLE Aula (
	id_aula INT AUTO_INCREMENT,
	id_turma INT,
	localizacao VARCHAR(100),
	data_hora_inicio DATETIME,
	data_hora_fim DATETIME,
	situacao INT,
	PRIMARY KEY (id_aula),
	FOREIGN KEY (id_turma) REFERENCES Turma(id_turma)
);

CREATE TABLE Presencas (
	id_presenca INT AUTO_INCREMENT,
	id_aula INT,
	id_aluno INT,
	PRIMARY KEY (id_presenca),
	FOREIGN KEY (id_aula) REFERENCES Aula(id_aula),
	FOREIGN KEY (id_aluno) REFERENCES Aluno(id_aluno)
);

##### Populando Banco de Dados #####
INSERT INTO Professor (primeiro_nome, segundo_nome, matricula, departamento, senha) VALUES
('Eugene', 'Vinod', 2001, 'Departamento A', 'senha1'),
('Jorge', 'Petrucio', 2002, 'Departamento B', 'senha2'),
('Rodrigo', 'Salvador', 2003, 'Departamento C', 'senha3'),
('Leonardo', 'Murta', 2004, 'Departamento D', 'senha4'),
('Vanessa', 'Braganholo', 2005, 'Departamento E', 'senha5');

INSERT INTO Aluno (primeiro_nome, segundo_nome, matricula, senha, switch) VALUES
('Amara', 'Paz', 1001, 'senha1', false),
('Angelo', 'de Vargas', 1002, 'senha2', false),
('Breno', 'Minghelli', 1003, 'senha3', false),
('Bruno', 'Adji', 1004, 'senha4', false),
('Daniel', 'Menezes', 1005, 'senha5', false),
('Davi', 'Santos', 1006, 'senha6', false),
('Guilherme', 'Tuco', 1007, 'senha7', false),
('Joao', 'Matheus', 1008, 'senha8', false),
('Lucas', 'Pacheco', 1009, 'senha9', false),
('Lucas', 'Serrano', 1010, 'senha10', false),
('Maria', 'Cecilia', 1011, 'senha11', false),
('Mateus', 'Ferreira', 1012, 'senha12', false),
('Rafael', 'Aguiar', 1013, 'senha13', false),
('Raphael', 'Carvalho', 1014, 'senha14', false),
('Rute', 'Rodrigues', 1015, 'senha15', false),
('Sara', 'Maia', 1016, 'senha16', false),
('Thiago', 'Serra', 1017, 'senha17', false),
('Vitor', 'Vieira', 1018, 'senha18', false),
('Vitoria', 'Guidine', 1019, 'senha19', false),
('Viviane', 'Reis', 1020, 'senha20', false);

INSERT INTO Disciplina (nome) VALUES
('Arquitetura de Computadores'),
('Lógica para Ciência da Computação'),
('Banco de Dados I'),
('Engenharia de Software II'),
('Estrutura de Dados');

INSERT INTO Turma (codigo_turma, id_professor, id_disciplina) VALUES
('A1', 1, 1),
('B1', 2, 2),
('C1', 3, 3),
('D1', 4, 4),
('E1', 5, 5),
('D2', 4, 5);

INSERT INTO Inscricao (id_aluno, id_turma) VALUES
(1, 1),
(1, 2),
(1, 3),
(1, 4),
(2, 1),
(2, 5),
(3, 1),
(3, 2),
(3, 4),
(4, 2),
(4, 3),
(4, 4),
(4, 5),
(5, 2),
(6, 2),
(6, 3),
(7, 2),
(8, 2),
(9, 3),
(10, 3),
(11, 3),
(11, 4),
(12, 3),
(13, 4),
(14, 4),
(15, 4),
(16, 4),
(16, 5),
(17, 5),
(18, 5),
(19, 5),
(20, 6),
(1, 6),
(2, 6),
(3, 6),
(4, 6),
(5, 6),
(6, 6),
(7, 6),
(8, 6),
(9, 6),
(10, 6),
(11, 6);