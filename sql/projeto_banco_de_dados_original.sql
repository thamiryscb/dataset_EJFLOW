-- TABELA DE CLIENTES
CREATE TABLE clientes(id INT AUTO_INCREMENT PRIMARY KEY, 
		                 nome VARCHAR(255) NOT NULL,
			     email VARCHAR(255) NOT NULL UNIQUE,
                                        CONSTRAINT chk_email_formato CHECK (email REGEXP '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$'
    ));

-- TABELA DE EMPRESAS
CREATE TABLE empresas(id INT PRIMARY KEY, 
			         nome VARCHAR(255) NOT NULL,
			         rep VARCHAR(255) NOT NULL
);

-- TABELA DE PROJETOS
CREATE TABLE projetos(id INT PRIMARY KEY, 
			      id_empresa INT NOT NULL,
                     	       nome VARCHAR(255) NOT NULL,
                                          descricao VARCHAR(1000) NOT NULL,
                                          CONSTRAINT fk_projeto_empresa FOREIGN KEY (id_empresa) REFERENCES empresas(id)
);

-- TABELA DE MEMBROS
CREATE TABLE membros(id INT PRIMARY KEY, 
		       	         id_empresa INT NOT NULL,
			         nome VARCHAR(255) NOT NULL,
         email VARCHAR(255) NOT NULL,
                     cargo VARCHAR(100) NOT NULL,
                     CONSTRAINT fk_membro_empresa FOREIGN KEY (id_empresa) REFERENCES empresas(id)
);

-- TABELA DE DEMANDAS
CREATE TABLE demanda (
    id_projeto INT NOT NULL, 
    id_cliente INT NOT NULL,
    
    -- Define a chave primária composta (nenhum par [projeto, cliente] pode se repetir)
    CONSTRAINT pk_demanda PRIMARY KEY (id_projeto, id_cliente),
    
    CONSTRAINT fk_p_client FOREIGN KEY (id_projeto) 
        REFERENCES projetos(id) 
        ON DELETE CASCADE,
        
    CONSTRAINT fk_c_project FOREIGN KEY (id_cliente) 
        REFERENCES clientes(id) 
        ON DELETE CASCADE
);

-- TABELA DE SPRINTS
CREATE TABLE sprints(id INT AUTO_INCREMENT PRIMARY KEY, 
					 id_projeto INT NOT NULL,
                     isDone BOOL,
                     data_in DATETIME,
                     data_fin DATETIME,
					 CONSTRAINT fk_sprint_projeto FOREIGN KEY (id_projeto) REFERENCES projetos(id)
);

-- TABELA DE TAREFAS
CREATE TABLE TAREFAS(id INT AUTO_INCREMENT PRIMARY KEY, 
	         id_projeto INT NOT NULL,
                     id_sprint INT,
                     estado VARCHAR(20),
                     descricao VARCHAR(1000),
                     data_cria DATETIME,
                     data_fin DATETIME,
	         CONSTRAINT fk_tarefa_sprint FOREIGN KEY (id_sprint) REFERENCES sprints(id),
                     CONSTRAINT fk_tarefa_projeto FOREIGN KEY (id_projeto) REFERENCES projetos(id)
);

ALTER TABLE TAREFAS 
ADD CONSTRAINT chk_estado_tarefa CHECK (estado IN ('nao_iniciada', 'em_andamento', 'concluida'));


-- MOCK DE INSERÇÃO
INSERT INTO empresas (id, nome, rep) VALUES 
(1, 'Tech Solutions Ltda', 'Carlos Silva'),
(2, 'Inovação & Futuro S.A.', 'Ana Souza'),
(3, 'Global Logistics Corp', 'Marcos Oliveira');

INSERT INTO clientes (nome, email) VALUES 
('Empresa Parceira Alpha', 'contato@alpha.com'),
('Consultoria Beta Corp', 'suporte@betacorp.com.br'),
('Comércio Gama', 'comercial@gama.net');

INSERT INTO projetos (id, id_empresa, nome, descricao) VALUES 
(101, 1, 'Sistema de E-commerce', 'Desenvolvimento de plataforma de vendas online com integração de pagamentos.'),
(102, 1, 'App Mobile de Entregas', 'Aplicativo para acompanhamento de rotas e entregas em tempo real.'),
(103, 2, 'Portal de RH Interno', 'Sistema web para gestão de férias, holerites e benefícios dos funcionários.'),
(104, 3, 'Dashboard de Logística', 'Painel analítico para monitoramento da frota e custos de frete.');

INSERT INTO membros (id, id_empresa, nome, email, cargo) VALUES 
(1, 1, 'João Pedro', 'joao.pedro@techsolutions.com', 'Desenvolvedor Full Stack'),
(2, 1, 'Mariana Lima', 'mariana.lima@techsolutions.com', 'Product Owner'),
(3, 2, 'Lucas Mendes', 'lucas.mendes@inovacao.com', 'Arquiteto de Software'),
(4, 3, 'Beatriz Costa', 'beatriz.costa@global.com', 'Analista de Dados');

INSERT INTO demanda (id_projeto, id_cliente) VALUES 
(101, 1), -- Projeto 101 atende o Cliente 1
(102, 1), -- Projeto 102 atende o Cliente 1
(103, 2), -- Projeto 103 atende o Cliente 2
(104, 3); -- Projeto 104 atende o Cliente 3

INSERT INTO sprints (id_projeto, isDone, data_in, data_fin) VALUES 
(101, 1, '2026-03-01 08:00:00', '2026-03-15 18:00:00'),
(101, 0, '2026-03-16 08:00:00', '2026-03-30 18:00:00'),
(102, 0, '2026-03-05 08:00:00', '2026-03-20 18:00:00'),
(103, 1, '2026-02-10 08:00:00', '2026-02-24 18:00:00');

