-- MATERIAL OPCIONAL, BASEADO NOS REGISTROS MOCK DO SQL FORNECIDO.
-- CUIDADO: CRIA UM SCHEMA NOVO, SEPARADO DO BANCO ORIGINAL.
-- NÃO contém DROP, UPDATE ou DELETE.
CREATE DATABASE IF NOT EXISTS banco_sistema_demo CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE banco_sistema_demo;

CREATE TABLE empresas (
  id INT PRIMARY KEY,
  nome VARCHAR(255) NOT NULL,
  rep VARCHAR(255) NOT NULL
);
CREATE TABLE clientes (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE,
  CONSTRAINT chk_email_formato CHECK (email REGEXP '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$')
);
CREATE TABLE projetos (
  id INT PRIMARY KEY,
  id_empresa INT NOT NULL,
  nome VARCHAR(255) NOT NULL,
  descricao VARCHAR(1000) NOT NULL,
  CONSTRAINT fk_projeto_empresa FOREIGN KEY (id_empresa) REFERENCES empresas(id)
);
CREATE TABLE membros (
  id INT PRIMARY KEY,
  id_empresa INT NOT NULL,
  nome VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL,
  cargo VARCHAR(100) NOT NULL,
  CONSTRAINT fk_membro_empresa FOREIGN KEY (id_empresa) REFERENCES empresas(id)
);
CREATE TABLE demanda (
  id_projeto INT NOT NULL,
  id_cliente INT NOT NULL,
  CONSTRAINT pk_demanda PRIMARY KEY (id_projeto,id_cliente),
  CONSTRAINT fk_p_client FOREIGN KEY (id_projeto) REFERENCES projetos(id) ON DELETE CASCADE,
  CONSTRAINT fk_c_project FOREIGN KEY (id_cliente) REFERENCES clientes(id) ON DELETE CASCADE
);
CREATE TABLE sprints (
  id INT AUTO_INCREMENT PRIMARY KEY,
  id_projeto INT NOT NULL,
  isDone BOOL,
  data_in DATETIME,
  data_fin DATETIME,
  CONSTRAINT fk_sprint_projeto FOREIGN KEY (id_projeto) REFERENCES projetos(id)
);
CREATE TABLE tarefas (
  id INT AUTO_INCREMENT PRIMARY KEY,
  id_projeto INT NOT NULL,
  id_sprint INT,
  estado VARCHAR(20),
  descricao VARCHAR(1000),
  data_cria DATETIME,
  data_fin DATETIME,
  CONSTRAINT fk_tarefa_sprint FOREIGN KEY (id_sprint) REFERENCES sprints(id),
  CONSTRAINT fk_tarefa_projeto FOREIGN KEY (id_projeto) REFERENCES projetos(id),
  CONSTRAINT chk_estado_tarefa CHECK (estado IN ('nao_iniciada','em_andamento','concluida'))
);

-- Estes registros são MOCK, copiados das inserções iniciais do arquivo anexado.
INSERT INTO empresas (id,nome,rep) VALUES
(1,'Tech Solutions Ltda','Carlos Silva'),
(2,'Inovação & Futuro S.A.','Ana Souza'),
(3,'Global Logistics Corp','Marcos Oliveira');
INSERT INTO clientes (nome,email) VALUES
('Empresa Parceira Alpha','contato@alpha.com'),
('Consultoria Beta Corp','suporte@betacorp.com.br'),
('Comércio Gama','comercial@gama.net');
INSERT INTO projetos (id,id_empresa,nome,descricao) VALUES
(101,1,'Sistema de E-commerce','Desenvolvimento de plataforma de vendas online com integração de pagamentos.'),
(102,1,'App Mobile de Entregas','Aplicativo para acompanhamento de rotas e entregas em tempo real.'),
(103,2,'Portal de RH Interno','Sistema web para gestão de férias, holerites e benefícios dos funcionários.'),
(104,3,'Dashboard de Logística','Painel analítico para monitoramento da frota e custos de frete.');
INSERT INTO membros (id,id_empresa,nome,email,cargo) VALUES
(1,1,'João Pedro','joao.pedro@techsolutions.com','Desenvolvedor Full Stack'),
(2,1,'Mariana Lima','mariana.lima@techsolutions.com','Product Owner'),
(3,2,'Lucas Mendes','lucas.mendes@inovacao.com','Arquiteto de Software'),
(4,3,'Beatriz Costa','beatriz.costa@global.com','Analista de Dados');
INSERT INTO demanda (id_projeto,id_cliente) VALUES (101,1),(102,1),(103,2),(104,3);
INSERT INTO sprints (id_projeto,isDone,data_in,data_fin) VALUES
(101,1,'2026-03-01 08:00:00','2026-03-15 18:00:00'),
(101,0,'2026-03-16 08:00:00','2026-03-30 18:00:00'),
(102,0,'2026-03-05 08:00:00','2026-03-20 18:00:00'),
(103,1,'2026-02-10 08:00:00','2026-02-24 18:00:00');
INSERT INTO tarefas (id_projeto,id_sprint,estado,descricao,data_cria,data_fin) VALUES
(101,1,'concluida','Configurar o ambiente de desenvolvimento e banco de dados inicial','2026-03-01 09:00:00','2026-03-03 17:00:00'),
(101,1,'concluida','Desenvolver a tela de login e autenticação JWT','2026-03-04 09:00:00','2026-03-10 17:00:00'),
(101,2,'em_andamento','Integrar gateway de pagamento (Cartão e PIX)','2026-03-16 10:00:00',NULL),
(101,2,'nao_iniciada','Realizar testes de carga na API de produtos','2026-03-16 10:00:00',NULL),
(102,3,'em_andamento','Criar wireframes das telas principais do aplicativo','2026-03-05 08:30:00',NULL),
(103,4,'concluida','Mapear requisitos de regras de negócio de férias','2026-02-10 09:00:00','2026-02-15 16:00:00');
