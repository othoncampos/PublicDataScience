if(! "ggplot2" %in% installed.packages()) install.packages("ggplot2" , depend = TRUE)
if(! "ggthemes" %in% installed.packages()) install.packages("ggthemes" , depend = TRUE)
if(! "gridExtra" %in% installed.packages()) install.packages("gridExtra" , depend = TRUE)
if(! "arules" %in% installed.packages()) install.packages("arules", depend = TRUE)
if(! "arulesViz" %in% installed.packages()) install.packages("arulesViz", depend = TRUE)
if(! "MASS" %in% installed.packages()) install.packages("MASS", depend = TRUE)
if(! "RMySQL" %in% installed.packages()) install.packages("RMySQL", depend = TRUE)

library(ggplot2)
library(arules)
library(arulesViz)
library(MASS)
library(DBI)

#Caso dê problema de versão do mysql rodar o script abaico: 
#mysql -u root -p
#
#SHOW GLOBAL VARIABLES LIKE 'local_infile';
#SET GLOBAL local_infile = 'ON';
#SHOW GLOBAL VARIABLES LIKE 'local_infile';

#Criando a conexcao para leitura dos dados 
connDbRead <- dbConnect(RMySQL::MySQL(), user="root", host="localhost", dbname="siconv", password="P@ssw0rd" )

#Query para as regras de associacao entre Parlamentar -> Area 
query_PA = "select p.uf_proponente
    , ep.nome_parlamentar
    , p.desc_orgao_sup
from siconv.siconv_convenio as c
join siconv.siconv_proposta as p
  on c.id_proposta = p.id_proposta
join siconv.siconv_emenda as ep
  on ep.id_proposta = p.id_proposta
where ep.tipo_parlamentar = 'INDIVIDUAL'
    and c.ano is not null
    and c.sit_convenio is not null
    and c.INSTRUMENTO_ATIVO not in ( 'NÃO', 'NAO', 'não', 'nao' )
    and ep.nome_parlamentar is not null
    #and pc.uf_proponente = 'SE'
group by p.uf_proponente, ep.nome_parlamentar, p.desc_orgao_sup
order by p.uf_proponente, ep.nome_parlamentar, p.desc_orgao_sup;"

#Query para as regras de associacao entre Parlamentar -> Fornecedor 
query_PF = "select pc.uf_proponente
        , ep.nome_parlamentar
        , pv.nome_fornecedor
from siconv.siconv_convenio as c
join siconv.siconv_proposta as pc
  on c.id_proposta = pc.id_proposta
join siconv.siconv_emenda as ep
  on ep.id_proposta = pc.id_proposta
join siconv.siconv_pagamento as pv
  on c.nr_convenio = pv.nr_convenio
where ep.tipo_parlamentar = 'INDIVIDUAL'
    and c.ano is not null
    and c.sit_convenio is not null
    and c.INSTRUMENTO_ATIVO not in ( 'NÃO', 'NAO', 'não', 'nao' )
    and ep.nome_parlamentar is not null
    and pv.nome_fornecedor is not null
    #and pc.uf_proponente = 'SE'
group by c.nr_convenio
               , ep.nome_parlamentar
               , pv.nome_fornecedor
               , pc.uf_proponente
order by c.nr_convenio
               , ep.nome_parlamentar
               , pv.nome_fornecedor
               , pc.uf_proponente"

#Query para as regras de associacao entre Parlamentar -> Cidade 
query_PC = "select pc.uf_proponente
          , ep.nome_parlamentar
          , pc.nm_proponente
from siconv.siconv_convenio as c
join siconv.siconv_proposta as pc
  on c.id_proposta = pc.id_proposta
join siconv.siconv_emenda as ep
  on ep.id_proposta = pc.id_proposta
where ep.tipo_parlamentar = 'INDIVIDUAL'
    and c.ano is not null
    and c.sit_convenio is not null
    and c.INSTRUMENTO_ATIVO not in ( 'NÃO', 'NAO', 'não', 'nao' )
