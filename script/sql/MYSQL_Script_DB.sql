create database siconv;

use siconv;

DROP TABLE IF EXISTS siconv.estado;
CREATE TABLE siconv.estado
(
  descricao varchar(30) NOT NULL,
  uf char(2) NOT NULL,
  CONSTRAINT estado_pkey PRIMARY KEY (uf)
);

insert into siconv.estado values ( 'São Paulo', 'SP' );
insert into siconv.estado values ( 'Minas Gerais', 'MG' );
insert into siconv.estado values ( 'Pernambuco', 'PE' );
insert into siconv.estado values ( 'Bahia', 'BA' );
insert into siconv.estado values ( 'Rio Grande do Sul', 'RS' );
insert into siconv.estado values ( 'Rio de Janeiro', 'RJ' );
insert into siconv.estado values ( 'Paraná', 'PR' );
insert into siconv.estado values ( 'Ceara', 'CE' );
insert into siconv.estado values ( 'Mato Grosso do Sul', 'MS' );
insert into siconv.estado values ( 'Santa Catarina', 'SC' );
insert into siconv.estado values ( 'Goiás', 'GO' );
insert into siconv.estado values ( 'Paraíba', 'PB' );
insert into siconv.estado values ( 'Maranhão', 'MA' );
insert into siconv.estado values ( 'Alagoas', 'AL' );
insert into siconv.estado values ( 'Mato Grosso', 'MT' );
insert into siconv.estado values ( 'Distrito Federal', 'DF' );
insert into siconv.estado values ( 'Amazonas', 'AM' );
insert into siconv.estado values ( 'Piauí', 'PI' );
insert into siconv.estado values ( 'Para', 'PA' );
insert into siconv.estado values ( 'Rio Grande do Norte', 'RN' );
insert into siconv.estado values ( 'Roraima', 'RR' );
insert into siconv.estado values ( 'Sergipe', 'SE' );
insert into siconv.estado values ( 'Espirito Santo', 'ES' );
insert into siconv.estado values ( 'Tocantins', 'TO' );
insert into siconv.estado values ( 'Acre', 'AC' );
insert into siconv.estado values ( 'Rondonia', 'RO' );
insert into siconv.estado values ( 'Amapá', 'AP' );


DROP TABLE IF EXISTS siconv.siconv_proposta;
CREATE TABLE siconv.siconv_proposta
(
  id_proposta bigint,
  uf_proponente char(2),
  munic_proponente varchar(100),
  cod_munic_ibge int,
  cod_orgao_sup int,
  desc_orgao_sup varchar(100),
  natureza_juridica varchar(100),
  nr_proposta varchar(100),
  dia_prop int,
  mes_prop int,
  ano_prop int,
  dia_proposta date,
  cod_orgao int,
  desc_orgao text,
  modalidade varchar(500),
  identif_proponente varchar(500),
  nm_proponente varchar(500),
  cep_proponente varchar(15),
  endereco_proponente varchar(500),
  bairro_proponente varchar(500),
  nm_banco varchar(500),
  situacao_conta varchar(500),
  situacao_projeto_basico varchar(500),
  sit_proposta varchar(500),
  dia_inic_vigencia_proposta date,
  dia_fim_vigencia_proposta date,
  objeto_proposta text,
  vl_global_prop numeric(15,2),
  vl_repasse_prop numeric(15,2),
  vl_contrapartida_prop numeric(15,2)
);

