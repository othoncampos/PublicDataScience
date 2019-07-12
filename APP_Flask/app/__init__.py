#!/usr/bin/env python3
# -*- coding: utf-8 -*-
from flask import Flask
from app.models import business
#from app.util import filters
#from flask_sqlalchemy import SQLAlchemy
#from flask_script import Manager
#from flask_migrate import Migrate, MigrateCommand

app = Flask(__name__)

app.config.from_object('config')

indexPage = business.Singleton_Index()
listaEstado = business.Singleton_ListaEstado()
listaToolTips = business.Singleton_Tootip()

#app.config['SQLALCHEMY_DATABASE_URI']  = 'postgresql://postgres:postgres@localhost/aula_flask' 
#app.config['SQLALCHEMY_DATABASE_URI']  = 'sqlite:///storage.db' 
#db  = SQLAlchemy(app)
#migrate = Migrate(app, db)

#manager = Manager(app)
#manager.add_command('db', MigrateCommand)

@app.context_processor
def uf():
	return listaToolTips.tooltip

@app.template_filter('ajustarNomeRegraLHS')
def ajustarNomeRegraLHS( pNome ):
    nomeAux=''
    if ( pNome.find( '{Parlamentar=' ) >= 0 ):
        nomeAux = pNome.replace('{Parlamentar=', '').replace('}', '')
    elif ( pNome.find( '{Informacao=' ) >= 0 ):
        nomeAux = pNome.replace('{Informacao=', '').replace('}', '')
    return nomeAux

@app.template_filter('ajustarNomeRegraRHS')
def ajustarNomeRegraRHS( nome ):
    nomeAux = nome.replace('{Informacao=', '').replace('}', '')
    return nomeAux

@app.template_filter('ajustarTipoRegra')
def ajustarTipoRegra( pTipo ):
	retorno = ''
	if( pTipo=='1' ):
		return 'à área'
	elif(pTipo=='2'):
		return 'ao parlamentar'
	return retorno

@app.template_filter('ajustarNomeRegra')
def ajustarNomeRegra( pNome ):
	'''
	Retirar o texto que precede o nome do parlamentar ou da associação. 
	Este método retira o texto '{Parlamentar=' ou '{Informacao=' do nome da regra lhs ou rhs
	'''
	nomeAux=''
	if ( pNome.find( '{Parlamentar=' ) >= 0 ):
		nomeAux = pNome.replace('{Parlamentar=', '').replace('}', '')
	elif ( pNome.find( '{Informacao=' ) >= 0 ):
		nomeAux = pNome.replace('{Informacao=', '').replace('}', '')
	return nomeAux

@app.template_filter('verificarPrecedenciaRegra')
def verificarPrecedenciaRegra(lhs):
	'''
	Retorna VERDADEIRO se o lhs possuir o nome do parlamentar e FALSO se possuir o nome da associacao
	Quando vier o nome do parlamentar, este será precedido por  será precedido por '{Parlamentar=', caso o lhs 
	possua a informação será precedido por '{Informacao='. 
	'''
	if ( lhs.find( '{Parlamentar=' ) >= 0 ):
		return 1
	elif( lhs.find( '{Informacao=' ) >= 0 ):
		return 0

@app.template_filter('ajustarApostrofo')
def ajustarApostrofo( pValor ):
	'''
	Método para verificar a existencia do caracter " ' " (apostofro) nos nomes das cidades. Exemplo Itaporanga D'Ajuda.
	Este será substituido por "\'" para evitar problemas na visualização da pagina web
	'''
	novoValor = ""
	if ( pValor.find("'") > 0):
		novoValor = pValor.replace( "'", "\\'")
	else:
		novoValor =  pValor;
	return novoValor

from app.controllers import default