group by  pc.uf_proponente, ep.nome_parlamentar, pc.nm_proponente
order by  pc.uf_proponente, ep.nome_parlamentar, pc.nm_proponente;"

#Estrutura para as querys e os seus respectivos tipo de regras:
# - 1 : Parlamentar -> Area 
# - 2 : Parlamentar -> Fornecedor
# - 3 : Parlamentar -> Cidade
querys = list( c(query_PA, 1), c(query_PF,2), c(query_PC, 3) )
df = data.frame()
for( q in querys )  
{
  query = q[1]
  tipo  = q[2]

  result <- dbGetQuery(connDbRead, query);
  estados = unique( result[1] ) 
  for( e in estados ) {   print(e[1])  }
  i=1
  while( i <= length(e) ) { 
    dadosInfo = result[ which(result$uf_proponente == e[i] ), c(2,3) ]
    dadosInfo = data.frame(sapply(dadosInfo,as.factor))
    info = as(dadosInfo, "transactions")
    regras <- apriori(info, parameter= list(supp=0.01, conf=0.1))
    regras <- subset( regras, count>1 & lift != 1 )
    regras <- regras[!is.redundant( regras )]
    #adicionando a medida de interesse "phi" - Coeficiente de coorelação de pearson 
    #quality(regras) <- cbind( quality(regras), interestMeasure( regras, c("phi")            , transactions = info, reuse = TRUE) )
    quality(regras)$phi <- interestMeasure(regras, measure="phi", trans = info)

    #adicionando a medida de interesse "X-Square"
    #quality(regras) <- cbind( quality(regras), interestMeasure( regras, c("chiSquared")     , transactions = info, reuse = TRUE) )
    quality(regras)$x2 <- interestMeasure(regras, measure="chiSquared", trans = info)

    #adicionando a medida de interesse "p-value"
    #quality(regras) <- cbind( quality(regras), interestMeasure( regras, c("chiSquared"), significance = TRUE, transactions = info, reuse = TRUE) )
    quality(regras)$p <- interestMeasure(regras, measure="chiSquared", significance = TRUE, trans = info)

    if ( length( regras ) > 0 ){
      #write(regras, file=paste("./regras/area/", paste(e[i], "_regras_Parlamentar_Area.csv", sep=""), sep=""), sep=";", col.names=NA)
      # Converter um Arule em um data frame
      dfAux = data.frame(
        lhs = labels(lhs(regras)),
        rhs = labels(rhs(regras)),
        regras@quality
      )
      # Adicionar colunas a um data frame
      # Tipo: 1;"Parlamentares > Area" | 2;"Parlamentares > Fornecedor" | 3;"Parlamentares > Cidade"
      dfAux = transform(dfAux, uf=e[i], cd_regra=1)
      # Adicionar um data frame a outro
      df = rbind(df, dfAux)
    }#end: if ( length( regras )

    i=i+1
  }#end: while de estados 
  #names(df)[7] = "phi"
  #names(df)[8] = "x2"
  #names(df)[9] = "p"
  #names(df)[11] = "cd_regra"  
  connDbWrite <- dbConnect(RMySQL::MySQL(), user="root", host="localhost", dbname="siconvminerado", password="P@ssw0rd" )
  dbWriteTable( connDbWrite, "regra_encontrada", value=df, append=TRUE, row.names=FALSE)
  df = data.frame()
}#end: for de querys

#connDbWrite <- dbConnect(RMySQL::MySQL(), user="root", host="localhost", dbname="siconvminerado", password="P@ssw0rd" )
#dbWriteTable( connDbWrite, "regra_encontrada", value=df, append=TRUE, row.names=FALSE)

  #cont = 1
  #while( cont <= nrow(df) ) {
  #  dbWriteTable(connDbWrite, "regra_encontrada", value=df[cont,] ,append=TRUE, row.names=FALSE)
  #  cont = cont + 1
  #}