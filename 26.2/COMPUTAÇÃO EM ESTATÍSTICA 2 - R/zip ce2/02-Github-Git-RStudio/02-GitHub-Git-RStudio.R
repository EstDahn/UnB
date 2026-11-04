# --- Script de Aula: Um Fluxo de Trabalho para Git e GitHub com RStudio ---
# Autor: IA Gemini instruída por dmp
# Data atualização: 2025-08-26
# Data: 2025-07-15
# Objetivo: Guiar alunos de R através da configuração inicial e do fluxo de
#           trabalho diário para usar Git e GitHub para controle de versão
#           e colaboração, diretamente do RStudio.

# --------------------------------------------------------------------------
# --- PARTE 1: O "PORQUÊ" E A CONFIGURAÇÃO ÚNICA ---
# --------------------------------------------------------------------------
# Esta parte é a mais longa, mas só precisa ser feita UMA VEZ por computador.

# --- Tópico 1: Por que usar Controle de Versão? (Discussão) ---

# Antes de qualquer código, vamos discutir o problema que estamos resolvendo.
# Pense em uma pasta de projeto com arquivos como:
# - Relatorio_Final.Rmd
# - Relatorio_Final_v2.Rmd
# - Relatorio_Final_AGORA_VAI.Rmd
# - Relatorio_Final_VERSAO_DA_MARCIA.Rmd

# Este método é caótico e propenso a erros. Um Sistema de Controle de Versão (VCS) resolve isso.
# Benefícios principais:
# 1. HISTÓRICO: É uma máquina do tempo para o seu código. Você pode ver cada
#    mudança feita e reverter para qualquer versão anterior.
# 2. COLABORAÇÃO: Permite que várias pessoas trabalhem no mesmo projeto de
#    forma estruturada, sem enviar arquivos por e-mail.
# 3. BACKUP: O GitHub funciona como um backup na nuvem para todo o seu projeto.

# --- Tópico 2: Git vs. GitHub (Conceitos) ---

# - Git: É o software de controle de versão que roda no SEU computador. Ele
#   rastreia as mudanças nos seus arquivos. É o motor.
# - GitHub: É um site (uma empresa da Microsoft) que hospeda repositórios Git.
#   É a "rede social para código", onde você armazena seu trabalho na nuvem e
#   colabora com outros.

# --- Tópico 3: Configuração Inicial (Ações Práticas) ---

# PASSO A: Instalar os pacotes R necessários
# O pacote `usethis` nos ajuda a automatizar muitas tarefas de configuração.
# O pacote `gitcreds` ajuda a gerenciar nossas credenciais de forma segura.
install.packages("usethis")
install.packages("gitcreds")

# PASSO B: Criar uma conta no GitHub
# Se você ainda não tem uma, vá para https://github.com/ e crie uma conta gratuita.

# PASSO C: Instalar o Git no seu computador
# O RStudio precisa que o programa Git esteja instalado na sua máquina.
# - Windows: Vá para https://git-scm.com/download/win e baixe o instalador.
#   Aceite todas as opções padrão durante a instalação.
# - Mac: Abra o Terminal (em Aplicativos > Utilitários) e digite `git --version`.
#   Se o Git não estiver instalado, ele solicitará que você o instale.
# - Após a instalação, REINICIE O RSTUDIO.

# PASSO D: Apresente-se ao Git
# Precisamos dizer ao Git seu nome e e-mail. Estes dados serão anexados a
# cada "commit" (salvamento) que você fizer.
# Use o mesmo e-mail que você usou para sua conta do GitHub.
# Execute estes comandos no Console R.
library(usethis)
use_git_config(
  user.name = "SEU NOME AQUI", # Substitua pelo seu nome
  user.email = "seu.email@exemplo.com" # Substitua pelo seu e-mail do GitHub
)

# PASSO E: Conectar RStudio ao GitHub (A Etapa Mais Importante)
# O RStudio precisa de uma forma segura de se comunicar com o GitHub. A melhor
# maneira é usar um Personal Access Token (PAT), que funciona como uma senha
# específica para um aplicativo.

# 1. Este comando abrirá seu navegador na página correta do GitHub para criar um token.
create_github_token()

# 2. Na página do GitHub:
#    - Em "Note", dê um nome ao token (ex: "Token RStudio CE2R").
#    - Em "Expiration", você pode escolher um período (ex: 90 dias).
#    - Em "Select scopes", marque as caixas para "repo" e "workflow".
#    - Clique em "Generate token".

# 3. COPIE O TOKEN! Uma sequência como 'ghp_aBcDeFgHiJkLmNoPqRsTuVwXyZ...'.
#    Esta é a ÚNICA vez que você verá o token. Copie-o para um local seguro temporariamente.

# 4. Volte para o RStudio e execute o seguinte comando no Console.
#    Ele pedirá para você colar o token que você acabou de copiar.
library(gitcreds)
gitcreds_set()

# Cole seu token no Console quando solicitado e pressione Enter.
# Pronto! A configuração inicial está completa. Você não precisará fazer isso de novo.

# --------------------------------------------------------------------------
# --- PARTE 2: O FLUXO DE TRABALHO DIÁRIO NO RSTUDIO ---
# --------------------------------------------------------------------------
# Esta parte mostra o ciclo que você usará todos os dias.

# --- Tópico 4: Criando seu Primeiro Projeto com Git e GitHub ---

# A maneira mais fácil de começar é com o `usethis`.
# Este é um processo de 3 etapas para criar um projeto do zero.

