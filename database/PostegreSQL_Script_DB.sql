--create database siconv;

drop table if exists programas_disponibilizados;
drop table if exists programas_propostas;
drop table if exists propostas_cadastradas;
drop table if exists emendas_parlamentares;
drop table if exists plano_aplicacao_detalhado;
drop table if exists convenio_assinado;
drop table if exists empenhos_realizados;
drop table if exists desembolsos;
drop table if exists ingresso_contrapartida;
drop table if exists pagamentos_favorecidos;
drop table if exists OBTV_convenente;
drop table if exists termo_aditivo;
drop table if exists prorroga_oficio;
drop table if exists historico_situacao_propostas;
drop table if exists populacao_estimada;

create table programas_disponibilizados
( 
    COD_ORGAO_SUP_PROGRAMA     int          null, --Código do Órgão executor do Programa
    DESC_ORGAO_SUP_PROGRAMA    varchar(100) null, --Nome do Órgão executor do Programa
    ID_PROGRAMA                int          null, --Código Sequencial do Sistema para um Programa
    COD_PROGRAMA               bigint       null, --Chave que identifica o programa composta por: (Cód.Órgão+Ano+Cód.Sequencial do Sistema)
    NOME_PROGRAMA              varchar(100) null, --Descrição do Programa de Governo
    SIT_PROGRAMA               varchar(100) null, --Situação atual do Programa. Domínio: Cadastrado; Disponibilizado; Inativo
    DATA_DISPONIBILIZACAO      date         null, --Data de disponibilização do Programa
    ANO_DISPONIBILIZACAO       int          null, --Ano de disponibilização do Programa
    DT_PROG_INI_RECEB_PROP     date         null, --Data Início para o recebimento das propostas voluntárias para o Programa
    DT_PROG_FIM_RECEB_PROP     date         null, --Data Fim para o recebimento das propostas voluntárias para o Programa
    DT_PROG_INI_EMENDA_PAR     date         null, --Data Início para o recebimento das propostas de Emenda Parlamentar para o Programa
    DT_PROG_FIM_EMENDA_PAR     date         null, --Data Fim para o recebimento das propostas de Emenda Parlamentar para o Programa
    DT_PROG_INI_BENEF_ESP      date         null, --Data Início para o recebimento das propostas de beneficiário específico para o Programa
    DT_PROG_FIM_BENEF_ESP      date         null, --Data Fim para o recebimento das propostas de beneficiário específico para o Programa
    MODALIDADE_PROGRAMA        varchar(100) null, --Modalidade do Programa. Domínio pode ser: CONTRATO DE REPASSE, CONVENIO, TERMO DE COLABORACAO, TERMO DE FOMENTO e TERMO DE PARCERIA
    NATUREZA_JURIDICA_PROGRAMA varchar(100) null, --Natureza Jurídica Atendida pelo Programa. Domínio: Administração Pública Estadual ou do Distrito Federal, Administração Pública Municipal, Consórcio Público, Empresa pública/Sociedade de economia mista e Organização da Sociedade Civil
    UF_PROGRAMA                char(2)      null --Ufs Habilitadas para o Programa. Domínio: AC, AL, AM, AP, BA, CE, DF, ES, GO, MA, MG, MS, MT, PA, PB, PE, PI, PR, RJ, RN, RO, RR, RS, SC, SE, SP, TO, <null>. Quando o valor é nulo, o programa atende a todo o Brasil
);

create table programas_propostas
(
    ID_PROGRAMA bigint null, --Código Sequencial do Sistema para um Programa
    ID_PROPOSTA bigint null --Código Sequencial do Sistema para uma Proposta
);

