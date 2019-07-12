#!/usr/bin/env python3
# -*- coding: utf-8 -*-


# Run with no args for usage instructions
#
# Notes:
#  - will probably insert duplicate records if you load the same file twice
#  - assumes that the number of fields in the header row is the same
#    as the number of columns in the rest of the file and in the database
#  - assumes the column order is the same in the file and in the database
#
# Speed: ~ 1s/MB
# 

import sys
#import mysql.connector
import pymysql.cursors
import csv
import locale
import psycopg2
from unicodedata import normalize
from datetime import datetime

def main(table, csvfile):
    ''' 
    try:
        conn = getConnPostgres()
    except Exception as e:
        print ("Error %d: %s" % (e.args[0], e.args[1]) )
        sys.exit (1)
    ''' 
    try:
        conn = getconn()
    except Exception as e:
        print ("Error %d: %s" % (e.args[0], e.args[1]) )
        sys.exit (1)
    #cursor = conn.cursor()
    #cursor.execute("SET SESSION sql_mode = 'STRICT_ALL_TABLES';")
    #loadcsv(cursor, table, csvfile)
    loadcsv(conn, table, csvfile)
    print('E - Final Committing' )
    conn.commit()
    #cursor.close()
    conn.close()

def remover_acentos(txt, codif='utf-8'):
    return normalize('NFKD', txt.decode(codif)).encode('ASCII', 'ignore')

def getConnPostgres( host='localhost', database='viagem', user='postgres', password='postgres'):
    #con = psycopg2.connect(host, database, user, password)
    con = psycopg2.connect(host='localhost', database='viagem', user='postgres', password='postgres')
    return con

def getconn():
    '''
    config = {
        'user': 'root',
        'password': 'P@ssw0rd',
        'host': '127.0.0.1',
        'database': 'tt_viagens',
        'raise_on_warnings': True
    }
    conn = mysql.connector.connect(**config)
    return conn
    '''

    # Connect to the database
    connection = pymysql.connect(host='localhost',
                                user='root',
                                password='P@ssw0rd',
                                db='siconv',
                                charset='utf8mb4',
                                cursorclass=pymysql.cursors.DictCursor)
    return connection


def nullify(L):
    """Convert empty strings in the given list to None."""
    # helper function
    def f(x):
        if( x.strip() == '' or x.strip() == 'null' ):
            return None
        else:
            return x
    return [f(x) for x in L]

