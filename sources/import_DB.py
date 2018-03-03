#!/usr/bin/python
# -*- coding: utf-8 -*-
import psycopg2
import csv, sys


path = '/Users/othon.campos/Documents/siconv/siconv'
nome_ficheiro = path + '/' + 'teste.csv'

conn = psycopg2.connect(host='localhost', user='postgres', password='postgres', dbname='siconv')
c = conn.cursor()

valor = '9,99'
print valor
valor = valor.replace( ',', '.')
print valor


with open(nome_ficheiro, 'r') as ficheiro:
    reader = csv.reader(ficheiro, delimiter=';', quoting=csv.QUOTE_NONE)
    for linha in reader:      
        i = 0
        for x in linha:
            if x in [ 'Sim', 'SIM' ]:
                linha[i] = 1
            elif x in [ 'Nao', 'NAO', 'NÃO', 'Não' ]:
                linha[i] = 0
            elif x == '':
                linha[i] = None
            elif x.count(',') > 0:
                linha[i] = linha[i].replace(',', '.')
            i+=1
        
        print linha
        c.execute("""INSERT INTO public.convenio(nr_convenio, id_proposta, dia, mes, ano, dia_assin_conv, sit_convenio, subsituacao_conv, situacao_publicacao, instrumento_ativo, ind_opera_obtv, nr_processo, dia_publ_conv, dia_inic_vigenc_conv, dia_fim_vigenc_conv, dias_prest_contas, dia_limite_prest_contas, qtde_convenios, qtd_ta, qtd_prorroga, vl_global_conv, vl_repasse_conv, vl_contrapartida_conv, vl_empenhado_conv, vl_desembolsado_conv, vl_saldo_reman_tesouro, vl_saldo_reman_convenente, vl_ingresso_contrapartida) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s); """, linha)
        conn.commit()

print("Dados importados do csv com sucesso.")

'''
with open(nome_ficheiro, 'r') as ficheiro:
    reader = csv.reader(ficheiro, delimiter=';', quoting=csv.QUOTE_NONE)

    try:
        for linha in reader:
            print linha[0]
    except csv.Error as e:
        sys.exit('ficheiro %s, linha %d: %s' % (nome_ficheiro, reader.line_num, e))







c.execute("CREATE TABLE person (id serial PRIMARY KEY, name text, age integer);")

c.execute("INSERT INTO person (name, age) VALUES (%s, %s)",("O'Relly", 60))
c.execute("INSERT INTO person (name, age) VALUES (%s, %s)",('Regis', 35))
conn.commit()

c.execute('SELECT * FROM person')
recset = c.fetchall()
for rec in recset:
    print (rec)
conn.close()


'''