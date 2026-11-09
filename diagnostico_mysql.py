"""Teste local detalhado. Não imprima a senha."""
import os
from pathlib import Path
import tomllib
import mysql.connector

path = Path(__file__).resolve().parent / '.streamlit' / 'secrets.toml'
if not path.exists() and not os.getenv('MYSQL_PASSWORD'):
    print('ERRO: não foi encontrado .streamlit/secrets.toml nem MYSQL_PASSWORD no ambiente.')
    raise SystemExit(1)
raw = tomllib.loads(path.read_text(encoding='utf-8')) if path.exists() else {}
def get(k,default):return os.getenv(k) or raw.get(k,default)
config=dict(host=get('MYSQL_HOST','127.0.0.1'),port=int(get('MYSQL_PORT',3306)),
            user=get('MYSQL_USER','root'), password=get('MYSQL_PASSWORD',''),
            database=get('MYSQL_DATABASE','banco_sistema_demo'))
print('Servidor:',config['host'], 'Porta:',config['port'],'Usuário:',config['user'],'Schema:',config['database'])
try:
    conn=mysql.connector.connect(**config,connection_timeout=8,use_pure=True)
    cursor=conn.cursor()
    cursor.execute('SELECT DATABASE(), CURRENT_USER()')
    print('OK conexão:',cursor.fetchone())
    for table in ('empresas','clientes','projetos','membros','demanda','sprints','tarefas'):
        cursor.execute(f'SELECT COUNT(*) FROM `{table}`')
        print('OK tabela:',table,'—',cursor.fetchone()[0],'linhas')
    print('SUCESSO: o MySQL está acessível e as sete tabelas existem.')
except mysql.connector.Error as e:
    print('FALHA MySQL:',f'código {e.errno}',str(e))
    raise SystemExit(1)
finally:
    try: conn.close()
    except NameError:pass