INSERT INTO TAREFAS (id_projeto, id_sprint, estado, descricao, data_cria, data_fin) VALUES 
(101, 1, 'concluida', 'Configurar o ambiente de desenvolvimento e banco de dados inicial', '2026-03-01 09:00:00', '2026-03-03 17:00:00'),
(101, 1, 'concluida', 'Desenvolver a tela de login e autenticação JWT', '2026-03-04 09:00:00', '2026-03-10 17:00:00'),
(101, 2, 'em_andamento', 'Integrar gateway de pagamento (Cartão e PIX)', '2026-03-16 10:00:00', NULL),
(101, 2, 'nao_iniciada', 'Realizar testes de carga na API de produtos', '2026-03-16 10:00:00', NULL),
(102, 3, 'em_andamento', 'Criar wireframes das telas principais do aplicativo', '2026-03-05 08:30:00', NULL),
(103, 4, 'concluida', 'Mapear requisitos de regras de negócio de férias', '2026-02-10 09:00:00', '2026-02-15 16:00:00');

-- DESENVOLVER CONSULTAS COM JOIN, FILTROS E AGREGAÇÕES. 
-- ASSOCIAR O PROJETO AO CLIENTE
SELECT * FROM projetos 
JOIN demanda on projetos.id = demanda.id_projeto 
JOIN clientes on clientes.id = demanda.id_cliente;

-- SELECIONAR PROJETOS DA EMPRESA 1
SELECT * FROM projetos WHERE id_empresa = 1;

-- SELECIONAR TAREFAS ASSOCIADAS AO PROJETO 101
SELECT * FROM tarefas WHERE id_projeto=101;

-- SELECIONAR O NOME E O EMAIL DOS MEMBROS DA EMPRESA 2
SELECT nome, email FROM membros WHERE id_empresa = 2;

-- INSERT TAREFA NOVA
INSERT INTO TAREFAS (id_projeto, id_sprint, estado, descricao, data_cria, data_fin) VALUES 
(101, 1, 'concluida', 'Configurar o ambiente de desenvolvimento e banco de dados inicial', '2026-03-01 09:00:00', '2026-03-03 17:00:00');

-- DELETE DE MEMBRO DE UMA EMPRESA
DELETE FROM membros WHERE nome="Lucas Mendes";

-- UPDATE DO NOME DE UM PROJETO
UPDATE projetos SET nome="Pingo-Commerce" WHERE nome="Sistema de E-commerce";

-- VIEW PARA TRABALHA_EM
CREATE VIEW trabalha_em AS
SELECT membros.nome AS nome_funcionario, membros.emailtrabalha_em, empresas.nome AS nome_empresa
FROM membros
INNER JOIN empresas ON empresas.id = membros.id_empresa;

-- CONSULTA PARA VIEW DO TRABALHA_EM
SELECT * FROM trabalha_em;

-- VIEW PARA ASSOCIAR CLIENTE A EMPRESA
CREATE VIEW cliente_empresa AS
SELECT empresas.id AS id_empresa, empresas.nome AS nome_empresa, clientes.id AS id_cliente, clientes.nome AS nome_cliente
FROM empresas
JOIN projetos ON projetos.id_empresa = empresas.id
JOIN demanda ON projetos.id = demanda.id_projeto 
JOIN clientes ON demanda.id_cliente = clientes.id
GROUP BY empresas.id, clientes.id, empresas.nome, clientes.nome;

-- CONSULTA PARA VIEW DO cliente_empresa
SELECT * FROM cliente_empresa;

-- ALTERA A TABELA DE CLIENTES PARA TER ID_EMPRESA
ALTER TABLE clientes
ADD id_empresa INT NOT NULL;

-- DELETE VIEW 
DROP VIEW cliente_empresa;

-- UPDATE
UPDATE clientes SET id_empresa=1 WHERE nome="Empresa Parceira Alpha";
UPDATE clientes SET id_empresa=2 WHERE nome="Consultoria Beta Corp";
UPDATE clientes SET id_empresa=3 WHERE nome="Comércio Gama";

-- ALTERA A TABELA DE CLIENTES PARA ADICIONAR A RESTRICAO
ALTER TABLE clientes
ADD CONSTRAINT fk_cliente_empresa FOREIGN KEY (id_empresa)
REFERENCES empresas(id) ON DELETE CASCADE;

-- QUANTIDADE DE PROJETOS DA EMPRESA 1
SELECT COUNT(*) FROM projetos WHERE id_empresa=1;

-- QUANTIDADE DE CLIENTES CADASTRADOS NO SISTEMA
SELECT COUNT(*) FROM clientes;

-- QUANTIDADE DE CLIENTES CADASTRADOS NO SISTEMA
SELECT COUNT(*) FROM clientes;

-- QUANTIDADE DE TAREFAS CONCLUIDAS DO PROJETO 101
SELECT COUNT(data_fin) FROM TAREFAS WHERE id_projeto=101;

-- QUANTAS TAREFAS EXISTEM POR ESTADO
SELECT estado, COUNT(*) AS total FROM TAREFAS GROUP BY estado;

-- DATA DA PRIMEIRA E DA ULTIMA SPRINT
SELECT 
    MIN(data_in) AS data_inicio_primeira_sprint,
    MAX(data_fin) AS data_fim_ultima_sprint
FROM sprints WHERE id_projeto=101;

-- MEDIA DE DIAS DA SPRINT
SELECT AVG(DATEDIFF(data_fin, data_in)) AS media_dias_por_sprint FROM sprints;

