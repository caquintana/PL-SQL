CREATE OR REPLACE PACKAGE BODY PLA01.PKG_SIMA_PERSONAL AS

FUNCTION VeficaPersonalExiste(pCODCIA PLNMAETRA.PTRCODCIA%TYPE,pCODSUC PLNMAETRA.PTRCODSUC%TYPE,pNroDni PLNMAETRA.PTRNROLE%TYPE)RETURN VARCHAR2
    IS
        pValorTrab VARCHAR2(8) ;
        pValor  NUMBER ;
        pCodTraB VARCHAR2(8) ;
 
 BEGIN
        
           SELECT COUNT(*) INTO pValor
              FROM PLNMAETRA 
              WHERE PTRCODCIA=pCODCIA
               AND  PTRCODSUC=pCODSUC
               AND  PTRNROLE = pNroDni;
              
              IF pValor  = 1 THEN
              
                    SELECT PTRCODTRA INTO pValorTrab
                          FROM PLNMAETRA 
                          WHERE PTRCODCIA=pCODCIA
                           AND  PTRCODSUC=pCODSUC
                           AND  PTRNROLE = pNroDni;
                pCodTraB := pValorTrab;
              ELSE
                pCodTraB := '0';
              END IF;
    
    RETURN pCodTraB;
 END;
 
FUNCTION InsertaPersonal(pCODCIA VARCHAR2,pCODSUC VARCHAR2,pCODTRA VARCHAR2,pCODTIP VARCHAR2,pTRANOM VARCHAR2,pTRAAPP VARCHAR2,pTRAAPM VARCHAR2,pESTCIV VARCHAR2,
                         pFECINI VARCHAR2,pFECNAC VARCHAR2,pGRAINS VARCHAR2,pCODSEX VARCHAR2,pDIRTRA VARCHAR2, pNROLE VARCHAR2,pNROLM  VARCHAR2,pNRORUC VARCHAR2,
                         pNROSSP VARCHAR2,pNROAFP VARCHAR2,pCODAFP VARCHAR2,pFECING VARCHAR2,pFECRET VARCHAR2,pFLGEST VARCHAR2,pCODNAC VARCHAR2,pTIPREM VARCHAR2,pTIPCON VARCHAR2,
                         pCENCOS VARCHAR2,pCODSEC VARCHAR2,pPUESTO VARCHAR2,pCODGEN VARCHAR2,pBCOCTS VARCHAR2,pMONCTS VARCHAR2,pCODCTA VARCHAR2,pTIPCTA VARCHAR2,pFLGMAR VARCHAR2,
                         pMONPAG VARCHAR2,pBCODEP VARCHAR2,pUBICOD VARCHAR2,pCODANT VARCHAR2,pTIPDOC VARCHAR2,pNUMTEL VARCHAR2,pTIPVIA VARCHAR2,pTIPZON VARCHAR2,pNOMVIA VARCHAR2,
                         pUBIDIS VARCHAR2,pUBIPRV VARCHAR2,pUBIDEP VARCHAR2,pCTACTS VARCHAR2,pMONDEP VARCHAR2,pFLGDOM VARCHAR2,pSENATI VARCHAR2,pCODPUE VARCHAR2,pFINCON VARCHAR2,
                         pSITTRA VARCHAR2,pFLGDIS VARCHAR2,pEMAIL VARCHAR2, pNUMCEL VARCHAR2,pMAILCO VARCHAR2,pUSRRED VARCHAR2) RETURN VARCHAR2
                        
 IS
    oPLNMAETRA PLNMAETRA%ROWTYPE;
    pRst NUMBER :=0;
    pRstCodTrab VARCHAR2(8);
    pExisteTrab VARCHAR2(8);
    
    FUNCTION fnObtieneCodTrabajador RETURN NUMBER
    IS 
        TmpVar NUMBER;
        /*Function que obtiene el codigo de trabajador para el maestro de trabajadores PLNMAETRA  */
    BEGIN 
        
           SELECT NVL(MAX(NVL(PTRCODTRA,0)),0)+1
            INTO tmpVar
            FROM PLNMAETRA;
            
            RETURN TmpVar;

    END fnObtieneCodTrabajador;
