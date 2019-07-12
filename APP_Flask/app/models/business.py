import psycopg2
import pymysql.cursors
import json
import locale
from decimal import Decimal

class Base:
	_titleHeader = None
	def __init__(self):
		self._titleHeader = 'Transparencia Traduzida'
	def getconn(self):
		#return psycopg2.connect(host='localhost', database='siconv', user='postgres', password='postgres')
		# Connect to the database
		connection = pymysql.connect(host='localhost', user='root', password='P@ssw0rd', db='siconv', charset='utf8mb4', cursorclass=pymysql.cursors.DictCursor)
		return connection
	def obterQuery(self, nomeQuery, jsonGeral ):
		return str( jsonGeral['selects'][nomeQuery] )
	def _obterDadosQuery(self, connection, nomeQuery, jsonGeral):
		query = self.obterQuery( self, nomeQuery, jsonGeral )
		cursor = connection.cursor()
		cursor.execute(query)
		return cursor.fetchall()
	def topNElementos(self, pLista, topN, indiceDesc, indiceValor, tipoValor, pOutros):
		'''
		Retorna apenas quantidade de elementos indicada pelo parametro topN. Caso a lista seja maior que 
		o numero indicado, todos os outros valores serão aglutiados no item "outros". 
		Parametros: 
			pLista     : lista contendo os dados a serem tratados 
			topN       : Quantidade de elementos a serem retornados
			indiceDesc : Indice contendo a descricao na lista do parametro
			indiceValor: Indice, ou nome, do campo que contem o valor na lista do parametro
			tipoValor  : o tipo do valor a ser tratado ( 0 = int; 1 = float; 2 = decimal)
			pOutros    : indica o nome que sera utilizado na aglutinacao das informacoes
		
			self.listaSituacaoConvTop10 = base.topNElementos(self.listaSituacaoConv, 7, 0, 1, 0, 'Outros Convênios')
		'''
		listaAux = []
		i=0
		soma = 0;
		cont = 0
		for l in pLista:
			#print( l)
			if ( i < topN ):
				listaAux.append(l)
			else:
				cont+=1
				if(  tipoValor == 0 ):
					soma+=int(l[ indiceValor ])
				else:
					soma+=float(l[ indiceValor ])
			i+=1
		#listaAux.append(  (pOutros, cont, round(Decimal(soma), 2) ) )
		listaAux.append(  { 'nm_proponente':pOutros, 'qtd':cont, 'indiceValor':round(Decimal(soma), 2)} )
		return listaAux
	def normalizarDadosOutLierEstadoDic(self, listaOutlierEstado):
		'''
		Método que obtem os dados do banco de dados e cria um arrei para cada ano com seus respectivos valores;
		Exemplo: Do banco vem um dataset com a seguinte  
		'''
		dicValoresAno = {}
		listaAux  = []
		ano = 0
		pos=0
		anoAtual = 0
		primeiraVez = True
		#print( listaOutlierEstado )
		for d in listaOutlierEstado:
			if ( ano == 0 ):
				ano = d['ano']
				listaAux.append( float( d['vl_global_conv'] ) ) 
			elif( ano == d['ano'] ):
				listaAux.append( float( d['vl_global_conv'] ) ) 
			else: 
				dicValoresAno[ano] = listaAux
				pos+=1
				ano = d['ano']
				listaAux  = []
				listaAux.append( float( d['vl_global_conv'] ) ) 
		dicValoresAno[ano] = listaAux
		return dicValoresAno
	def normalizarDados(self, listDados):
		anoMin = 2008
		anoMax = 2018
		listaAnos = range(anoMin, anoMax)
		listaMeses= range(1, 12)
		listDadosMesal = []
		listaTemp = []
		contMes = 1
		contAno = anoMin
		pos = 0  
		for z in listDados:
			#print( z )
			if(contMes == z['mes']):
				while( True ): #controle do mes 
					if ( contAno < z['ano']):
						listaTemp.insert(pos, {'mes':contMes, 'ano':contAno, 'qtd_convenio': 0})
						pos+=1
						contAno+=1
					elif( contAno == z['ano'] ):
						listaTemp.append(z)
						pos+=1
						contAno+=1
						break
					elif( contAno > z['ano'] & contAno <= anoMax):
						listaTemp.insert(pos, {'mes':contMes, 'ano':contAno, 'qtd_convenio': 0})
						pos+=1
						contAno+=1
					else: 
						break
			else:
				while( True ): #controle do mes 
					if( contAno <= anoMax):
						listaTemp.insert(pos, {'mes':contMes, 'ano':contAno, 'qtd_convenio': 0})
						pos+=1
						contAno+=1
					else:
						break
				contMes+=1
				contAno = anoMin
				while( True ): #controle do mes 
					if ( contAno < z['ano']):
						listaTemp.insert(pos, {'mes':contMes, 'ano':contAno, 'qtd_convenio': 0})
						pos+=1
						contAno+=1
					elif( contAno == z['ano']):
						listaTemp.append(z)
						pos+=1
						contAno+=1
						break
					elif( contAno > z['ano'] & contAno <= anoMax):
						listaTemp.insert(pos, {'mes':contMes, 'ano':contAno, 'qtd_convenio': 0})
						pos+=1
						contAno+=1
					else: 
						break
		while( True ): #controle do mes 
			if( contAno <= anoMax):
				listaTemp.insert(pos, {'mes':contMes, 'ano':contAno, 'qtd_convenio': 0})
				pos+=1
				contAno+=1
			else:
				break
		i=1
		j=0
		mes = 1
		l1=[]
		#print( listaTemp )
		while( i <= 12 ):
			l0=[]
			l0.append(i)
			while( j < (11*mes) ):
				lAux = listaTemp[j]
				valor = lAux[ 'qtd_convenio'] 
				l0.append( valor )
				j+=1
			l1.append(l0)
			i+=1
			mes+=1
		return l1

	def convertDictToList(self, listDict):
		auxT = []
		for a in listDict:
			#print( type(a) )
			#print( a.values() )
			list_values = [ v for v in a.values() ]
			auxT.append( list_values )
		print( auxT)
		return auxT

