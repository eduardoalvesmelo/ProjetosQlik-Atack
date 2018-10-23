SELECT      
Sum(NVL(BS.VLDESDOBRADO,0)) VLDESDOBRADO,
       Sum(NVL(BS.VLISENTAS,0)) VLISENTAS,
       Sum(NVL(BS.VLBASE,0)) VLBASE,
       Sum(NVL(BS.VLBASE_REDUCAO,0)) VLBASE_REDUCAO,
       Sum(NVL(BS.VLICMS,0)) VLICMS,
       Sum(NVL(BS.VLOUTRAS,0)) VLOUTRAS,
       Sum(NVL(BS.VLBASEIPI,0)) VLBASEIPI,
       Sum(NVL(BS.VLIPI,0)) VLIPI,
       Sum(NVL(BS.BASEST,0)) VLBASEST,
       Sum(NVL(BS.VLST,0)) VLST,
       BS.CODFISCAL,
       BS.SITTRIBUT,
       :CODFILIAL FILIAL,
       :DTINI DTINI,
       :DTFIM DTFIM,
       
       PCCFO.DESCCFO,
       NVL(BS.PERCICM,0) PERCICM,
       DECODE(SUBSTR(BS.CODFISCAL,1,1),'5','5.000 - SAÍDAS E/OU PRESTAÇÕES DO ESTADO',
                                    '6','6.000 - SAÍDAS E/OU PRESTAÇÕES PARA FORA DO ESTADO',
                                    '7','7.000 - SAÍDAS E/OU PRESTAÇÕES PARA O EXTERIOR') GRUPOCODFISCAL
FROM PCNFBASESAID BS,PCCFO, PCNFSAID
WHERE BS.DTSAIDA BETWEEN :DTINI AND :DTFIM
  AND BS.NUMTRANSVENDA = PCNFSAID.NUMTRANSVENDA(+)
  AND BS.CODFISCAL = PCCFO.CODFISCAL 
  AND BS.CODFILIALNF = :CODFILIAL
  AND BS.CODFISCAL BETWEEN 5000 AND 7999
  AND BS.VLDESDOBRADO >= 0
  AND PCNFSAID.DTCANCEL IS NULL
  AND BS.ESPECIE <> 'MR'
  AND (NVL(BS.SERIE, 'X') NOT IN ('CF', 'CP') OR PCNFSAID.CHAVENFE IS NOT NULL) 
  AND (('T' = 'T') OR
       ('T' = 'S' AND EXISTS(SELECT B.CODPROD
                                      FROM PCMOV B
                                      WHERE B.NUMNOTA = BS.NUMNOTA
                                      AND B.NUMTRANSVENDA = BS.NUMTRANSVENDA
                                           AND NVL(B.FUNDAPIANO,'N') = 'S' )) OR
       ('T' = 'N' AND (EXISTS(SELECT B.CODPROD
                                      FROM PCMOV B
                                      WHERE B.NUMNOTA = BS.NUMNOTA
                                      AND B.NUMTRANSVENDA = BS.NUMTRANSVENDA
                                      AND NVL(B.FUNDAPIANO,'N') = 'N' ) OR
                               (NOT EXISTS(SELECT B.CODPROD
                                           FROM PCMOV B
                                           WHERE B.NUMNOTA = BS.NUMNOTA
                                           AND B.NUMTRANSVENDA = BS.NUMTRANSVENDA))))) 
GROUP BY BS.CODFISCAL,   PCCFO.DESCCFO, BS.PERCICM,   BS.SITTRIBUT
ORDER BY BS.CODFISCAL, BS.PERCICM 



/*SELECT
       E.CODFISCAL,
       E.SITTRIBUT,
       SUM(NVL(E.VLDESDOBRADO,0)) VLDESDOBRADO,
       SUM(NVL(E.VLISENTAS,0))VLISENTAS,
       SUM(NVL(E.VLBASE,0)) VLBASE,
       SUM(NVL(E.VLICMS,0)) VLICMS,
       SUM(NVL(E.VLOUTRAS,0)) VLOUTRAS,  
       SUM(NVL(E.VLIPI,0)) VLIPI,
       SUM(NVL(E.VLOUTRASIPI,0)) VLOUTRASIPI,
       SUM(NVL(E.VLISENTASIPI,0)) VLISENTASIPI,
       E.PERCICM AS ALIQICMS,
       C.DESCCFO,
       :CODFILIAL FILIAL,
       :DTINI DTINI,
       :DTFIM DTFIM
       
       --DECODE(SUBSTR(E.CODFISCAL,1,1),'1','1.000 - ENTRADAS E/OU PRESTAÇÕES DE SERVIÇO DO ESTADO',
         --                             '2','2.000 - ENTRADAS E/OU PRESTAÇÕES DE SERVIÇO FORA DO ESTADO',
           --                           '3','3.000 - ENTRADAS E/OU PRESTAÇÕES DE SERVIÇO DO EXTERIOR') GRUPOCODFISCAL
FROM PCNFBASESAID E,
     PCCFO C
WHERE (E.DTSAIDA  BETWEEN :DTINI AND  :DTFIM ) 
  AND (E.CODFILIALNF = :CODFILIAL )
  AND E.CODFISCAL = C.CODFISCAL
  AND (('T' = 'T') OR
       ('T' = 'S' AND EXISTS(SELECT B.CODPROD
                                      FROM PCMOV B
                                      WHERE B.NUMNOTA = E.NUMNOTA
                                      AND B.numtransvenda = E.numtransvenda
                                           AND NVL(B.FUNDAPIANO,'N') = 'S' )) OR
       ('T' = 'N' AND (EXISTS(SELECT B.CODPROD
                                      FROM PCMOV B
                                      WHERE B.NUMNOTA = E.NUMNOTA
                                      AND B.NUMTRANSVENDA = E.NUMTRANSVENDA
                                      AND NVL(B.FUNDAPIANO,'N') = 'N' ) 
                           OR (NOT EXISTS(SELECT B.CODPROD
                                      FROM PCMOV B
                                      WHERE B.NUMNOTA = E.NUMNOTA
                                      AND B.NUMTRANSVENDA = E.NUMTRANSVENDA))))) 
GROUP BY E.CODFISCAL, C.DESCCFO, E.PERCICM, E.Sittribut
ORDER BY CODFISCAL, PERCICM
*/      