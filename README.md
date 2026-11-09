# EJFlow — Observatório de Projetos (Banco do Sistema)

Dashboard acadêmico e executivo de **gestão de projetos**, criado a partir do arquivo `projeto_banco_de_dados.sql` fornecido. Utiliza **MySQL como única fonte de dados**. Não contém números demonstrativos embutidos, não reimporta CSV e não altera tabelas.

## 1. O que este projeto analisa

As 7 tabelas presentes no SQL: `empresas`, `clientes`, `projetos`, `membros`, `demanda`, `sprints`, `tarefas`.

- **Visão geral:** empresas, projetos, sprints, tarefas, percentual concluído, gráficos e insights dinâmicos.
- **Projetos:** comparação sem índice sintético; detalhamento de cliente, descrição e tarefas.
- **Sprints e tarefas:** calendário, duração de períodos válidos, conclusão por sprint, variação das entregas por projeto e filtro de backlog fora de sprint.
- **Clientes e equipes:** relacionamentos entre clientes e projetos; integrantes e cargos *por empresa*.
- **Qualidade e metodologia:** relação com os indicadores do relatório da UFRN, auditoria do banco completo, catálogo de tabelas, consultas de referência e exportação em ZIP.

O painel consulta o banco operacional. O schema histórico `analise_agil`, descrito no relatório, tem outra granularidade e registra vínculos de tarefas com várias sprints. No EJFlow, o backlog fora de sprint conta tarefas ainda não concluídas com `id_sprint` vazio. O percentual por sprint considera apenas vínculos em que tarefa e sprint pertencem ao mesmo projeto. Sprints vazias entram com zero no volume de entregas e ficam sem percentual.

**Regras de interpretação:** a taxa de conclusão é `(número de tarefas com estado = concluida)/(total de tarefas) × 100`. O SQL **não possui story points, prazo por tarefa, ligação direta de membro a projeto nem histórico de alterações de tarefas**. Assim, estes indicadores não são inventados pelo dashboard.

## 2. Executar no Windows com VS Code

1. Extraia o ZIP e abra esta pasta no VS Code.
2. Crie `.streamlit/secrets.toml` a partir de `.streamlit/secrets.toml.example`.
3. Preencha usuário, senha, host, porta e **o nome real do schema** onde as 7 tabelas foram criadas.
4. Abra um terminal PowerShell **na pasta do projeto** e execute:

```powershell
py -m pip install -r requirements.txt
py diagnostico_mysql.py
py -m streamlit run app.py --server.port 8503
```

Acesse `http://localhost:8503`.

> O SQL anexado seleciona `projeto_banco_de_dados` com `USE` e pressupõe que o schema já exista. Configure `MYSQL_DATABASE` com o nome usado na instalação. O schema `analise_agil` pertence à etapa de pesquisa com dados públicos.

Se ainda não criou o banco operacional e quer experimentar somente os exemplos do anexo, consulte `sql/banco_sistema_exemplo_limpo.sql`. Ele cria o schema separado `banco_sistema_demo` com os **registros MOCK originais**. **Execute-o apenas uma vez em um banco vazio**, pois são comandos CREATE/INSERT e repetidos podem gerar erros. O dashboard em si não executa esse arquivo.

## 3. Corrigir falhas de conexão

Execute `py diagnostico_mysql.py`: o script verifica conexão e presença das 7 tabelas. Não compartilhe o arquivo `secrets.toml` ou a senha. Erro 1045 indica normalmente login inválido; erro 1049 indica schema inexistente; erro 1146 indica tabela ausente; erro 2003 indica servidor inacessível. O app esconde o detalhe de erro dos visitantes para não vazar informação sensível.

**O usuário `MYSQL_USER` normalmente é `root` ou outro usuário criado, e não o nome do schema.** Confira `SELECT CURRENT_USER(), DATABASE();` no Workbench.

## 4. Publicação para compartilhar

Consulte `PUBLICACAO.md` para hospedar em URL pública com credenciais privadas. **Não publique uma conta `root`**. Crie um usuário apenas `SELECT` e conecte a um servidor MySQL acessível pelo host de execução do Streamlit. `localhost` funciona apenas se MySQL e Streamlit estiverem rodando **no mesmo computador/servidor**.

## 5. Observações sobre o SQL anexado

O script original inclui `INSERT`, `UPDATE`, `DELETE`, `ALTER` e `DROP VIEW`; inclui também um trecho de view que aparenta um erro de coluna (`membros.emailtrabalha_em`). Esses comandos **não** são executados pelo painel. A versão de exemplo inclui as estruturas e inserções iniciais do documento, mas não reproduz alterações destrutivas nem o trecho de view inválido. As métricas refletem o banco que for consultado, inclusive se já tiver sido modificado.

O arquivo original traz **dados MOCK** para empresas, pessoas, clientes e projetos. Não trate resultados obtidos exclusivamente nesses exemplos como evidências de produtividade real.

## 6. Estrutura da pasta

```text
EJFlow_Gestao_Projetos_MySQL/
├── app.py
├── data_access.py
├── diagnostico_mysql.py
├── requirements.txt
├── .streamlit/
│   ├── config.toml
│   └── secrets.toml.example
├── .gitignore
├── PUBLICACAO.md
├── ROTEIRO_APRESENTACAO.md
└── sql/
    └── banco_sistema_exemplo_limpo.sql
```
