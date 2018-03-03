import re

nome_arquivo = 'teste.pagamento.002.csv'
imprimir_log = True
path = path = './'
fileName = path + '/' + nome_arquivo
arq = open(fileName, 'r')
texto = arq.readlines()
newFileName = fileName+".csv"
arqFim = open(newFileName, 'w')

#imprimirLog( "Verificando o arquivo: " + nome_arquivo, imprimir_log)
#cont = 0

#RE3 = re.compile(z)


for linha in texto:
    #x = RE3.search(linha)
    #print(x)
    #print(re.match(r’;"’, linha).group())
    print re.search('([\w]+);\"([\w]+)', linha).group(1)