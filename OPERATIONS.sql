-- 1/ Creazione di un Account
----------------------------- 

DROP PROCEDURE IF EXISTS NewAccount;
DELIMITER $$
CREATE PROCEDURE NewAccount (IN _nomeutente VARCHAR(50), IN _domandasicurezza VARCHAR(100), IN _risposta VARCHAR(5), 
							  IN _codfiscale VARCHAR(50), IN _nome VARCHAR(50), IN _cognome VARCHAR(50), IN _telefono VARCHAR(30),
                              IN _numdocumento varchar(50), IN _tipologia VARCHAR(50), IN _datascadenza DATE, IN _enterilascio VARCHAR(50))
BEGIN
	-- chaeck scadenza
	IF 
		(_datascadenza < CURRENT_DATE())
    THEN 
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'documento scaduto !';
		
    ELSE
        
        INSERT INTO Abitante (CodFiscale, Nome, Cognome, Scadenza, NumDoc, EnteRilascio, Telefono, TipoDoc)
		VALUES	(_codfiscale, _nome, _cognome, _datascadenza, _numdocumento, _enterilascio, _telefono, _tipologia);
        
        INSERT INTO User (UserName)
		VALUES  (_nomeutente);
        
        INSERT INTO Registrazione (abitante, user, DataRegistrazione)
		VALUES  (_codfiscale, _nomeutente, current_date());
        
	END IF;
END $$
DELIMITER ;

 CALL NewAccount ('user4', 'sei studente ?', 'si', 'VRSLSN21T28A390D', 'tom', 'de paul', 
 					 '3925804720', '58129', 'patente', '2026-05-12', 'stato italiano');





-- 2/ 2)	un’abitante imposta una partenza differita con un programma 

-- 3/ 3)	consumo totale di un dispositivo di tipo potenza regolabile

-- 4/ 4)	controllo dello stato del condizionatore in una stanza

-- 5/ 5)	trovare i dispositivi più usati in ciascuna stanza





-- 6/ 6)	dato un utente ('codfiscale'); elencare i condizionatori soggetti di un’impostazione ricorrente, da lui e in che stanza si trovano
-- ----------------------------------------------------------------------------------------------------------------------------
select RSC.ElemAria, P.stanza 
from RecurrentSettingCond RSC inner join Registrazione R on R.user = RSC.user 
							  inner join abitante A on A.CodFiscale = R.abitante
                              inner join presenza2 P on P.ElementoAria = RSC.ElemAria
where A.CodFiscale = 'codfiscale'







-- /7 7)	inserire un nuovo dispositivo in una stanza, e collegarlo ad una SmartPlug
-- ----------------------------------------------------------------------------------
drop procedure if exists NewDevice;
delimiter $$
create procedure NewDevice(in _nomedevice varchar(50), _tipodevice varchar(50), in _tipoUso varchar(5), in _PotenzaMax int, in _PotenzaMin int,
							in _smartplug varchar(50))
begin

	insert into dispositivo (IDdispositivo, Tipo, UsoSingolo, PotenzaMax, PotenzaMin)
    values (_nomedevice, _tipodevice, _tipoUso, _PotenzaMax, _PotenzaMin);
    
    insert into SmartPlug (CodiceSmartplug)
    values (_smartplug);
    
    insert into collegamento
    values (_smartplug, _nomedevice);

end $$
delimiter ;






-- /8 8)	trovare gli elementi di luce che sono più usati in ogni stanza