# PASSO A: Crie um novo projeto RStudio localmente.
# Escolha um caminho no seu computador onde o projeto será salvo.
# Este comando criará a pasta e um arquivo .Rproj dentro dela.
usethis::create_project("~/Desktop/meu_primeiro_projeto_git")

# --- NESTE PONTO, O RSTUDIO VAI REINICIAR E ABRIR O NOVO PROJETO ---
# --- CONTINUE O RESTO DO SCRIPT NESSA NOVA JANELA DO RSTUDIO ---

# PASSO B: Inicialize o Git no projeto.
# Este comando transforma seu projeto R em um repositório Git.
# Você verá uma aba "Git" aparecer no RStudio (geralmente no painel superior direito).
# O comando pedirá informações. Você deve "commit" tudo e pedir para reinicializar
# RStudio.
usethis::use_git()

# PASSO C: Crie um repositório no GitHub e conecte-o.
# Este comando criará um novo repositório no seu GitHub com o mesmo nome
# da sua pasta de projeto e o conectará ao seu projeto local.
usethis::use_github(private = TRUE) # `private = TRUE` é recomendado para trabalhos de curso

# --- Tópico 5: O Ciclo Diário: Pull, Commit, Push ---

# Este é o fluxo de trabalho que você deve seguir sempre.

# PASSO A: PULL (Puxar)
# A PRIMEIRA COISA que você faz ao abrir um projeto é um "Pull".
# Isso baixa quaisquer alterações que possam ter sido feitas no GitHub
# (por exemplo, por um colaborador, ou por você em outro computador).
# - No RStudio, vá para a aba "Git" (geralmente no painel superior direito).
# - Clique na seta azul para baixo (Pull).
# (No início, ele dirá "Already up-to-date", o que é normal).

# PASSO B: FAZER ALTERAÇÕES
# Crie um novo script R ou um arquivo Quarto.
# Por exemplo, crie um script chamado "analise.R" e adicione algum código.
write("1 + 1", file = "analise.R")
# Salve o arquivo.

# PASSO C: STAGE (Preparar)
# Agora, olhe para a aba "Git". Você verá seu novo arquivo "analise.R".
# - Ícones de Status:
#   - `?` (Ponto de interrogação azul): Arquivo "não rastreado" (Untracked). 
#         O Git o vê, mas não está monitorando suas mudanças.
#   - `M` (Quadrado amarelo): Arquivo "modificado" (Modified). Você alterou um 
#         arquivo que o Git já estava rastreando.
#   - `A` (Quadrado verde): Arquivo "adicionado" (Added/Staged). Você marcou 
#         este arquivo para ser incluído no próximo commit.
#   - `D` (Quadrado vermelho): Arquivo "deletado" (Deleted).
# - Marque a caixa na coluna "Staged" ao lado de "analise.R".
#   "Staging" significa "Estou preparando esta mudança para salvá-la no 
#   histórico".

# PASSO D: COMMIT (Confirmar)
# Um "commit" é como tirar uma foto, um "snapshot" do seu projeto em um
# ponto no tempo. É um salvamento LOCAL no histórico do Git.
# - Clique no botão "Commit" na aba Git.
# - Uma nova janela se abrirá. No painel superior direito, escreva uma 
#   "Mensagem de Commit".
#   A mensagem deve ser curta, descritiva e no tempo presente. 
#   Ex: "Adiciona script inicial de análise".
# - Clique no botão "Commit".
# - Uma janela mostrará as mudanças. Você pode fechá-la.

# PASSO E: PUSH (Empurrar)
# O commit salvou as mudanças no SEU computador. "Push" envia esses commits
# para o GitHub, atualizando o backup na nuvem e tornando-os visíveis para 
# colaboradores.
# - Na aba Git, clique na seta verde para cima (Push).
# - Pronto! Agora vá para a página do seu repositório no GitHub e veja que o 
#   arquivo "analise.R" está lá.

# --- Tópico 6: Ignorando Arquivos com .gitignore ---

# Não queremos rastrear tudo (ex: arquivos de dados grandes, 
# arquivos temporários).
# O arquivo `.gitignore` diz ao Git quais arquivos ou pastas ignorar.
# O `usethis` torna isso fácil.

# Vamos dizer ao Git para ignorar arquivos de dados grandes e arquivos de 
# ambiente R.
usethis::use_git_ignore(c("dados/", "*.RData", "*.Rhistory"))

# Agora, se você criar uma pasta "dados" e colocar um CSV dentro, ela não
# aparecerá na aba Git.

# --- Tópico 7: Permissões e Colaboração (Discussão no GitHub) ---

# Esta parte é feita no site do GitHub, não no R.

# 1. Repositórios Públicos vs. Privados
#    - Ao criar um repositório no GitHub (ou com `usethis::use_github`), você 
#      pode escolher.
#    - PÚBLICO: Qualquer pessoa no mundo pode ver seu código. Ótimo para 
#      projetos de código aberto e portfólio.
#    - PRIVADO: Apenas você e as pessoas que você convidar podem ver o 
#      repositório.
#      **Use repositórios PRIVADOS para todos os trabalhos do curso.**

# 2. Adicionando Colaboradores
#    Para trabalhar em um projeto em grupo (como o projeto final de Shiny):
#    - Vá para a página do seu repositório no GitHub.
#    - Clique em "Settings" (Configurações).
#    - No menu à esquerda, clique em "Collaborators" (Colaboradores).
#    - Adicione seus colegas de equipe usando o nome de usuário do GitHub deles.
#    - Eles receberão um convite por e-mail. Uma vez que aceitem, eles poderão
#      fazer "push" para o mesmo repositório.

# --- FIM DO SCRIPT DE AULA ---