create table propostas_cadastradas
(
    ID_PROPOSTA                bigint       null, --Código Sequencial do Sistema para uma Proposta
    UF_PROPONENTE              char(2)      null, --UF do Proponente. Domínio: AC, AL, AM, AP, BA, CE, DF, ES, GO, MA, MG, MS, MT, PA, PB, PE, PI, PR, RJ, RN, RO, RR, RS, SC, SE, SP, TO
    MUNIC_PROPONENTE           varchar(100) null, --Município do Proponente
    COD_MUNIC_IBGE             int          null, --Código IBGE do Município
    COD_ORGAO_SUP              int          null, --Código do Órgão Superior do Concedente
    DESC_ORGAO_SUP             varchar(100) null, --Nome do Órgão Superior do Concedente
    NATUREZA_JURIDICA          varchar(100) null, --Natureza Jurídica do Proponente. Domínio: Administração Pública Estadual ou do Distrito Federal, Administração Pública Municipal, Consórcio Público, Empresa pública/Sociedade de economia mista e Organização da Sociedade Civil
    NR_PROPOSTA                int          null, --Número da Proposta gerado pelo Siconv
    DIA_PROP                   int          null, --Dia do cadastro da Proposta
    MES_PROP                   int          null, --Mês do cadastro da Proposta
    ANO_PROP                   int          null, --Ano do cadastro da Proposta
    DIA_PROPOSTA               int          null, --Data do cadastro da Proposta
    COD_ORGAO                  int          null, --Código do Órgão ou Entidade Concedente
    DESC_ORGAO                 varchar(100) null, --Nome do Órgão ou Entidade Concedente
    MODALIDADE                 varchar(100) null, --Modalidade da Proposta. Domínio pode ser: CONTRATO DE REPASSE, CONVENIO, TERMO DE COLABORACAO, TERMO DE FOMENTO e TERMO DE PARCERIA
    IDENTIF_PROPONENTE         varchar(15)  null, --CNPJ do Proponente
    NM_PROPONENTE              varchar(100) null, --Nome da Entidade Proponente
    CEP_PROPONENTE             varchar(8)   null, --CEP do Proponente
    ENDERECO_PROPONENTE        varchar(100) null, --Endereço do Proponente
    BAIRRO_PROPONENTE          varchar(100) null, --Bairro do Proponente
    NM_BANCO                   varchar(100) null, --Nome do Banco para depósito do recurso da Transferência Voluntária
    SITUACAO_CONTA             varchar(100) null, --Situação atual da conta bacária do instrumento. Domínio: Aguardando Retorno do Banco, Enviada, Cadastrada, Registrada, Erro na Abertura de Conta, Regularizada, A Verificar, Aguardando Envio e Pendente de Regularização
    SITUACAO_PROJETO_BASICO    varchar(100) null, --Situação atual do Projeto Básico/Termo de Referência. Domínio: Aguardando Projeto Básico, Não Cadastrado, Projeto Básico Aprovado, Projeto Básico em Análise, Projeto Básico em Complementação, Projeto Básico Rejeitado
    SIT_PROPOSTA               varchar(100) null, --Situação atual da Proposta. Domínio pode ser: Proposta/Plano de Trabalho Cadastrados, Proposta/Plano de Trabalho em Análise, Proposta/Plano de Trabalho Rejeitados, Proposta/Plano de Trabalho Aprovados, etc
    DIA_INIC_VIGENCIA_PROPOSTA date null, --Data Início da Vigência da Proposta
    DIA_FIM_VIGENCIA_PROPOSTA  date null, --Data Fim da Vigência da Proposta
    OBJETO_PROPOSTA            varchar(200) null, --Descrição do Objeto da Proposta
    VL_GLOBAL_PROP             numeric(15,2) null, --Valor Global da proposta cadastrada (Valor de Repasse Proposta + Valor Contrapartida Proposta)
    VL_REPASSE_PROP            numeric(15,2) null, --Valor de Repasse do Governo Federal referente a proposta cadastrada
    VL_CONTRAPARTIDA_PROP      numeric(15,2) null --Valor da Contrapartida apresentada na proposta pelo convenente
);