class Singleton_Index(Base):
	_instance = None
	quantidadeConvenios = None
	quantidadeEmpresas = None
	quantidadeParlamentares = None
	__json_gerais = None
	__links = {}
	
	def __getQuantidadeParlamentares( self, connection, jsonGeral ):
		row = self._obterDadosQuery( self, connection, 'QuantidadeParlamentares', jsonGeral )
		#print( row )
		#return row[0][0]
		return row[0]['valor']

	def __getQuantidadeConvenios( self, connection, jsonGeral ):
		row = self._obterDadosQuery( self, connection, 'QuantidadeConvenios', jsonGeral )
		#print( row[0]['valor'] )
		#return row[0][0]
		return row[0]['valor']

	def __getQuantidadeEmpresas( self, connection, jsonGeral ):
		row = self._obterDadosQuery( self, connection, 'QuantidadeEmpresas', jsonGeral )
		#return row[0][0]
		return row[0]['valor']

	def __new__(self, *args, **kwargs):
		print( 'SingletonIndex : __new__ :: 1' )
		if not self._instance:
			print( 'Singleton_Index : __new__ :: 2' )
			self._instance = super(Singleton_Index, self).__new__(self, *args, **kwargs)
			print( 'Singleton_Index : __new__ :: 3' )
			dados_gerais = open( './json/gerais.json', 'r' )
			dados_gerais_text = dados_gerais.read()
			__json_gerais = json.loads(dados_gerais_text)
			dados_gerais.close()
			print( 'Singleton_Index : __new__ :: 4' )
			conn = self.getconn(self)
			self.quantidadeConvenios = self.__getQuantidadeConvenios( self, conn, __json_gerais )
			self.quantidadeParlamentares = self.__getQuantidadeParlamentares( self, conn, __json_gerais )
			self.quantidadeEmpresas = self.__getQuantidadeEmpresas( self, conn, __json_gerais )
			conn.close()
			print( 'Singleton_Index : __new__ :: 5' )
		else:
			print( 'SingletonIndex : __new__ :: 1.1' )
		return self._instance

	def __str__(self):
		print( 'Singleton_Index : __str__ :: 1' )
		return '%s - %s - %s - %s' % (self._titleHeader, self.quantidadeConvenios, self.quantidadeParlamentares, self.quantidadeEmpresas)