DROP TABLE IF EXISTS siconv.siconv_convenio;
create table siconv.siconv_convenio
(
    NR_CONVENIO                  bigint        null,
    ID_PROPOSTA                  bigint        null,
    DIA                          smallint      null,
    MES                          smallint      null,
    ANO                          smallint      null,
    DIA_ASSIN_CONV               date          null,
    SIT_CONVENIO                 varchar(100)  null,
    SUBSITUACAO_CONV             varchar(100)  null,
    SITUACAO_PUBLICACAO          varchar(100)  null,
    INSTRUMENTO_ATIVO            varchar(10)   null,
    IND_OPERA_OBTV               varchar(10)   null,
    NR_PROCESSO                  varchar(100)  null,
    UG_EMITENTE                  varchar(100)  null,
    DIA_PUBL_CONV                date          null,
    DIA_INIC_VIGENC_CONV         date          null,
    DIA_FIM_VIGENC_CONV          date          null,
    DIA_FIM_VIGENC_ORIGINAL_CONV date       null,
    DIAS_PREST_CONTAS            int           null,
    DIA_LIMITE_PREST_CONTAS      date          null,
    SITUACAO_CONTRATACAO         varchar(100)  null,
    IND_ASSINADO                 varchar( 10)  null,
    MOTIVO_SUSPENSAO             text          null,
    IND_FOTO                     varchar( 10)  null,
    QTDE_CONVENIOS               int           null,
    QTD_TA                       int           null,
    QTD_PRORROGA                 int           null,
    VL_GLOBAL_CONV               numeric(17,2) null,
    VL_REPASSE_CONV              numeric(17,2) null,
    VL_CONTRAPARTIDA_CONV        numeric(17,2) null,
    VL_EMPENHADO_CONV            numeric(17,2) null,
    VL_DESEMBOLSADO_CONV         numeric(17,2) null,
    VL_SALDO_REMAN_TESOURO       numeric(17,2) null,
    VL_SALDO_REMAN_CONVENENTE    numeric(17,2) null,
    VL_RENDIMENTO_APLICACAO      numeric(17,2) null,
    VL_INGRESSO_CONTRAPARTIDA    numeric(17,2) null,
    VL_SALDO_CONTA               numeric(17,2) null 
);

DROP TABLE IF EXISTS siconv.siconv_emenda;
CREATE TABLE siconv.siconv_emenda
(
  id_proposta bigint,
  qualif_proponente varchar(300),
  cod_programa_emenda bigint,
  nr_emenda bigint,
  nome_parlamentar varchar(300),
  beneficiario_emenda varchar(300),
  ind_impositivo varchar(300),
  tipo_parlamentar varchar(300),
  valor_repasse_proposta_emenda numeric(17,2),
  valor_repasse_emenda numeric(17,2)
);

DROP TABLE IF EXISTS siconv.siconv_pagamento
CREATE TABLE siconv.siconv_pagamento
(
  nr_mov_fin int,
  nr_convenio bigint,
  identif_fornecedor varchar(100),
  nome_fornecedor varchar(300),
  tp_mov_financeira varchar(200),
  data_pag date,
  nr_dl text,
  desc_dl text,
  vl_pago numeric(15,2)
);

DROP TABLE IF EXISTS siconv.populacao_estimada
CREATE TABLE siconv.populacao_estimada
(
   uf       char(2)      not null,
   cd_uf    int          not null,
   cd_munic int          not null, 
   nm_munic varchar(100) not null,
   nr_habit int          not null
);


create database siconvminerado;
use siconvminerado;

DROP TABLE IF EXISTS siconvminerado.dados_gerais;
create table siconvminerado.dados_gerais
(
  local     varchar( 30 ) not null, 
  parametro varchar( 30 )   not null,
  valor     varchar( 30 ) not null,
  CONSTRAINT dados_gerais_pkey PRIMARY KEY (local, parametro)
);

insert into siconvminerado.dados_gerais 
  select 'index' 
       , 'qtd_parlamentares'
       ,  ( select count( distinct(nome_parlamentar)) from siconv.siconv_emenda where tipo_parlamentar = 'INDIVIDUAL' ) 

insert into siconvminerado.dados_gerais 
  select 'index' 
       , 'qtd_convenios'
       , ( select count(*) from siconv.siconv_emenda ) 

insert into siconvminerado.dados_gerais 
  select 'index' 
        , 'qtd_empresas'
       , ( select count( distinct(identif_fornecedor) ) from siconv.siconv_pagamento )

DROP TABLE IF EXISTS siconvminerado.numero_total;
create table siconvminerado.numero_total
(
   ano int not null,
   mes int not null,
   uf  char(2) not null,
   nr_habit int not null,
   qtd_proposta int not null,
   qtd_convenio int not null,
   vl_total_proposta numeric(17,2),
   vl_total_convenio numeric(17,2),
   vl_total_contrapartida_conv numeric(17,2)
);

