SELECT c.chavenfe,
       a.numnota,
        l.origmerctrib || a.sittribut AS CODCST,
       a.codsittribpiscofins,
       fn.codfornec,
       fn.fornecedor,
       fn.cgc cnpj,
     --l.origmerctrib,
      -- l.ORIGMERCTRIB||a.SITTRIBUT AS COD_CST
      -- fn.codfornec,
      -- fn.fornecedor,
       c.dtent,
       c.modelo,
       c.especie,
       ci.uf,
       ci.nomecidade,
       a.codprod,
       b.descricao,
       b.codfab,
       b.nbm,
       b.codsec,
       NVL (a.baseicms, 0) baseicms,
       NVL (a.baseicms, 0000)  * ((NVL (a.percicm, 0000))/100) VlrICMS,
       NVL(a.codicmtab,0) icms_pis_cofins,
       a.punitcont,
       a.qtcont,
       NVL(a.qtcont,0) * NVL(a.punitcont,0) totaldev,
       NVL (a.st, 0) st,
       NVL (a.vlsuframa, 0) vlsuframa,
       NVL (a.vlfrete, 0) vlfrete,
       a.dtmov,
       c.dtselofiscal,
       NVL (a.percicm, 0) percicm,
       a.numtransent,
       a.codoper,
       a.codfilial,
       a.codcli,
       a.custocont,
       NVL(a.qtcont,0)* NVL(a.custocont,0) cutototal,
       a.codfiscal,
       (a.vlcredpis+a.vlcredcofins),
       a.vlbasepiscofins,
       a.percfretefob,
       a.vlfreteconhec,
      -- ((a.punitcont-a.vldesconto)*a.qtcont) valorcont, 
       --((a.punitcont-a.vldesconto)+(a.punit-a.punitcont))*a.qtcont valorcont2, 
       (a.punit*a.qtcont) as valorcont ,
       a.percdespforanf,
       a.vldespforanf,
       c.numnotavenda,
       c.dtemissaonfvenda,
       a.vldescsuframa  ,
              --st retido na fonte
       (a.PERCST) percst,
       ((((ptabela - (ptabela * a.percdesc / 100)) - ((ptabela - (ptabela * a.percdesc / 100)) * a.PERCSUFRAMA / 100)) * a.PERCST / 100) * NVL(a.QT, 0)) VLSTFONTE,
       
       --st fora da nota
       (a.PERCDESPADICIONAL) stforadanota,
       ((((ptabela - (ptabela * a.percdesc / 100)) - ((ptabela - (ptabela * a.percdesc / 100)) * a.PERCSUFRAMA / 100)) * a.PERCDESPADICIONAL / 100) * NVL(a.QT, 0)) VLSTFN
       
       
       
       
       
  FROM pcmov a, pcprodut b, pcfilial f, pcnfent c, pccidade ci , pcmovcomple l, pcfornec fn
 WHERE (C.NUMTRANSENT = A.NUMTRANSENT)
   AND (a.codprod = b.codprod) and a.codfornec=fn.codfornec
   AND (f.codigo = a.codfilial)
   AND (c.codibge=ci.codibge)
     and a.NUMTRANSITEM = l.NUMTRANSITEM 
   --and (b.codsecao in (:codsec))
   and (c.dtent between :D1 and :D2)
   AND (c.CODFILIAL = :codfilial)
   and (a.codfiscal = :codfiscal)
   and b.nbm=:NCM
   AND (c.CODCONT <> 100002)
   AND (c.CODCONT <> 100003)
   and c.especie <> 'OE'
  -- AND (c.TIPODESCARGA IN ('6','7','8'))
   --AND (c.CODFISCAL IN (131,132,231,232,199,299))
   AND (a.numnota = :numnota)
   AND (a.codprod = :codprod)
   AND  a.percicm = :Aliq
   and  a.sittribut = :CST
   and  l.origmerctrib = :OrigemTriib
  
   ORDER BY ci.uf, ci.nomecidade, a.numnota
