#import urllib
#import urllib3
import time
import os
import wget
 
from datetime import datetime

#url = 'http://www.carlissongaldino.com.br/modules/pubdlcnt/pubdlcnt.php%sfile=http://www.carlissongaldino.com.br/sites/default/files/o-fantasma-da-opera.pdf&nid=1287'
 
#3601091007501099
#079999068838

listaUrl = [ 
    #'http://portal.convenios.gov.br/images/docs/CGSIS/csv/siconv_programa.csv.zip', 
    #'http://portal.convenios.gov.br/images/docs/CGSIS/csv/siconv_programa_proposta.csv.zip', 
    #'http://portal.convenios.gov.br/images/docs/CGSIS/csv/siconv_proposta.csv.zip', 
    #'http://portal.convenios.gov.br/images/docs/CGSIS/csv/siconv_convenio.csv.zip', 
    #'http://portal.convenios.gov.br/images/docs/CGSIS/csv/siconv_emenda.csv.zip', 
    #'http://portal.convenios.gov.br/images/docs/CGSIS/csv/siconv_plano_aplicacao.csv.zip', 
    #'http://portal.convenios.gov.br/images/docs/CGSIS/csv/siconv_empenho.csv.zip', 
    #'http://portal.convenios.gov.br/images/docs/CGSIS/csv/siconv_desembolso.csv.zip', 
    #'http://portal.convenios.gov.br/images/docs/CGSIS/csv/siconv_pagamento.csv.zip', 
    #'http://portal.convenios.gov.br/images/docs/CGSIS/csv/siconv_obtv_convenente.csv.zip', 
    #'http://portal.convenios.gov.br/images/docs/CGSIS/csv/siconv_historico_situacao.csv.zip', 
    #'http://portal.convenios.gov.br/images/docs/CGSIS/csv/siconv_ingresso_contrapartida.csv.zip', 
    #'http://portal.convenios.gov.br/images/docs/CGSIS/csv/siconv_termo_aditivo.csv.zip', 
    #'http://portal.convenios.gov.br/images/docs/CGSIS/csv/siconv_prorroga_oficio.csv.zip', 
   
    #'http://portal.convenios.gov.br/images/docs/CGSIS/csv/siconv.zip', 
    'http://portal.convenios.gov.br/images/docs/CGSIS/Historico_de_versoes.pdf',
    'http://portal.convenios.gov.br/images/docs/CGSIS/modelo_dados_siconv.zip']

print("baixando com urllib")
#path = '/Users/othon.campos/Documents/siconv'
path = './'

now = datetime.now()

pasta = str( now.year ).zfill(4) + '.' + str( now.month ).zfill(2) + '.' + str( now.day ).zfill(2)
print(pasta)

path += "/" + pasta

if ( not os.path.isdir( path ) ): 
    os.mkdir(path)

fileName = path + '/' + os.path.basename(  listaUrl[0] )

print(fileName)

tempo0 = time.time()
i = 0
while( i < len(listaUrl )):
    url = listaUrl[i]
    fileName = path + '/' + os.path.basename(  url )
    tempo10 = time.time()
    #urllib.urlretrieve(url, fileName)
    wget.download(url, path)
    tempo11 = time.time()
    print("Tempo: " + fileName + ' : ' + str( tempo11 - tempo10) )
    i+=1
tempo1 = time.time()
print("Tempo final: " + str( tempo1 - tempo0) )