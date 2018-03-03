import csv
import string
import sys


def imprimirLog(texto, permite):
    if permite:
        print(texto)

def to_bool(value):
    valid = {'true': True, 't': True, '1': True,
             'false': False, 'f': False, '0': False,
             }   

    if isinstance(value, bool):
        return value

    if not isinstance(value, basestring):
        raise ValueError('invalid literal for boolean. Not a string.')

    lower_value = value.lower()
    if lower_value in valid:
        return valid[lower_value]
    else:
        raise ValueError('invalid literal for boolean: "%s"' % value)

#print __doc__
nome_arquivo = sys.argv[1]
imprimir_log = to_bool(sys.argv[2])
#nome_arquivo = 'teste.pagamento.002.csv'
#imprimir_log = True
path = path = './'
fileName = path + '/' + nome_arquivo
arq = open(fileName, 'r')
texto = arq.readlines()
newFileName = fileName+".csv"
arqFim = open(newFileName, 'w')

imprimirLog( "Verificando o arquivo: " + nome_arquivo, imprimir_log)
cont = 0

for linha in texto:
    if linha.find('null') > 0:
        linha = linha.replace('null', '')
    inicio = linha.find(';"')
    if inicio > 0:
        auxt = linha[inicio+2:]
        fim = auxt.find('";') + inicio + 2
        imprimirLog(str(inicio) + ":" + str(fim), imprimir_log)
        aux0 = linha[inicio+1:fim]
        imprimirLog(aux0, imprimir_log)
        aux1 = aux0.replace(';', '|')
        imprimirLog(aux1, imprimir_log)
        imprimirLog(linha, imprimir_log)
        linha = linha.replace(aux0, aux1)
        imprimirLog(linha, imprimir_log)
        cont+=1
    arqFim.write(linha)
imprimirLog( "Novo Arquivo criado: " + newFileName, imprimir_log)
print(cont)
arq.close()
arqFim.close()