class Singleton_QuemSomos(Base):
	_instance = None

	def __new__(cls, *args, **kwargs):
		print( 'SingletonIndex : __new__ :: 1' )
		if not cls._instance:
			print( 'Singleton_QuemSomos : __new__ :: 2' )
			cls._instance = super(Singleton_QuemSomos, cls).__new__(cls, *args, **kwargs)
			print( 'Singleton_QuemSomos : __new__ :: 3' )
		return cls._instance

	def __str__(self):
		print( 'Singleton_QuemSomos : __str__ :: 1' )
		return '%s' % (self._titleHeader )

class Singleton_Projetos(Base):
	_instance = None

	def __new__(cls, *args, **kwargs):
		print( 'SingletonIndex : __new__ :: 1' )
		if not cls._instance:
			print( 'Singleton_Projetos : __new__ :: 2' )
			cls._instance = super(Singleton_Projetos , cls).__new__(cls, *args, **kwargs)
			print( 'Singleton_Projetos : __new__ :: 3' )
		return cls._instance

	def __str__(self):
		print( 'Singleton_Projetos : __str__ :: 1' )
		return '%s' % (self._titleHeader )

class Login(Base):
	_instance = None
	def __new__(cls, *args, **kwargs):
		print( 'Login : __new__ :: 1' )
		if not cls._instance:
			print( 'Login : __new__ :: 2' )
			cls._instance = super(Login , cls).__new__(cls, *args, **kwargs)
			print( 'Login : __new__ :: 3' )
		return cls._instance
	def __str__(self):
		print( 'Singleton_Projetos : __str__ :: 1' )
		return '%s' % (self._titleHeader )
class Singleton_Tootip(Base):
	_instance = None
	tooltip = {}
	def __new__(cls, *args, **kwargs):
		print( 'Singleton_Tootip : __new__ :: 1' )
		if not cls._instance:
			print( 'Singleton_Tootip : __new__ :: 2' )
			cls._instance = super(Singleton_Tootip, cls).__new__(cls, *args, **kwargs)
			
			dados_gerais = open( './json/gerais.json', 'r' )
			dados_gerais_text = dados_gerais.read()
			json_gerais = json.loads(dados_gerais_text)
			dados_gerais.close()
			locale.setlocale(locale.LC_ALL, "")
			#Montando o dicionario para os tooltips
			conn = cls.getconn(cls)
			dataSetTooltip = cls._obterDadosQuery(cls, conn, 'SQL_ToolTip', json_gerais)
			for l in dataSetTooltip:
				#print( l )
				texto = 'População: %s \nQtd. Parlamentares: %s \nNúmero de Propostas: %s \nValor total das Propostas: R$ %s \nNúmero de Convênios: %s \nValor total dos Convênios: R$ %s' % (
					locale.format('%0i', l['nr_habit'], grouping=True), 
					locale.format('%0i', l['qtd_parlamentar'], grouping=True), 
					locale.format('%0i', l['qtd_proposta'], grouping=True),
					locale.currency(l['vl_global_prop'], grouping=True, symbol=False ),
					locale.format('%0i', l['qtd_convenio'], grouping=True), 
					locale.currency(l['vl_global_conv'], grouping=True, symbol=False ) )
				cls.tooltip[l['uf_proponente']] = texto

			print( 'Singleton_Tootip : __new__ :: 3' )
		return cls._instance
	def __str__(self):
		print( 'Singleton_Tootip : __str__ :: 1' )
		return '%s' % (self._titleHeader )
