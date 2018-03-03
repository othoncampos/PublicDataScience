create database sivonv;


CREATE TABLE convenio_assinado
(
  nr_convenio bigint,
  id_proposta bigint,
  dia smallint,
  mes smallint,
  ano smallint,
  dia_assin_conv date,
  sit_convenio varchar(100),
  subsituacao_conv varchar(100),
  situacao_publicacao varchar(100),
  instrumento_ativo varchar(10),
  ind_opera_obtv varchar(10),
  nr_processo varchar(100),
  ug_emitente varchar(100),
  dia_publ_conv date,
  dia_inic_vigenc_conv date,
  dia_fim_vigenc_conv date,
  dias_prest_contas int,
  dia_limite_prest_contas date,
  qtde_convenios int,
  qtd_ta int,
  qtd_prorroga int,
  vl_global_conv numeric(17,2),
  vl_repasse_conv numeric(17,2),
  vl_contrapartida_conv numeric(17,2),
  vl_empenhado_conv numeric(17,2),
  vl_desembolsado_conv numeric(17,2),
  vl_saldo_reman_tesouro numeric(17,2),
  vl_saldo_reman_convenente numeric(17,2),
  vl_ingresso_contrapartida numeric(17,2)
);

CREATE TABLE desembolsos
(
  nr_convenio bigint,
  dt_ult_desembolso date,
  qtd_dias_sem_desembolso int,
  data_desembolso date,
  ano_desembolso int,
  mes_desembolso int,
  nr_siafi varchar(100),
  vl_desembolsado numeric(15,2)
);

CREATE TABLE emendas_parlamentares
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

CREATE TABLE empenhos_realizados
(
  nr_convenio bigint,
  nr_empenho varchar(100),
  tipo_nota int,
  desc_tipo_nota varchar(100),
  data_emissao date,
  cod_situacao_empenho int,
  desc_situacao_empenho varchar(100),
  valor_empenho numeric(15,2)
);

CREATE TABLE historico_situacao_propostas
(
  id_proposta bigint,
  nr_convenio bigint,
  dia_historico_sit date,
  historico_sit varchar(100),
  dias_historico_sit int,
  cod_historico_sit int
);

CREATE TABLE ingresso_contrapartida
(
  nr_convenio bigint,
  dt_ingresso_contrapartida date,
  vl_ingresso_contrapartida numeric(15,2)
);

CREATE TABLE obtv_convenente
(
  nr_mov_fin bigint,
  identif_favorecido_obtv_conv varchar(100),
  nm_favorecido_obtv_conv varchar(300),
  tp_aquisicao varchar(100),
  vl_pago_obtv_conv numeric(15,2)
);

CREATE TABLE pagamentos_favorecidos
(
  nr_mov_fin int,
  nr_convenio bigint,
  identif_fornecedor varchar(100),
  nome_fornecedor text,
  tp_mov_financeira varchar(200),
  data_pag date,
  nr_dl text,
  desc_dl text,
  vl_pago numeric(15,2)
);

CREATE TABLE plano_aplicacao_detalhado
(
  id_proposta bigint,
  sigla char(2),
  municipio varchar(200),
  natureza_aquisicao int,
  descricao_item text,
  cep_item varchar(100),
  endereco_item text,
  tipo_despesa_item varchar(200),
  natureza_despesa varchar(200),
  sit_item varchar(200),
  qtd_item numeric(15,2),
  valor_unitario_item numeric(15,2),
  valor_total_item numeric(15,2)
);

CREATE TABLE programas_disponibilizados
(
  cod_orgao_sup_programa int,
  desc_orgao_sup_programa varchar(500),
  id_programa int,
  cod_programa bigint,
  nome_programa varchar(500),
  sit_programa varchar(500),
  data_disponibilizacao date,
  ano_disponibilizacao int,
  dt_prog_ini_receb_prop date,
  dt_prog_fim_receb_prop date,
  dt_prog_ini_emenda_par date,
  dt_prog_fim_emenda_par date,
  dt_prog_ini_benef_esp date,
  dt_prog_fim_benef_esp date,
  modalidade_programa varchar(500),
  natureza_juridica_programa varchar(500),
  uf_programa char(2)
);

CREATE TABLE programas_propostas
(
  id_programa bigint,
  id_proposta bigint
);

CREATE TABLE propostas_cadastradas
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

CREATE TABLE prorroga_oficio
(
  nr_convenio bigint,
  nr_prorroga varchar(500),
  dt_inicio_prorroga date,
  dias_prorroga int,
  dt_fim_prorroga date,
  dt_assinatura_prorroga date,
  sit_prorroga varchar(100)
);

CREATE TABLE termo_aditivo
(
  nr_convenio bigint,
  numero_ta varchar(100),
  tipo_ta varchar(100),
  dt_assinatura_ta date,
  dt_inicio_ta date,
  dt_fim_ta date,
  justificativa_ta text
);