insert into siconvminerado.numero_total
select ano_prop
     , mes_prop
     , p.uf_proponente
     , ( select sum(nr_habit) from siconv.populacao_estimada as pe where pe.uf = p.uf_proponente ) as nr_habit
     , count(  p.id_proposta ) as qtd_proposta
     , count( c.NR_CONVENIO ) as qtd_convenio
     , sum(p.vl_global_prop) as vl_global_prop
     , sum(c.vl_global_conv) as vl_global_conv
     , sum(c.vl_contrapartida_conv) as vl_contrapartida_conv
from siconv.siconv_proposta as p
left join siconv.siconv_convenio     as c
  on p.id_proposta = c.id_proposta
#where uf_proponente in ( 'SE' )
group by ano_prop, mes_prop, uf_proponente
order by ano_prop, mes_prop, uf_proponente


drop table  IF EXISTS siconvminerado.situacao_convenio;
create table siconvminerado.situacao_convenio
(
   ano int not null,
   mes int not null,
   uf  char(2) not null,
   sit_convenio varchar(100) not null,
   qtd_convenio int not null,
   vl_global_conv numeric(17,2),
   cidade varchar( 100) not null,
   area varchar(100) not null
);

insert into siconvminerado.situacao_convenio
    select c.ano
         , c.mes
         , p.uf_proponente
         , c.sit_convenio
         , count(c.NR_CONVENIO) as qtd
         , sum( c.vl_global_conv) as vl_global_conv
         , p.munic_proponente
         , p.desc_orgao_sup
  from siconv.siconv_proposta as p
left join siconv.siconv_convenio     as c
    on p.id_proposta = c.id_proposta
  where c.ANO is not null
    and c.MES is not null 
    and c.sit_convenio is not null 
    #and uf_proponente in ( 'SE' )
  group by c.ano, c.mes, p.uf_proponente, c.sit_convenio, p.munic_proponente, p.desc_orgao_sup;

drop table IF EXISTS  siconvminerado.paralamentares_total_convenio;
create table siconvminerado.paralamentares_total_convenio
(
   ano int not null,
   mes int not null,
   uf  char(2) not null,
   nm_parlamentar varchar(100) not null,
   tipo_parlamentar varchar(100) not null,
   sit_convenio varchar(100) not null,
   qtd_convenio int not null,
   vl_global_conv numeric(17,2)
);

insert into siconvminerado.paralamentares_total_convenio
  select c.ano
       , c.mes
       , p.uf_proponente
       , ep.nome_parlamentar
       , ep.tipo_parlamentar
       , c.sit_convenio
       , count(c.NR_CONVENIO) as qtd
       , sum(c.vl_global_conv) as vl_global_conv
  from siconv.siconv_proposta as p
  join siconv.siconv_emenda as ep 
    on p.id_proposta = ep.id_proposta 
  join siconv.siconv_convenio     as c
    on ep.id_proposta = c.id_proposta
  where c.ano is not null 
     and c.mes is not null
     and c.sit_convenio is not null 
     and ep.tipo_parlamentar = 'INDIVIDUAL'
  group by c.ano
       , c.mes
       , p.uf_proponente
       , ep.nome_parlamentar
       , ep.tipo_parlamentar
       , c.sit_convenio;


drop table IF EXISTS siconvminerado.valores_convenio;
create table siconvminerado.valores_convenio
(
   id serial,
   ano int not null,
   mes int not null,
   uf  char(2) not null,
   vl_global_conv numeric(17,2),
   nr_convenio bigint,
   id_proposta bigint,
   sit_convenio varchar(100),
   primary key ( id ) 
);

insert into siconvminerado.valores_convenio (ano, mes, uf, vl_global_conv, nr_convenio, id_proposta, sit_convenio )
  select c.ano
       , c.mes
       , p.uf_proponente
       , c.vl_global_conv
       , c.nr_convenio
       , c.id_proposta
       , c.sit_convenio
  from siconv.siconv_proposta as p
  join siconv.siconv_emenda as ep 
    on p.id_proposta = ep.id_proposta 
  join siconv.siconv_convenio as c
    on ep.id_proposta = c.id_proposta
  where ano is not null
    and mes is not null
     and ep.tipo_parlamentar = 'INDIVIDUAL' 
       and c.sit_convenio is not null
       and INSTRUMENTO_ATIVO not in ( 'NÃO', 'NAO', 'não', 'nao' );


