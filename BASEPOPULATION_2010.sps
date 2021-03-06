* Encoding: UTF-8.
*POPULA��O BASE: PROFAMY.

*PREPARA��O DA POPULA��O BASE DO ESTADO DE S�O PAULO A PARTIR DOS MICRODADOS DO CENSO 2010.  
*Microdados: DOMPES, sem peso.

*\ Deletando as vari�veis que n�o iremos utilizar.

DELETE VARIABLES
mesoreg
microreg
muniat
RM
AREAP
V4002
V0201
V2011
V2012
V0202
V0203
V6203
V0204
V6204
V0205
V0206
V0207
V0208
V0209
V0210
V0211
V0212
V0213
V0214
V0215
V0216
V0217
V0218
V0219
V0220
V0221
V0222
V0301
V0401
V0402
V0701
V6529
V6530
V6531
V6532
V6600
V6210
M0201
M2011
M0202
M0203
M0204
M0205
M0206
M0207
M0208
M0209
M0210
M0211
M0212
M0213
M0214
M0215
M0216
M0217
M0218
M0219
M0220
M0221
M0222
M0301
M0401
M0402
M0701
V0504
V6033
V6037
V6040
V0613
V0614
V0615
V0616
V0617
V0618
V0619
V0620
V0621
V0622
V6222
V6224
V0623
V0624
V0625
V6252
V6254
V6256
V0626
V6262
V6264
V6266
V0627
V0628
V0629
V0630
V0631
V0632
V0633
V0634
V0635
V6400
V6352
V6354
V6356
V0636
V6362
V6364
V6366
V0638
V0639
V0641
V0642
V0643
V0644
V0645
V6461
V6471
V0648
V0649
V0650
V0651
V6511
V6513
V6514
V0652
V6521
V6524
V6525
V6526
V6527
V6528
V0653
V0654
V0655
V0656
V0657
V0658
V0659
V6591
V0660
V6602
V6604
V6606
V0661
V0662
V0663
V6631
V6632
V0664
V6641
V6642
V6643
V0665
V6660
V6664
V0667
V0668
V6681
V6682
V0669
V6691
V6692
V6693
V6800
V0670
V0671
V6900
V6910
V6920
V6930
V6940
V6121
V0604
V0605
V5020
V5060
V5070
V5080
V6462
V6472
V5110
V5120
V5030
V5040
V5090
V5100
V5130
CHEFE
CONJ
FILENT
NETBIS
PAISOG
AVO
OUTPAR
NAOPAR
SCHEFE
SCONJ
SFILENT
SNETBIS
SPAISOG
SAVO
SOUTPAR
SNAOPAR
TIPO.

EXECUTE.

SAVE OUTFILE='C:\ProFamy\SP_SUBSP_TA_2010.SAV'
  /COMPRESSED.


*RECODIFICAR AS VARI�VEIS DO CENSO DE ACORDO COM AS CODIFICA��ES EXIGIDAS PELO PROGRAMA PROFAMY, VER ZENG ET AL(2014) PAGINA 299.

*Recodificando rela��o com o respons�vel pelo domic�lio*.
.
RECODE V0502 ('01'=1) ('02'=2) ('03'=2) ('04'=3) ('05'=3) ('06'=3) ('07'=7) ('08'=5) ('09'=5) 
    ('10'=4) ('11'=4) ('12'=7) ('13'=6) ('14'=7) ('15'=8) ('16'=8) ('17'=8) ('18'=8) ('19'=8) ('20'=1)  INTO RELACAO.
VARIABLE LABELS  RELACAO 'Relação com Responsável'.
EXECUTE.
ALTER TYPE RELACAO (A1).

* Recodificando Estado Marital (4 estados) *

STRING ESTCIVIL (A1).
RECODE V0640 ('1'='2') ('2'='4') ('3'='4') ('4'='3') (MISSING='1') (ELSE='1') INTO ESTCIVIL.
VARIABLE LABELS  ESTCIVIL 'Estado Civil'.
EXECUTE.

/* PROFAMY */
/*CRIANDO OS QUATRO ESTADOS CONJUGAIS: 
/*1- SOLTEIRO; 
/*2- CASADO;
/*3- VIUVO;
/*4- DIVORCIADO
*/

ALTER TYPE V0640 (A1).
ALTER TYPE V0637 (A1).

STRING  ECAUX (A2).
COMPUTE ECAUX=CONCAT(ESTCIVIL,V0637).
EXECUTE.

STRING ESTCONJ (A1).
RECODE ECAUX  
 ('11'='2') ('12'='4') ('13'='1') ('21'='2') ('22'='4') ('23'='4') ('31'='2') ('32'='3')
 ('33'='3') ('41'='2') ('42'='4') ('43'='4') (ELSE='1') INTO ESTCONJ.

CROSSTABS
  /TABLES=V0640 BY ESTCONJ
  /FORMAT=AVALUE TABLES
  /CELLS=COUNT
  /COUNT ROUND CELL.
EXECUTE.

*Recodificando parturicao* 

RECODE V6633 (0=0) (1=1) (2=2) (3=3) (4=4) (SYSMIS=0) (MISSING=0) (ELSE=5) INTO PART.
VARIABLE LABELS  PART 'Parturicao'.
ALTER TYPE PART (f1).
EXECUTE.

*Recodificando situa��o do domic�lio (rural e urbano)* 

RECODE V1006 ('1'=2) ('2'=1) INTO SITDOM.
VARIABLE LABELS  SITDOM 'Situacao do domicilio'.
ALTER TYPE SITDOM (A1).
EXECUTE.