#def loadcsv(cursor, table, filename):
def loadcsv(conn, table, filename):

    """
    Open a csv file and load it into a sql table.
    Assumptions:
     - the first line in the file is a header
    """
    nameFileErro = filename + '.err'
    nameFileRej  = filename + '.rej'
    fileErro = open( nameFileErro, 'w')
    fileRej  = open( nameFileRej , 'w')

    cursor = conn.cursor()
    with open(filename, newline='', encoding='latin-1') as file:
        f = csv.reader(file, delimiter=';')
        header = f.__next__()
        numfields = len(header)
        dadosQuery = buildInsertCmd(cursor, table, numfields)
        query = dadosQuery["query"]
        listTypeQuery = dadosQuery["listType"]
        print( listTypeQuery )
        listDecimal=[]
        listDate=[]
        listInt=[]
        i=0
        for j in listTypeQuery:
          if( str(j).find('decimal') >= 0 or str(j).find('numeric') >= 0 ): 
            listDecimal.append( i )
          if( str(j).find('date') >= 0 ):
            listDate.append( i )
          if( str(j).find('int') >= 0 ):
            listInt.append( i )
          i+=1

        #print(listDecimal)
        #print(listDate)
        #print(query)
        max_inserts = 40000
        qtd_linha = 1
        qtd_insert=0

        for line in f:
            try:
                #line = remover_acentos( line )
                vals = nullify( line )
                #vals.insert(0, ano)
                #print(listDate)
                #print(listDecimal)
                for j in listDecimal:
                    #print("Decimal: %s - %s" % (j, vals[j] ) )
                    if ( vals[j] != None and vals[j].strip() != ''):
                      valor = vals[j].replace(',', '.')
                      #retirada a formatação com zeros a esquerda pq deu problema quando o valor é negativo
                      #valor = '{:0>15}'.format(valor)
                      vals[j] = valor
                
                #print( listDate )
                for j in listDate:
                    #print("Data: %s - %s" % (j, vals[j] ) )
                    if( vals[j] != None and vals[j].strip() != '' ):
                      valorData = datetime.strptime(vals[j], '%d/%m/%Y') 
                      vals[j] = valorData.strftime('%Y-%m-%d')

                #print( listInt )
                for j in listInt:
                    if( vals[j] != None and vals[j].strip() != '' ):
                      valorData = vals[j].replace('.', '')
                      vals[j] = valorData


                qtdCamposTabela  = len(listTypeQuery)
                qtdCamposArquivo = len(vals )
                if ( qtdCamposArquivo > qtdCamposTabela):
                    vals.pop( qtdCamposTabela )
                
                cursor.execute(query, vals)
                qtd_insert+=1
                if qtd_insert % max_inserts == 0:
                    print('A - Committing `%s` rows to database ... processed `%s` rows of file ' % ( qtd_insert, qtd_linha ))
                    conn.commit()
            except Exception as e:
                fileErro.write(str(e))
                fileErro.write("%s : %s\n" %(str(qtd_insert), line))
                fileRej.write("%s\n" %line)
                print("OS error: {0}".format(e))
                print(e.args)
                print('B - Committing `%s` rows to database ... processed `%s` rows of file ' % ( qtd_insert, qtd_linha ))
                conn.commit()
            qtd_linha+=1
        print('C - Committing `%s` rows to database ... processed `%s` rows of file ' % ( qtd_insert, qtd_linha ))
        conn.commit()
    
    print('D - Committing `%s` rows to database ... processed `%s` rows of file ' % ( qtd_insert, qtd_linha ))
    conn.commit()
    cursor.close()
    fileErro.close()
    fileRej.close()
    return


def buildInsertCmd(cursor, table, numfields):

    """
    Create a query string with the given table name and the right
    number of format placeholders.
    example:
    >>> buildInsertCmd("foo", 3)
    'insert into foo values (%s, %s, %s)' 
    """
    
    #se for mysql  
    query = 'show fields from %s' %table

    #se for postgres
    #query = 'SELECT column_name, data_type, is_nullable, null as key, null as default, column_default as extra FROM information_schema.COLUMNS WHERE TABLE_NAME = \'%s\'' %table


    #print(query)
    cursor.execute( query )
    list = cursor.fetchall()
    listColumns =[]
    listTypes =[]
    #print( list )
    for l in list:
      #print( l['Extra'] )
      #testeCampoAutoIngremento = ( l[5] != None and ( 'nextval' in l[5] or 'auto_increment' in l[5]) )
      testeCampoAutoIngremento = ( l['Extra'] != None and ( 'nextval' in l['Extra'] or 'auto_increment' in l['Extra']) )
      #print(  '%s - %s - %s' %(l['Field'], l['Type'], l['Extra']) )
      if not testeCampoAutoIngremento :
        listColumns.append(l['Field'])
        listTypes.append(l['Type'])

    numfields = len(listColumns)
    assert(numfields > 0)
    placeholders = (numfields-1) * "%s, " + "%s"

    arguments = ', '.join(listColumns)
    #print(arguments)
    query = ("insert into %s" % table) + ("( %s )" % arguments) + (" values (%s)" % placeholders)
    #print(query)

    #assert(numfields > 0)
    #placeholders = (numfields-1) * "%s, " + "%s"
    #query = ("insert into %s" % table) + (" values (%s)" % placeholders)
    dadosQuery = {"query": query, "listType": listTypes }
    return dadosQuery

if __name__ == '__main__':
    # commandline execution
    args = sys.argv[1:]
    if(len(args) < 2):
        print ("error: arguments: user db table csvfile")
        sys.exit(1)

    main(*args)



'''
python3 import_dados.py proposta ./2019.07.03/siconv/siconv_proposta_2.csv 

''' 