class Estado:
	def __init__(self, sigla):
		self.__listaUF_O = ( 'AC', 'AM', 'AP', 'CE', 'DF', 'ES', 'MA', 'PA', 'PI', 'PR' 'RJ', 'RN', 'RS', 'TO' )
		self.__listaUF_A = ( 'BA', 'PB' )
		self.__listaUF = ( 'AL', 'GO', 'MG', 'MS', 'MT', 'PE', 'RO', 'RR', 'SC', 'SE', 'SP' )
		self.sigla = sigla
		if sigla in self.__listaUF :
			self.artigo = 'e'
		elif sigla in self.__listaUF_A :
			self.artigo = 'a'
		elif sigla in self.__listaUF_O :
			self.artigo = 'o'
		dados_gerais = open( './json/gerais.json', 'r' )
		dados_gerais_text = dados_gerais.read()
		json_gerais = json.loads(dados_gerais_text)
		dados_gerais.close()
		base = Base()
		conn = base.getconn()
		cursor = conn.cursor()		
		#Obter o nome do estado
		query = base.obterQuery("Nome_estado", json_gerais)
		cursor.execute( query % self.sigla )
		x = cursor.fetchall()
		#self.nome = x[0][0]
		self.nome = x[0]['Descricao']
		
		#obter os valores das quantidades de propostas e das quantidades de convenios 
		query = base.obterQuery("ValoresEstado", json_gerais)
		cursor.execute( query % self.sigla )
		aux0 = cursor.fetchall()
		self.listaQtdPropostaQtdConv = base.convertDictToList( aux0 )

		#obter as regras de associacao 
		query = base.obterQuery("RegrasAssociacaoUF", json_gerais)
		cursor.execute( query %(0.65, 0.03, 90, self.sigla) )
		self.listaRegras = base.convertDictToList(cursor.fetchall())
		print( self.listaRegras )

		#obter os valores dos outlier
		query = base.obterQuery("Outlier_estado", json_gerais)
		cursor.execute( query % self.sigla )
		lista = cursor.fetchall()
		self.dataSetOutlier = base.normalizarDadosOutLierEstadoDic( lista )

		#Quantidade de convenios executados apenas no mes de dezembro
		query = base.obterQuery("QuantConvPorMes", json_gerais)
		cursor.execute( query %(self.sigla, 12) )
		aux0 = cursor.fetchall()
		#print( "Quantidade de convenios executados apenas no mes de dezembro" )
		#print( aux0 )
		self.listDadosConvenioMes12 = base.normalizarDados(aux0)
		
		#Quantidade de convenios executados por mes de dezembro
		query = base.obterQuery("QuantConvMensal", json_gerais)
		cursor.execute( query % self.sigla )
		listDadosConvenioMensalAux = cursor.fetchall()
		self.listDadosMesal = base.normalizarDados(listDadosConvenioMensalAux)
		
		#
		query = base.obterQuery("QuantConvParlamentar_conv", json_gerais)
		cursor.execute( query % self.sigla )
		aux0 = cursor.fetchall()
		self.listaConvParlConv = base.convertDictToList( aux0 )
		#
		query = base.obterQuery("QuantConvParlamentar_conv_top10", json_gerais)
		cursor.execute( query % self.sigla )
		aux0 = cursor.fetchall()
		self.listaConvParlConvTop10 = base.convertDictToList( aux0 )
		#
		query = base.obterQuery("QuantConvParlamentar_valor", json_gerais)
		cursor.execute( query % self.sigla )
		aux0 = cursor.fetchall()
		self.listaConvParlValor = base.convertDictToList( aux0 )
		
		#
		query = base.obterQuery("QuantConvParlamentar_valor_top10", json_gerais)
		cursor.execute( query % self.sigla )
		aux0 = cursor.fetchall()
		self.listaConvParlValorTop10 = base.convertDictToList( aux0 )
		
		#Grafico: Situação dos convênios
		query = base.obterQuery("SituacaoConvenio_Quant", json_gerais)
		cursor.execute( query % self.sigla )
		aux0 = cursor.fetchall()
		aux1 = base.topNElementos(aux0, 7, 0, 'qtd', 0, 'Outros Convênios')
		self.listaSituacaoConv = base.convertDictToList( aux0 )
		self.listaSituacaoConvTop10 = base.convertDictToList( aux1 )
		
		#Distribuicao de valores por area
		query = base.obterQuery("DistribuicaoArea_Valor", json_gerais)
		cursor.execute( query % self.sigla )
		aux0 = cursor.fetchall()
		aux1 = base.topNElementos(aux0, 7, 0, 'valor_total', 2, 'Outras Áreas')
		self.listaDistribuicaoArea = base.convertDictToList( aux0 )
		self.listaDistribuicaoAreaTop10 = base.convertDictToList( aux1 )
		
		#Lista das 100 empresas que mais faturaram
		query = base.obterQuery("EmpresasFaturamentoUF", json_gerais)
		cursor.execute( query %(self.sigla, 100) )
		aux0 = cursor.fetchall()
		self.listaEmpresasFaturamento = base.convertDictToList( aux0 )

		#Lista com outros proponentes 
		query = base.obterQuery("conv_proponente", json_gerais)
		cursor.execute( query % self.sigla )
		aux0 = cursor.fetchall()
		aux1 = base.topNElementos( aux0, 10, 0, 'vl_global_conv', 2, 'Outros Proponentes')
		self.listaConvCidadeValor = base.convertDictToList( aux0 )
		self.listaConvCidadeValorTop10 = base.convertDictToList( aux1 )

		cursor.close()
		conn.close()
	def __str__(self):
		return '%s - %s' % (self.sigla, self.nome)
