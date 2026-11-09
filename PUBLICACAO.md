# Como permitir acesso a outras pessoas

O painel roda em um servidor Streamlit; os visitantes acessam a URL sem preencher a senha do MySQL.

## Publicação permanente

1. Publique estes arquivos em um repositório GitHub **sem** `.streamlit/secrets.toml`.
2. Disponibilize o MySQL em um serviço acessível pelo servidor que hospedará o Streamlit; mantenha firewall e TLS habilitados. **Não basta `MYSQL_HOST=127.0.0.1` se o Streamlit estiver na nuvem.**
3. Crie um usuário MySQL de somente leitura, por exemplo (ajuste nome do schema e senha antes de executar):

```sql
CREATE USER 'dashboard_leitura'@'HOST_DO_SERVIDOR' IDENTIFIED BY 'SENHA_FORTE_AQUI';
GRANT SELECT ON banco_sistema_demo.* TO 'dashboard_leitura'@'HOST_DO_SERVIDOR';
```

Configure o host com a origem permitida e, se suportado, exija conexão TLS. Evite conceder privilégios amplos ou usar `root`.

4. No provedor de hospedagem Streamlit, configure os seguintes Secrets privados:

```toml
MYSQL_HOST = "host-do-mysql-remoto"
MYSQL_PORT = 3306
MYSQL_USER = "dashboard_leitura"
MYSQL_PASSWORD = "SENHA_PRIVADA"
MYSQL_DATABASE = "NOME_REAL_DO_SCHEMA"
```

5. Publique com entrada `app.py` e teste a URL em janela anônima. A hospedagem é uma etapa externa; este pacote **não publica automaticamente**.

> Este aplicativo usa conexão MySQL padrão com `mysql-connector-python`. Para publicação em MySQL remoto, prefira túnel/infraestrutura privada com TLS e configuração de certificados conforme o provedor. Não exponha o servidor MySQL indiscriminadamente na Internet.

## Observação sobre privacidade

O SQL contém nomes e e-mails de pessoas. Este painel não exibe os e-mails, mas pode revelar nomes de empresas, projetos e membros em agregações. Revise a base e as permissões antes de disponibilizar a URL ao público. Para um demo aberto, use o schema fictício separado.
