# Roteiro de apresentação (4–5 minutos)

**0:00–0:40 — Contexto.** "O sistema organiza empresas, clientes, projetos, equipes e ciclos de execução em um banco relacional. O dashboard usa esses registros para trazer visibilidade gerencial."

**0:40–1:30 — Visão executiva.** Mostre total de projetos, sprints, tarefas e taxa de conclusão, sempre reconhecendo a fonte MySQL. Use os filtros de empresa e projeto para demonstrar interatividade.

**1:30–2:20 — Projetos.** Mostre o portfólio, escolha um projeto e destaque seus clientes e sprints. Explique os relacionamentos `projetos.id_empresa`, `demanda` e `tarefas.id_projeto`.

**2:20–3:10 — Sprints.** Mostre a linha do tempo, estado das sprints e tarefas vinculadas. Esclareça que `isDone` não é igual à conclusão de todas as tarefas.

**3:10–4:00 — Pessoas e qualidade.** Mostre a distribuição de membros por empresa e as verificações de dados. Destaque que o modelo não relaciona membros diretamente a projetos.

**4:00–4:30 — Valor do sistema.** "O banco oferece rastreabilidade, análises por projeto e capacidade para dashboards futuros; novos indicadores podem ser introduzidos quando o modelo capturar estimativas, prazos e histórico de mudanças."

## Cuidados acadêmicos

- Dados marcados `MOCK DE INSERÇÃO` são demonstrativos, não desempenho real.
- Não inventar velocidade Scrum em story points: não há story points no SQL.
- Os filtros de tarefas na tabela exploratória não alteram os indicadores gerais.
- Um projeto pode ter múltiplos clientes; evite somar tarefas após JOIN direto com `demanda`.