class Singleton_ListaEstado:
	_instance = None
	__estados = {}
	def __new__(self, *args, **kwargs):
		if not self._instance:
			print('Singleton_ListaEstado - CREATE LISTA')
			self._instance = super(Singleton_ListaEstado , self).__new__(self, *args, **kwargs)
		else:
			print('Singleton_ListaEstado - USE LISTA')
		return self._instance
	def __obterUF(self, estado):
		'''
		Método para retornar a UF de um objeto estado. Caso o objeto nao seja Estado retornar a string passada
		'''
		uf = None
		if isinstance(estado, Estado):
			uf = estado.sigla
		elif isinstance(estado, str):
			uf = estado
		return uf
	def obterEstado( self, estado ):
		uf = self.__obterUF( estado )
		if self.verificarEstado(uf):
			return self.__estados.get(uf, None)
		else: 
			return None
	def verificarEstado( self, estado ):
		uf = self.__obterUF( estado )
		aux = self.__estados.get(uf, None)
		return (self.__estados.get(uf, None) != None)
	def inserirEstado(self, estado):
		uf = self.__obterUF( estado )
		self.__estados[uf] = estado
	def __str__(self):
		listR = []
		for x in self.__estados.keys():
			est = self.__estados.get(x)
			listR.append( est )
		s = ''.join(str(e) for e in listR)
		return s
class Singleton_Estados(Base):
	_instance    = None
	_pathPage    = None
	_listaEstado = None
	def __new__(cls, *args, **kwargs):
		if not cls._instance:
			cls._instance = super(Singleton_Estados , cls).__new__(cls, *args, **kwargs)
		return cls._instance
	def __str__(self):
		return '%s' % (self._titleHeader )