create table emendas_parlamentares
(
    ID_PROPOSTA                    bigint        null, --Código Sequencial do Sistema para uma Proposta
    QUALIF_PROPONENTE              varchar(100)  null, --Qualificação do proponente
    COD_PROGRAMA_EMENDA            bigint        null, --Chave que identifica o programa composta por: (Cód.Órgão+Ano+Cód.Sequencial do Sistema)
    NR_EMENDA                      bigint        null, --Número da Emenda Parlamentar
    NOME_PARLAMENTAR               varchar(100)  null, --Nome do Parlamentar
    BENEFICIARIO_EMENDA            varchar(100)  null, --CNPJ do Proponente
    IND_IMPOSITIVO                 varchar(100)  null, --Indicativo de Orçamento Impositivo (Tipo Parlamentar igual a INDIVIDUAL + Ano de Cadastro da Proposta >= 2014). Domínio: SIM, NÃO
    TIPO_PARLAMENTAR               varchar(100)  null, --Tipo do Parlamentar. Domínio pode ser: INDIVIDUAL, COMISSAO, BANCADA
    VALOR_REPASSE_PROPOSTA_EMENDA  numeric(17,2) null, --Valor da Emenda cadastrada na proposta
    VALOR_REPASSE_EMENDA           numeric(17,2) null  --Valor da Emenda assinada
);

create table plano_aplicacao_detalhado
(
    ID_PROPOSTA          bigint       null, --Código Sequencial do Sistema para uma Proposta
    SIGLA                char(2)      null, -- UF cadastrada referente a localidade do item. Domínio: AC, AL, AM, AP, BA, CE, DF, ES, GO, MA, MG, MS, MT, PA, PB, PE, PI, PR, RJ, RN, RO, RR, RS, SC, SE, SP, TO
    MUNICIPIO            varchar(100) null,  --Município cadastrado referente a localidade do item
    NATUREZA_AQUISICAO   int          null, --Código de natureza de aquisição
    DESCRICAO_ITEM       text         null, --Descrição do Item
    CEP_ITEM             varchar(100)   null, --CEP cadastrado referente a localidade do item
    ENDERECO_ITEM        varchar(100) null,  --Endereço cadastrado referente a localidade do item
    TIPO_DESPESA_ITEM    varchar(100) null,  --Tipo da Despesa. Domínio: SERVICO, BEM, OUTROS, TRIBUTO, OBRA e DESPESA_ADMINISTRATIVA
    NATUREZA_DESPESA     varchar(100) null,  --Natureza da Despesa referente ao item
    SIT_ITEM             varchar(100) null,  --Situação atual do Item. Domínio: APROVADO
    QTD_ITEM             int          null, --Quantidade de Itens
    VALOR_UNITARIO_ITEM  numeric(15,2) null, --Valor unitário do item
    VALOR_TOTAL_ITEM     numeric(15,2) null --Valor total do item
);

create table convenio_assinado
(
    NR_CONVENIO               bigint        null, --Número gerado pelo Siconv. Possui faixa de numeração reservada que vai de 700000 a 999999
    ID_PROPOSTA               bigint       null, --Código Sequencial do Sistema para uma Proposta
    DIA                       smallint      null, --Dia em que o Convênio foi assinado
    MES                       smallint      null, --Mês em que o Convênio foi assinado
    ANO                       smallint      null, --Ano Assinatura do Convênio
    DIA_ASSIN_CONV            date          null, --Data Assinatura do Convênio
    SIT_CONVENIO              varchar(100)  null, --Situação atual do Convênio. Domínio: Em execução, Convênio Anulado, Prestação de Contas enviada para Análise, Prestação de Contas Aprovada, Prestação de Contas em Análise, Prestação de Contas em Complementação, Inadimplente, etc
    SUBSITUACAO_CONV          varchar(100)  null, --Sub-Situação atual do Convênio. Domínio: Convênio, Convênio Cancelado, Convênio Encerrado, Proposta, Em aditivação
    SITUACAO_PUBLICACAO       varchar(100)  null, --Situação atual da Publicação do instrumento. Domínio: Publicado e Transferido para IN
    INSTRUMENTO_ATIVO         varchar(10)   null, --Convênios que ainda não foram finalizados. Domínio: SIM, NÃO
    IND_OPERA_OBTV            varchar(10)   null, --Indicativo de que o Convênio opera com OBTV. Domínio: SIM, NÃO
    NR_PROCESSO               varchar(100)  null, --Número interno do processo físico do instrumento
    DIA_PUBL_CONV             date          null, --Data da Publicação do Convênio
    DIA_INIC_VIGENC_CONV      date          null, --Data de Início de Vigência do Convênio
    DIA_FIM_VIGENC_CONV       date          null, --Data de Fim de Vigência do Convênio
    DIAS_PREST_CONTAS         int           null, --Pazo para a Prestação de Contas do Convênio
    DIA_LIMITE_PREST_CONTAS   date          null, --Data limite para Prestação de Contas do Convênio
    QTDE_CONVENIOS            int           null, --Quantidade de Instrumentos Assinados
    QTD_TA                    int           null, --Quantidade de Termos Aditivos
    QTD_PRORROGA              int           null, --Quantidade de Prorrogas de Ofício
    VL_GLOBAL_CONV            numeric(17,2) null, --Valor global dos Instrumentos assinados (Valor de Repasse + Valor Contrapartida)
    VL_REPASSE_CONV           numeric(17,2) null, --Valor total do aporte do Governo Federal referente a celebração do Instrumento
    VL_CONTRAPARTIDA_CONV     numeric(17,2) null, --Valor total da Contrapartida que será disponibilizada pelo convenente
    VL_EMPENHADO_CONV         numeric(17,2) null, --Valor total empenhado do Governo Federal para os Instrumentos
    VL_DESEMBOLSADO_CONV      numeric(17,2) null, --Valor total desembolsado do Governo Federal para a conta do Instrumento
    VL_SALDO_REMAN_TESOURO    numeric(17,2) null, --Valores devolvidos ao Tesouro ao término do instrumento
    VL_SALDO_REMAN_CONVENENTE numeric(17,2) null, --Valores devolvidos ao Convenente ao término do instrumento
    VL_INGRESSO_CONTRAPARTIDA numeric(17,2) null  --Total de valores referente a ingresso de contrapartida dos Instrumentos
);