FUNCTION fnCargaRowTrab(pCODCIA PLNMAETRA.PTRCODCIA%TYPE,pCODSUC PLNMAETRA.PTRCODSUC%TYPE,pNroDni PLNMAETRA.PTRNROLE%TYPE)RETURN  PLNMAETRA%ROWTYPE
    IS
        pValorTrab VARCHAR2(8) ;
        pValor  NUMBER ;
        pCodTraB VARCHAR2(8) ;
        oPLNMAETRA PLNMAETRA%ROWTYPE;
 
 BEGIN
        
           SELECT * INTO oPLNMAETRA 
                FROM PLNMAETRA
                WHERE PTRCODCIA=pCODCIA
                AND  PTRCODSUC=pCODSUC
                AND  PTRNROLE = pNroDni;
    
    RETURN oPLNMAETRA;
    
 END fnCargaRowTrab;   
    
    
    FUNCTION fnValidaDatosChar(pVariable VARCHAR2, pDato VARCHAR2)RETURN VARCHAR2
    IS 
        pValor NUMBER;
        pValorLeng NUMBER;
        pValorDato VARCHAR2(500);
    BEGIN
        SELECT DATA_LENGTH INTO pValor
        FROM ALL_TAB_COLUMNS 
            WHERE TABLE_NAME= 'PLNMAETRA'
                  AND OWNER ='PLA01' 
                  AND COLUMN_NAME = pVariable;
        
        IF pValor >= NVL(LENGTH(TRIM(pDato)),0) THEN  
            pValorDato := TRIM(pDato);
                RETURN pValorDato;
           ELSE 
            --pValorDato := '0';
            RAISE_APPLICATION_ERROR(-20209, 'El valor ingresado: '||TRIM(pDato)||' no cumple en el campo establecido: '||pVariable);
        END IF;
        
