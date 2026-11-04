## 24.7 Sites dinâmicos
# Não tem no livro, mas já tem o pacote 'chromote' que roda Chrome
# para acessar os dados dinâmicos.
help(package="chromote")

library(chromote)

b <- ChromoteSession$new()

# In a web browser, open a viewer for the headless browser. Works best with
# Chromium-based browsers.
b$view()
b$go_to("https://www.r-project.org/")


?read_html_live
sess <- read_html_live("https://www.forbes.com/top-colleges/")
sess$view()
rows <- sess %>% html_elements(".ListTable_tableRow__P838D")
rows
# nomes e posto .ListTable_boldCol__kzBQN
rows %>% html_elements(".ListTable_boldCol__kzBQN") %>% html_text()
# outros dados .ListTable_tableData__-55i8
rows %>% html_elements(".ListTable_tableData__-55i8") %>% html_text()

# para pegar a tabela toda, precisamos extrair o corpo dele
# 
sess %>% html_elements("tbody") %>% html_table()