create table empenhos_realizados
(
    NR_CONVENIO           bigint        null, --Número gerado pelo Siconv. Possui faixa de numeração reservada que vai de 700000 a 999999
    NR_EMPENHO            varchar(100)  null, --Número da Nota de Empenho
    TIPO_NOTA             int           null, --Código do Tipo de Empenho
    DESC_TIPO_NOTA        varchar(100)  null, --Descrição do Tipo de Empenho. Domínio: Empenho Original, Empenho de Despesa Pré-Empenhada, Anulação de Empenho, Reforço de Empenho, Estorno de Anulação de Empenho, etc
    DATA_EMISSAO          date          null, --Data de emissão do Empenho
    COD_SITUACAO_EMPENHO  int           null, --Código da Situação atual do empenho
    DESC_SITUACAO_EMPENHO varchar(100)  null, --Descrição da Situação atual do empenho. Domínio: Registrado no SIAFI e Enviado
    VALOR_EMPENHO         numeric(15,2) null  --Valor empenhado
);

 -- (Ordem Bancária)
create table desembolsos
(
    NR_CONVENIO             bigint        null, --Número gerado pelo Siconv. Possui faixa de numeração reservada que vai de 700000 a 999999
    DT_ULT_DESEMBOLSO       date          null, --Data da última Ordem Bancária gerada
    QTD_DIAS_SEM_DESEMBOLSO int           null, --Indicador de dias sem desembolso. Domínio: 90,180 e 365 dias
    DATA_DESEMBOLSO         date          null, --Data da Ordem Bancária
    ANO_DESEMBOLSO          int           null, --Ano da Ordem Bancária
    MES_DESEMBOLSO          int           null, --Mês da Ordem Bancária
    NR_SIAFI                varchar(100)  null, --Número do Documento no SIAFI
    VL_DESEMBOLSADO         numeric(15,2) null  --Valor disponibilizado pelo Governo Federal para a conta do instrumento
);

create table ingresso_contrapartida
(
    NR_CONVENIO               bigint        null, --Número gerado pelo Siconv. Possui faixa de numeração reservada que vai de 700000 a 999999
    DT_INGRESSO_CONTRAPARTIDA date          null, --Data da disponibilização do recurso por parte do Convenente
    VL_INGRESSO_CONTRAPARTIDA numeric(15,2) null  --Valor disponibilizado pelo Convenente para a conta do instrumento
);

