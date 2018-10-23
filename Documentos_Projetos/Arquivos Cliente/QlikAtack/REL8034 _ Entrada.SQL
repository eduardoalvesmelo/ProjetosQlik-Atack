SELECT      case 
            when c.caixa>0 and c.numcupom=c.numnota and c.chavenfe is not null then 'NFC-e'
            when c.numnota=c.numcupom and c.caixa>0 and c.chavenfe is null then 'ECF' 
            when c.serie='1' and c.caixa=0 and c.chavenfe is not null then 'NF-e'
            when c.serie='1' and c.numcupom<>c.numnota and c.caixa<>0 and c.tipovenda='V4' then 'ECF/NF-e'
            else 'ERRO' end as DocEmissao, 
       a.numnota,
       a.numtransvenda,
       c.chavenfe,
       --c.modelo,
        l.origmerctrib ||a.sittribut CST   ,
       a.codsittribpiscofins,
     
       c.especie,
       ci.uf,
       ci.nomecidade,
       a.codprod,
       b.descricao,
       b.nbm,
       b.codsec,
       NVL (a.baseicms, 0) baseicms,
       NVL (a.baseicms, 0000)  * ((NVL (a.percicm, 0000))/100) VlrICMS,
       NVL(a.codicmtab,0) icms_pis_cofins,
       a.punitcont,
       a.qtcont,
       NVL(a.qtcont,0) * NVL(a.punitcont,0) totaldev,
       NVL(a.qtcont,0) * NVL (a.st, 0) st,
       NVL (a.vlsuframa, 0) vlsuframa,
       NVL (a.vlfrete, 0) vlfrete,
       a.dtmov,
       NVL (a.percicm, 0) percicm,
       a.numtransent,
       a.codoper,
       a.codfilial,
       a.codcli,
       a.custocont,
       NVL(a.qtcont,0)* NVL(a.custocont,0) cutototal,
       a.codfiscal ,
       (a.VLPIS+a.VLCOFINS)  ,
       NVL(a.vlbasepiscofins,0) vlbasepiscofins  ,
       c.obs ,
       c.nffornec
  FROM pcmov a, pcprodut b, pcfilial f, pcnfsaid c, pccidade ci , pcmovcomple l
 WHERE (C.Numtransvenda = a.numtransvenda)
 and  a.numtransitem=l.numtransitem
   AND (a.codprod = b.codprod)
   AND (f.codigo = a.codfilial)
   AND (c.codibge=ci.codibge)
   and (c.dtsaida between :D1 and :D2)
   AND (c.CODFILIAL = :codfilial)
   and (a.codfiscal = :codfiscal)
   and (c.especie <> 'OE' )
   AND (C.SITUACAONFE <> 101) --bsilva
   AND (C.SITUACAONFE <> 102)
   --AND (c.TIPODESCARGA IN ('6','7'))
   --AND (c.CODFISCAL IN (131,132,231,232,199,299))
   AND (a.numnota = :numnota)
   AND (a.codprod = :codprod)
   and a.sittribut = :ST
   and l.origmerctrib = :OrigemTrib
   and a.percicm = :Aliq
   --and c.obs not in ('NF CANCELADA')
   ORDER BY ci.uf, ci.nomecidade, a.numnota

/*-------------------------------------------------------
CODFILIAL=Numero;Filial;;N;;
numnota=Numero;Nota;;N;;
D2=Data;Data Final;sysdate;S;;
D1=Data;Data Inicial;lastdaymonth;S;;
codprod=Numero;Produto;;N;;
codfiscal=Numero;Cod Fiscal;;N;;
-----------------------------------------------------*/

