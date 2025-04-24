# postfix_sentlog_inspector
Script Bash para análise de logs do servidor de e-mail **Postfix** no Ubuntu 22.04. Permite a inspeção de mensagens enviadas por um remetente específico, exibindo data e destinatário.

## 📋 Funcionalidade
- Validação de endereço de e-mail informado como parâmetro
- Busca completa por mensagens enviadas por esse remetente
- Extração da data de envio e destinatários
- Apresentação dos resultados em formato de tabela na tela

## 🛠️ Requisitos
- Distribuição Ubuntu 22.04 (ou compatível com logs padrão do Postfix)
- Permissão de leitura no arquivo `/var/log/mail.log`
- Permissão de leitura na fila de mensagens do Postfix (`/var/spool/postfix/deferred`)

## 🚀 Como usar
```bash
chmod +x postfix_sentlog_inspector.sh
./postfix_sentlog_inspector.sh remetente@dominio.com
Substitua remetente@dominio.com pelo endereço de e-mail de origem que deseja filtrar.

🧪 Exemplo de saída
DATA                DESTINATÁRIO         
-----------------------------------------
Apr 24 10:22:01     usuario@exemplo.com  
Apr 24 10:22:02     gerente@exemplo.com  

Mensagens muito antigas podem não estar mais disponíveis nesta fila
O script foca em precisão e validação rigorosa de dados

📁 Estrutura
postfix_sentlog_inspector.sh: script principal
README.md: este arquivo de documentação