--        IF pValorDato ='0' THEN
--            RAISE_APPLICATION_ERROR(-20209, 'El valor ingresado: '||TRIM(pDato)||' no cumple en el campo establecido: '||pVariable);
--        ELSE 
--         RETURN pValorDato;
        --END IF;     
    END;
  FUNCTION fnValidaDatosNumber(pVariable VARCHAR2, pDato VARCHAR2)RETURN NUMBER
    IS 
        pValor NUMBER;
        pValorLeng NUMBER;
        pValorDato NUMBER;
    BEGIN
        SELECT DATA_LENGTH INTO pValor
        FROM ALL_TAB_COLUMNS 
            WHERE TABLE_NAME= 'PLNMAETRA'
                  AND OWNER ='PLA01' 
                  AND COLUMN_NAME = pVariable;
        
        IF pValor >= NVL(LENGTH(TRIM(pDato)),0) THEN  
            pValorDato := TO_NUMBER(TRIM(pDato));
           ELSE 
            pValorDato := 0;
        END IF;
        
        IF pValorDato =0 THEN
            RAISE_APPLICATION_ERROR(-20209, 'El valor ingresado: '||TRIM(pDato)||' no cumple en el campo establecido: '||pVariable);
        ELSE 
         RETURN pValorDato;
        END IF;     
    END;
    


 BEGIN
        pExisteTrab := PKG_SIMA_PERSONAL.VeficaPersonalExiste(pCODCIA,pCODSUC,pNROLE);
        
          IF pExisteTrab = '0' THEN       
        
 
            oPLNMAETRA.PTRCODCIA :=fnValidaDatosChar('PTRCODCIA', pCODCIA);
            oPLNMAETRA.PTRCODSUC :=fnValidaDatosChar('PTRCODSUC', pCODSUC);
            oPLNMAETRA.PTRCODTRA :=fnObtieneCodTrabajador;
            oPLNMAETRA.PTRCODTIP :=fnValidaDatosNumber('PTRCODTIP', pCODTIP);
            oPLNMAETRA.PTRTRANOM :=fnValidaDatosChar('PTRTRANOM', pTRANOM);
            oPLNMAETRA.PTRTRAAPP :=fnValidaDatosChar('PTRTRAAPP', pTRAAPP);
            oPLNMAETRA.PTRTRAAPM :=fnValidaDatosChar('PTRTRAAPM', pTRAAPM);
            oPLNMAETRA.PTRESTCIV :=fnValidaDatosNumber('PTRESTCIV', pESTCIV);
            oPLNMAETRA.PTRFECINI :=TO_DATE(SUBSTR(TO_CHAR(pFECINI),1,10),'DD/MM/YYYY');
            oPLNMAETRA.PTRFECNAC :=TO_DATE(SUBSTR(TO_CHAR(pFECNAC),1,10),'DD/MM/YYYY');
            oPLNMAETRA.PTRGRAINS :=fnValidaDatosNumber('PTRGRAINS', pGRAINS);
            oPLNMAETRA.PTRCODSEX :=fnValidaDatosChar('PTRCODSEX', pCODSEX);
            oPLNMAETRA.PTRDIRTRA :=fnValidaDatosChar('PTRDIRTRA', pDIRTRA);
            oPLNMAETRA.PTRNROLE  :=fnValidaDatosChar('PTRNROLE', pNROLE);
            oPLNMAETRA.PTRNROLM  :=fnValidaDatosChar('PTRNROLM', pNROLM);
            oPLNMAETRA.PTRNRORUC :=fnValidaDatosChar('PTRNRORUC', pNRORUC);
            oPLNMAETRA.PTRNROSSP :=fnValidaDatosChar('PTRNROSSP', pNROSSP);
            oPLNMAETRA.PTRNROAFP :=fnValidaDatosChar('PTRNROAFP', pNROAFP);
            oPLNMAETRA.PTRCODAFP :=fnValidaDatosNumber('PTRCODAFP', pCODAFP);
            oPLNMAETRA.PTRFECING :=TO_DATE(SUBSTR(TO_CHAR(pFECING),1,10),'DD/MM/YYYY');
            oPLNMAETRA.PTRFECRET :=TO_DATE(SUBSTR(TO_CHAR(pFECRET),1,10),'DD/MM/YYYY');
            oPLNMAETRA.PTRFLGEST :=fnValidaDatosChar('PTRFLGEST', pFLGEST);
            oPLNMAETRA.PTRCODNAC :=fnValidaDatosNumber('PTRCODNAC', pCODNAC);
            oPLNMAETRA.PTRTIPREM :=fnValidaDatosNumber('PTRTIPREM', pTIPREM);
            oPLNMAETRA.PTRTIPCON :=fnValidaDatosNumber('PTRTIPCON', pTIPCON);
            oPLNMAETRA.PTRCENCOS :=fnValidaDatosChar('PTRCENCOS', pCENCOS);
            oPLNMAETRA.PTRCODSEC :=fnValidaDatosNumber('PTRCODSEC', pCODSEC);
            oPLNMAETRA.PTRPUESTO :=fnValidaDatosChar('PTRPUESTO', pPUESTO);
            oPLNMAETRA.PTRCODGEN :=fnValidaDatosChar('PTRCODGEN', pCODGEN);
            oPLNMAETRA.PTRBCOCTS :=fnValidaDatosNumber('PTRBCOCTS', pBCOCTS);
            oPLNMAETRA.PTRMONCTS :=fnValidaDatosChar('PTRMONCTS', pMONCTS);
            oPLNMAETRA.PTRCODCTA :=fnValidaDatosChar('PTRCODCTA', pCODCTA);
            oPLNMAETRA.PTRTIPCTA :=fnValidaDatosNumber('PTRTIPCTA', pTIPCTA);
            oPLNMAETRA.PTRFLGMAR :=fnValidaDatosChar('PTRFLGMAR', pFLGMAR);
            oPLNMAETRA.PTRMONPAG :=fnValidaDatosChar('PTRMONPAG', pMONPAG);
            oPLNMAETRA.PTRBCODEP :=fnValidaDatosNumber('PTRBCODEP', pBCODEP);
            oPLNMAETRA.PTRUBICOD :=fnValidaDatosChar('PTRUBICOD', pUBICOD);
            oPLNMAETRA.PTRCODANT :=fnValidaDatosChar('PTRCODANT', pCODANT);
            oPLNMAETRA.PTRTIPDOC :=fnValidaDatosChar('PTRTIPDOC', pTIPDOC);
            oPLNMAETRA.PTRNUMTEL :=fnValidaDatosChar('PTRNUMTEL', pNUMTEL);
            oPLNMAETRA.PTRTIPVIA :=fnValidaDatosChar('PTRTIPVIA', pTIPVIA);
            oPLNMAETRA.PTRTIPZON :=fnValidaDatosChar('PTRTIPZON', pTIPZON);
            oPLNMAETRA.PTRNOMVIA :=fnValidaDatosChar('PTRNOMVIA', pNOMVIA);
            oPLNMAETRA.PTRUBIDIS :=fnValidaDatosChar('PTRUBIDIS', pUBIDIS);
            oPLNMAETRA.PTRUBIPRV :=fnValidaDatosChar('PTRUBIPRV', pUBIPRV);
            oPLNMAETRA.PTRUBIDEP :=fnValidaDatosChar('PTRUBIDEP', pUBIDEP);
            oPLNMAETRA.PTRCTACTS :=fnValidaDatosChar('PTRCTACTS', pCTACTS);
            oPLNMAETRA.PTRMONDEP :=fnValidaDatosChar('PTRMONDEP', pMONDEP);
            oPLNMAETRA.PTRFLGDOM :=fnValidaDatosChar('PTRFLGDOM', pFLGDOM);
            oPLNMAETRA.PTRSENATI :=fnValidaDatosChar('PTRSENATI', pSENATI);
            oPLNMAETRA.PTRCODPUE :=fnValidaDatosChar('PTRCODPUE', pCODPUE);
            oPLNMAETRA.PTRFINCON :=TO_DATE(SUBSTR(TO_CHAR(pFINCON),1,10),'DD/MM/YYYY');
            oPLNMAETRA.PTRSITTRA :=fnValidaDatosChar('PTRSITTRA', pSITTRA);
            oPLNMAETRA.PTRFLGDIS :=fnValidaDatosChar('PTRFLGDIS', pFLGDIS);
            oPLNMAETRA.PTREMAIL  :=fnValidaDatosChar('PTREMAIL', pEMAIL);
            oPLNMAETRA.PTRNUMCEL :=fnValidaDatosChar('PTRNUMCEL', pNUMCEL);
            oPLNMAETRA.PTRMAILCOR :=fnValidaDatosChar('PTRMAILCOR', pMAILCO);
            oPLNMAETRA.PTRUSRRED :=fnValidaDatosChar('PTRUSRRED', pUSRRED);
            
                   
            PKG_SIMA_PERSONAL.spInsertaPersonal(oPLNMAETRA,pRst);
            
            IF pRst > 0 THEN
            
                 pRstCodTrab := oPLNMAETRA.PTRCODTRA;
            
              ELSE
                
                pRstCodTrab := '0';
            
            END IF;
            
           RETURN pRstCodTrab;
           
         ELSE 
          
            oPLNMAETRA := fnCargaRowTrab(pCODCIA,pCODSUC,pNROLE);
            oPLNMAETRA.PTRCODTIP :=fnValidaDatosNumber('PTRCODTIP', pCODTIP);
            oPLNMAETRA.PTRESTCIV :=fnValidaDatosNumber('PTRESTCIV', pESTCIV);
            oPLNMAETRA.PTRGRAINS :=fnValidaDatosNumber('PTRGRAINS', pGRAINS);
            oPLNMAETRA.PTRDIRTRA :=fnValidaDatosChar('PTRDIRTRA', pDIRTRA);
            oPLNMAETRA.PTRNROAFP :=fnValidaDatosChar('PTRNROAFP', pNROAFP);
            oPLNMAETRA.PTRCODAFP :=fnValidaDatosNumber('PTRCODAFP', pCODAFP);
            oPLNMAETRA.PTRFECING :=TO_DATE(SUBSTR(TO_CHAR(pFECING),1,10),'DD/MM/YYYY');
            oPLNMAETRA.PTRFECRET :=TO_DATE(SUBSTR(TO_CHAR(pFECRET),1,10),'DD/MM/YYYY');
            oPLNMAETRA.PTRFLGEST :=fnValidaDatosChar('PTRFLGEST', pFLGEST);
            oPLNMAETRA.PTRTIPCON :=fnValidaDatosNumber('PTRTIPCON', pTIPCON);
            oPLNMAETRA.PTRCENCOS :=fnValidaDatosChar('PTRCENCOS', pCENCOS);
            oPLNMAETRA.PTRPUESTO :=fnValidaDatosChar('PTRPUESTO', pPUESTO);
            oPLNMAETRA.PTRCODGEN :=fnValidaDatosChar('PTRCODGEN', pCODGEN);
            oPLNMAETRA.PTRBCOCTS :=fnValidaDatosNumber('PTRBCOCTS', pBCOCTS);
            oPLNMAETRA.PTRMONCTS :=fnValidaDatosChar('PTRMONCTS', pMONCTS);
            oPLNMAETRA.PTRCODCTA :=fnValidaDatosChar('PTRCODCTA', pCODCTA);
            oPLNMAETRA.PTRTIPCTA :=fnValidaDatosNumber('PTRTIPCTA', pTIPCTA);
            oPLNMAETRA.PTRFLGMAR :=fnValidaDatosChar('PTRFLGMAR', pFLGMAR);
            oPLNMAETRA.PTRMONPAG :=fnValidaDatosChar('PTRMONPAG', pMONPAG);
            oPLNMAETRA.PTRBCODEP :=fnValidaDatosNumber('PTRBCODEP', pBCODEP);
            oPLNMAETRA.PTRUBICOD :=fnValidaDatosChar('PTRUBICOD', pUBICOD);
            oPLNMAETRA.PTRNUMTEL :=fnValidaDatosChar('PTRNUMTEL', pNUMTEL);
            oPLNMAETRA.PTRTIPVIA :=fnValidaDatosChar('PTRTIPVIA', pTIPVIA);
            oPLNMAETRA.PTRTIPZON :=fnValidaDatosChar('PTRTIPZON', pTIPZON);
            oPLNMAETRA.PTRNOMVIA :=fnValidaDatosChar('PTRNOMVIA', pNOMVIA);
            oPLNMAETRA.PTRUBIDIS :=fnValidaDatosChar('PTRUBIDIS', pUBIDIS);
            oPLNMAETRA.PTRUBIPRV :=fnValidaDatosChar('PTRUBIPRV', pUBIPRV);
            oPLNMAETRA.PTRUBIDEP :=fnValidaDatosChar('PTRUBIDEP', pUBIDEP);
            oPLNMAETRA.PTRCTACTS :=fnValidaDatosChar('PTRCTACTS', pCTACTS);
            oPLNMAETRA.PTRMONDEP :=fnValidaDatosChar('PTRMONDEP', pMONDEP);
            oPLNMAETRA.PTRFLGDOM :=fnValidaDatosChar('PTRFLGDOM', pFLGDOM);
            oPLNMAETRA.PTRSENATI :=fnValidaDatosChar('PTRSENATI', pSENATI);
            oPLNMAETRA.PTRCODPUE :=fnValidaDatosChar('PTRCODPUE', pCODPUE);
            oPLNMAETRA.PTRFINCON :=TO_DATE(SUBSTR(TO_CHAR(pFINCON),1,10),'DD/MM/YYYY');
            oPLNMAETRA.PTRSITTRA :=fnValidaDatosChar('PTRSITTRA', pSITTRA);
            oPLNMAETRA.PTRFLGDIS :=fnValidaDatosChar('PTRFLGDIS', pFLGDIS);
            oPLNMAETRA.PTREMAIL  :=fnValidaDatosChar('PTREMAIL', pEMAIL);
            oPLNMAETRA.PTRNUMCEL :=fnValidaDatosChar('PTRNUMCEL', pNUMCEL);
            oPLNMAETRA.PTRMAILCOR:=fnValidaDatosChar('PTRMAILCOR', pMAILCO);
            oPLNMAETRA.PTRUSRRED :=fnValidaDatosChar('PTRUSRRED', pUSRRED);

          
          PKG_SIMA_PERSONAL.spActualizaPersonal(oPLNMAETRA,pRst);
            
            IF pRst > 0 THEN
                 
                 pRstCodTrab := pExisteTrab;
            
              ELSE
                
                pRstCodTrab := '0';
            
            END IF;
            
           RETURN pRstCodTrab;
       
       END IF;
    EXCEPTION

    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE ( 'ERROR : ' || SQLERRM );
   END;
 