drop table IF EXISTS siconvminerado.regra;
Create table siconvminerado.regra
(
    cd_regra int not null primary key,
    nm_regra varchar(100) not null,
    st_ativa smallint not null default 1
);

insert into siconvminerado.regra values( 1, 'Parlamentares > Area', 1); 
insert into siconvminerado.regra values( 2, 'Parlamentares > Fornecedor', 1); 
insert into siconvminerado.regra values( 3, 'Parlamentares > Cidade', 1); 


drop table IF EXISTS siconvminerado.regra;
CREATE TABLE siconvminerado.regra_encontrada (
  "row_names" int,
  "lhs" text,
  "rhs" text,
  "support" double DEFAULT NULL,
  "confidence" double DEFAULT NULL,
  "lift" double DEFAULT NULL,
  "count" double DEFAULT NULL,
  "phi" double DEFAULT NULL,
  "x2" double DEFAULT NULL,
  "p" double DEFAULT NULL,
  "uf" text,
  "cd_regra" int
);


drop table IF EXISTS siconvminerado.tooltip;
create table siconvminerado.tooltip(
  uf_proponente character(2) primary key,
  nr_habit bigint,
  qtd_parlamentar int, 
  qtd_proposta int ,
  vl_global_prop numeric(17,2),
  qtd_convenio int ,
  vl_global_conv numeric(17,2)
);

insert into  siconvminerado.tooltip 
   select p.uf_proponente, 
   ( select sum(nr_habit) from siconv.populacao_estimada as pe where pe.uf = p.uf_proponente ) as nr_habit, 
   ( select count( distinct ep1.nome_parlamentar )
         from siconv.siconv_proposta as p1 
         join siconv.siconv_convenio as c1 on p1.id_proposta = c1.id_proposta 
         join siconv.siconv_emenda as ep1 on p1.id_proposta = ep1.id_proposta 
       where ep1.tipo_parlamentar = 'INDIVIDUAL' 
         and p1.uf_proponente = p.uf_proponente ) as qtd_parlamentar , 
  count(p.id_proposta) as qtd_proposta, 
    sum(p.vl_global_prop) as vl_global_prop, 
    count(c.NR_CONVENIO) as qtd_convenio, 
    sum(c.vl_global_conv) as vl_global_conv 
    from siconv.siconv_proposta as p 
    left join siconv.siconv_convenio as c on p.id_proposta = c.id_proposta 
group by uf_proponente;


#########
CREATE INDEX idx_siconv_convenio_nr_convenio ON siconv.siconv_convenio( NR_CONVENIO );
CREATE INDEX idx_siconv_convenio_id_proposta  ON siconv.siconv_convenio( ID_PROPOSTA );
CREATE INDEX idx_siconv_convenio_ano_mes      ON siconv.siconv_convenio( ano, mes );
CREATE INDEX idx_siconv_convenio_sit_conv       ON siconv.siconv_convenio( SIT_CONVENIO );
CREATE INDEX idx_siconv_convenio_ano_mes_sit_conv ON siconv.siconv_convenio( ano, mes, SIT_CONVENIO );

CREATE INDEX idx_siconv_proposta_id_proposta ON siconv.siconv_proposta( id_proposta );
CREATE INDEX idx_siconv_proposta_uf_proponente ON siconv.siconv_proposta( uf_proponente);
CREATE INDEX idx_siconv_proposta_uf_munic ON siconv.siconv_proposta( uf_proponente, munic_proponente );
CREATE INDEX idx_siconv_proposta_ano_mes ON siconv.siconv_proposta( ano_prop, mes_prop );
CREATE INDEX idx_siconv_proposta_sit_proposta ON siconv.siconv_proposta( sit_proposta );

CREATE INDEX idx_siconv_emenda_id_proposta  ON siconv.siconv_emenda( ID_PROPOSTA );
CREATE INDEX idx_siconv_emenda_nome_parlamentar  ON siconv.siconv_emenda( nome_parlamentar  );