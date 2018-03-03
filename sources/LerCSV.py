import csv
import string

#print __doc__
path = path = './'
fileName = path + '/' + 'teste.proposta.csv'
arq = open(fileName, 'r')
texto = arq.readlines() 
arqFim = open(fileName+".csv", 'w')
for linha in texto : 
    inicio = linha.find(';"')
    if inicio > 0:
        fim = linha.find('";' )
        print(inicio)
        print(fim)
        aux0 = linha[inicio+2:fim];
        print(aux0)
        aux1 = aux0.replace(';', '|')
        print(aux1)
        print(linha)
        linha = linha.replace( aux0, aux1)
        print(linha)
    arqFim.write(linha)
arq.close()
arqFim.close()