PROCEDURE spInsertaPersonal ( stPLNMAETRA PLNMAETRA%ROWTYPE, pCantInsert  OUT NUMBER)
IS

BEGIN

        INSERT INTO PLNMAETRA VALUES  stPLNMAETRA;   
         IF SQL%ROWCOUNT > 0 THEN
                  pCantInsert := SQL%ROWCOUNT;
                  commit;
          ELSE
                
               pCantInsert :=0;  
         END IF;
             
               
END spInsertaPersonal;

PROCEDURE spActualizaPersonal ( stPLNMAETRA PLNMAETRA%ROWTYPE, pCantAct  OUT NUMBER)
IS

BEGIN

        UPDATE PLNMAETRA
            SET ROW = stPLNMAETRA
            WHERE PTRCODCIA  = stPLNMAETRA.PTRCODCIA 
                  AND PTRCODSUC  = stPLNMAETRA.PTRCODSUC
                  AND (PTRCODTRA  = stPLNMAETRA.PTRCODTRA OR PTRNROLE  = stPLNMAETRA.PTRNROLE);
                 IF SQL%ROWCOUNT > 0 THEN
                       pCantAct := SQL%ROWCOUNT;
                       commit;
                  ELSE
                        
                       pCantAct :=0;  
                 END IF;
             
               
END spActualizaPersonal;
 
END;
/