*Recodificando cor/raca (branco e nao-branco)* 

STRING RACA (A1).
RECODE V0606 ('1'='1') ('3'='1') (MISSING='2') (ELSE='2') INTO RACA.
VARIABLE LABELS  RACA 'Cor/Raca'.
ALTER TYPE RACA (A1).
EXECUTE.

*sexo*
*idade
*controle*
*tipo de domicilio*

DATASET ACTIVATE DataSet7.
RECODE V4001 ('01'=1) ('02'=1) ('05'=1) ('06'=2) INTO ESPDOM.
VARIABLE LABELS  ESPDOM 'Especie do domicilio'.
ALTER TYPE ESPDOM (A1).
EXECUTE.


*A PARTIR DAQUI, TODAS AS VARIAVEIS TEM QUE SER TRANSFORMADAS EM "STRING".
*ALEM DISSO, A LARGURA DAS VARIaVEIS TAMBeM TEM QUE SER AJUSTADAS:

*RELACAO COM CHEFE DO DOMICILIO = 1
*IDADE = 3
*SEXO = 1
*ESTADO MARITAL = 1
*PARTURICAO = 2
*TIPO DE DOMICILIO = 1 
*SITUACAO DOMICILIO = 1
*RACA = 1
*NUMERO DO DOMICILIO = INFINITO

* Recodificação de parturição, COLOCANDO UM ZERO PARA O PREENCHIMENTO DE TODAS AS COLUNAS DESTA VARIÁVEL.
STRING PART2 (A2).
RECODE PART (0='00') (1='01') (2='02') (3='03') (4='04') (5='05') INTO PART2.
VARIABLE LABELS  PART2 'parturição final'.
EXECUTE.

* Recodificacao de idade COLOCANDO UM ZERO PARA O PREENCHIMENTO DE TODAS AS COLUNAS DESTA VARIaVEL..

STRING IDADE (A3).
RECODE V6036
(0='000')
(1='001')
(2='002')
(3='003')
(4='004')
(5='005')
(6='006')
(7='007')
(8='008')
(9='009')
(10='010')
(11='011')
(12='012')
(13='013')
(14='014')
(15='015')
(16='016')
(17='017')
(18='018')
(19='019')
(20='020')
(21='021')
(22='022')
(23='023')
(24='024')
(25='025')
(26='026')
(27='027')
(28='028')
(29='029')
(30='030')
(31='031')
(32='032')
(33='033')
(34='034')
(35='035')
(36='036')
(37='037')
(38='038')
(39='039')
(40='040')
(41='041')
(42='042')
(43='043')
(44='044')
(45='045')
(46='046')
(47='047')
(48='048')
(49='049')
(50='050')
(51='051')
(52='052')
(53='053')
(54='054')
(55='055')
(56='056')
(57='057')
(58='058')
(59='059')
(60='060')
(61='061')
(62='062')
(63='063')
(64='064')
(65='065')
(66='066')
(67='067')
(68='068')
(69='069')
(70='070')
(71='071')
(72='072')
(73='073')
(74='074')
(75='075')
(76='076')
(77='077')
(78='078')
(79='079')
(80='080')
(81='081')
(82='082')
(83='083')
(84='084')
(85='085')
(86='086')
(87='087')
(88='088')
(89='089')
(90='090')
(91='091')
(92='092')
(93='093')
(94='094')
(95='095')
(96='096')
(97='097')
(98='098')
(99='099')
(100 thru HIGHEST='100')
INTO IDADE.
VARIABLE LABELS  IDADE 'Idade (string 3 dig)'.
EXECUTE.

* Recodificando SEXO *.
STRING SEXO (A1).
COMPUTE SEXO=V0601.

* Adequacao da variavel 'codigo do domicilio' para as necessidades do software ProFamy.
COMPUTE V0300B=V0300.
EXECUTE.

ALTER TYPE V0300B (f0).
ALTER TYPE V0300B (A8).

STRING  Codigo (A8).
COMPUTE Codigo=LTRIM(V0300B).
EXECUTE.

*CERTIFICAR QUE O "codigo" esta sem virgula!.

* Concatenando todas as variaveis CONSIDERANDO 7 ESTADOS DE ESTADO CONJUNGAL.
STRING  ID2 (A18).
COMPUTE ID2=CONCAT(RELACAO, IDADE, SEXO, ESTCONJ, PART2, ESPDOM, SITDOM, RACA, Codigo).
EXECUTE.

*Salvando O SUBARQUIVO banco de dados em formato SPSS.
SAVE OUTFILE='C:\ProFamy\SUB_SPTA_2010.sav'.
 EXECUTE.

DELETE VARIABLES
V0300
V1006
PESODOM
V4001
PESO
V0502
V0601
V6036
V0606
V0637
V0640
V6633
RELACAO
PART
SITDOM
RACA
ESPDOM
ECAUX
ESTCONJ
IDADE
SEXO
V0300B
Codigo.

*Salvando A VARIVEL ID2 No banco de dados em formato SPSS.
SAVE OUTFILE='C:\ProFamy\SP_CODIGO2_2010.sav'.
 EXECUTE.

*salvando em .DAT.
WRITE OUTFILE='D:\Gustavo\Zjg1ZGMzMmRlOThiNGRjZD\Volume{970c5b77-5f9c-4b5d-af34-3a3b0c6b725e}\Users\Gustavo\Desktop\Doutorado\Artigos\Singapura 2022\SUDESTE_2010.dat'
  ENCODING='UTF8'
  TABLE
  /ID2 .
EXECUTE.


















