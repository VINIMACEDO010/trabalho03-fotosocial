# Trabalho 03 - Linux, Shell Script e Cloud Computing

## Aluno
Vinicius Policarpo Macedo

## Tema
14 - Infraestrutura para uma Rede Social de Fotos

## Descricao do Projeto

Este projeto simula a infraestrutura operacional de uma rede social de compartilhamento de fotos, executada em um container Ubuntu gerenciado via Docker. O ambiente representa um cenario realista de cloud computing onde um servidor Linux precisa servir paginas web, processar imagens via ImageMagick, controlar permissoes de acesso por perfil de usuario, realizar backups automatizados e monitorar os recursos do sistema.

O trabalho foi desenvolvido no contexto da disciplina de Cloud Computing do curso de Sistemas de Informacao da UNIDAVI, simulando o papel de um profissional DevOps junior responsavel por toda a automacao operacional da plataforma.

## Tecnologias Utilizadas

- Linux Ubuntu 22.04 LTS
- Docker e Docker Compose
- Apache2 (servidor web)
- ImageMagick (processamento de fotos)
- Shell Script (Bash)
- GitHub (controle de versao)
- DockerHub (imagem publicada)

## Estrutura do Projeto
trabalho03-cloud-shell/
├── Dockerfile
├── docker-compose.yml
├── README.md
├── scripts/
│   ├── 01_update.sh
│   ├── 02_apache.sh
│   ├── 03_estrutura.sh
│   ├── 04_backup.sh
│   ├── 05_deploy.sh
│   ├── 06_processos.sh
│   ├── 07_monitoramento.sh
│   ├── 08_usuarios_permissoes.sh
│   ├── 09_relatorio.sh
│   └── menu.sh
├── source/
│   ├── index.html
│   ├── sobre.html
│   └── assets/
├── backups/
├── logs/
└── evidencias/

Diretorios da aplicacao dentro do container:
/app/fotosocial/
├── fotos/originais/
├── fotos/processadas/
├── fotos/pendentes_moderacao/
├── albums/publicos/
├── albums/privados/
├── thumbnails/pequeno/
├── thumbnails/medio/
├── thumbnails/grande/
├── usuarios/perfis/
├── usuarios/avatares/
├── publicacoes/feed/
├── publicacoes/stories/
├── logs/
└── backups/

## Como Executar

### Pre-requisitos
- Docker instalado
- Docker Compose instalado

### 1. Clonar o repositorio

```bash
git clone <url-do-repositorio>
cd trabalho03-cloud-shell
```

### 2. Subir o container

```bash
docker compose up -d --build
```

### 3. Verificar se esta rodando

```bash
docker ps
```

### 4. Acessar o container

```bash
docker exec -it trabalho03-linux bash
```

### 5. Dar permissao e executar o menu

```bash
cd /app/scripts
chmod +x *.sh
./menu.sh
```

## Como Acessar o Apache no Navegador

Apos subir o container, acesse:
http://localhost:8080

## Scripts Disponiveis

| Script | Descricao |
|---|---|
| 01_update.sh | Atualiza os pacotes do sistema Ubuntu |
| 02_apache.sh | Instala Apache2 e ImageMagick, valida servico |
| 03_estrutura.sh | Cria hierarquia de diretorios da rede social |
| 04_backup.sh | Gera backup .tar.gz com data/hora |
| 05_deploy.sh | Publica arquivos do source/ no Apache |
| 06_processos.sh | Lista, busca e encerra processos |
| 07_monitoramento.sh | Coleta CPU, RAM, disco e status do Apache |
| 08_usuarios_permissoes.sh | Cria grupos, usuarios e configura permissoes |
| 09_relatorio.sh | Gera relatorio operacional completo |
| menu.sh | Menu interativo que integra todos os scripts |

## Como Executar Cada Script

```bash
./01_update.sh
./02_apache.sh
./03_estrutura.sh
./04_backup.sh
./05_deploy.sh
./06_processos.sh listar
./06_processos.sh buscar apache2
./06_processos.sh matar 1234
./07_monitoramento.sh
./08_usuarios_permissoes.sh
./09_relatorio.sh
```

## Como Executar o Menu Principal

```bash
cd /app/scripts
./menu.sh
```

## Evidencias

Ver pasta evidencias/ no repositorio com prints de:
- Container em execucao
- Volume Docker configurado
- Scripts com permissao de execucao
- Execucao de cada script
- Site acessivel em http://localhost:8080
- Backup .tar.gz gerado
- Relatorio operacional gerado
- Imagem publicada no DockerHub

## DockerHub
https://hub.docker.com/r/vinimacedo010/trabalho03-fotosocial

## Uso de IA

Foi utilizada inteligencia artificial como ferramenta de apoio durante o desenvolvimento deste trabalho, especificamente nas seguintes etapas:

- Auxilio na documentacao tecnica do projeto (README e comentarios dos scripts)
- Revisao e correcao de erros de sintaxe nos scripts Shell
- Sugestao de boas praticas para organizacao de diretorios e permissoes Linux

Todos os scripts foram analisados, compreendidos e testados pelo aluno antes da entrega. O aluno e capaz de explicar o funcionamento de cada script, a logica de cada funcao e as decisoes tecnicas tomadas ao longo do projeto.

Ferramenta utilizada: Claude (Anthropic)

## Dificuldades Encontradas

- Gerenciamento do Apache em containers Docker sem systemd requer uso de apache2ctl em vez de systemctl
- Permissoes de diretorio precisam de atencao especial para nao usar chmod 777 desnecessariamente
- O calculo de CPU foi feito via /proc/stat para garantir compatibilidade com Ubuntu sem dependencias extras