create table pagamentos_favorecidos
(
    NR_MOV_FIN         int           null, --Número identificador da movimentação financeira
    NR_CONVENIO        bigint        null, --Número gerado pelo Siconv. Possui faixa de numeração reservada que vai de 700000 a 999999
    IDENTIF_FORNECEDOR varchar(100)   null, --CNPJ\CPF do Fornecedor
    NOME_FORNECEDOR    varchar(300)  null, --Nome do Fornecedor
    TP_MOV_FINANCEIRA  varchar(100)  null, --Tipo da movimentação financeira realizada. Domínio: Pagamento a favorecido, Pagamento a favorecido com OBTV
    DATA_PAG           date          null, --Data da realização do pagamento
    NR_DL              varchar(200)  null, --Número identificador do Documento de Liquidação
    DESC_DL            varchar(200)  null, --Descrição do Documento de Liquidação. Domínio: DIÁRIAS, DUPLICATA, FATURA, FOLHA DE PAGAMENTO, NOTA FISCAL, NOTA FISCAL / FATURA, OBTV PARA EXECUTOR, OBTV PARA O CONVENENTE, etc
    VL_PAGO            numeric(15,2) null --Valor do pagamento
);

create table OBTV_convenente
(
    NR_MOV_FIN                   bigint        null, --Número identificador da movimentação financeira
    IDENTIF_FAVORECIDO_OBTV_CONV varchar(100)   null, --CNPJ/CPF do Favorecido recebedor do pagamento
    NM_FAVORECIDO_OBTV_CONV      varchar(300)  null, --Nome do Favorecido recebedor do pagamento
    TP_AQUISICAO                 varchar(100)  null, --Tipo de Aquisição
    VL_PAGO_OBTV_CONV            numeric(15,2) null --Valor pago ao favorecido
);

create table termo_aditivo
(
    NR_CONVENIO      bigint        null, --Número gerado pelo Siconv. Possui faixa de numeração reservada que vai de 700000 a 999999
    NUMERO_TA        varchar(100)  null, --Número do Termo Aditivo
    TIPO_TA          varchar(100)  null, --Tipo do Termo Aditivo
    DT_ASSINATURA_TA date          null, --Data da assinatura do Termo Aditivo
    DT_INICIO_TA     date          null, --Data Início de Vigência do Termo Aditivo
    DT_FIM_TA        date          null, --Data Fim de Vigência do Termo Aditivo
    JUSTIFICATIVA_TA text          null  --Justificativa para a realização do Termo Aditivo
);

create table prorroga_oficio
(
    NR_CONVENIO            bigint        null, --Número gerado pelo Siconv. Possui faixa de numeração reservada que vai de 700000 a 999999
    NR_PRORROGA            varchar(100)  null, --Número do Prorroga de Ofício
    DT_INICIO_PRORROGA     date          null, --Data Início de Vigência do Prorroga de Ofício
    DIAS_PRORROGA          int           null, --Dias de prorrogação
    DT_FIM_PRORROGA        date          null, --Data Fim de Vigência do Prorroga de Ofício
    DT_ASSINATURA_PRORROGA date          null, --Data de assinatura do Prorroga de Ofício
    SIT_PRORROGA           varchar(100)  null  --Situação atual do Prorroga de Ofício. Domínio: DISPONIBILIZADA, PUBLICADA
);

create table historico_situacao_propostas
(
    ID_PROPOSTA        bigint       null, --Código Sequencial do Sistema para uma Proposta
    NR_CONVENIO        bigint       null, --Número gerado pelo Siconv. Possui faixa de numeração reservada que vai de 700000 a 999999
    DIA_HISTORICO_SIT  date         null, --Data de entrada da situação no sistema
    HISTORICO_SIT      varchar(100) null, --Situação histórica da Proposta/Convênio
    DIAS_HISTORICO_SIT int          null, --Dias em que a Proposta/Convênio permaneceu na situação
    COD_HISTORICO_SIT  int          null  --Código da situação histórica da Proposta/Convênio, contendo a ordem cronológica do ciclo de vida de um convênio
);

create table populacao_estimada
(
   uf       char(2)      not null,
   cd_uf    int          not null,
   cd_munic int          not null, 
   nm_munic varchar(100) not null,
   nr_habit int          not null
);