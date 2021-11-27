

SET FOREIGN_KEY_CHECKS = 0;
drop database if exists SmartHome;
create database SmartHome;

use SmartHome;


-- ABITANTE --
--------------
drop table if exists Abitante;
create table Abitante 
(
    CodFiscale VARCHAR(50) NOT NULL,
    Nome VARCHAR(50) NOT NULL, 
    Cognome VARCHAR(50) NOT NULL, 
    Scadenza DATE NOT NULL, 
    NumDoc VARCHAR(50) NOT NULL, 
    EnteRilascio VARCHAR(70) NOT NULL, 
    Telefono VARCHAR(10) default NULL,
    TipoDoc VARCHAR(50) NOT NULL,
    
    primary key (CodFiscale)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;



-- USER --
----------
drop table if exists User;
create table User 
(
    UserName varchar(10) not null,
    
    primary key (UserName)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;



-- registrazione --
-------------------
drop table if exists Registrazione;
create table Registrazione 
(
	abitante VARCHAR(50) NOT NULL,
    user VARCHAR(50) NOT NULL,
    DataRegistrazione date not null,
    
    primary key (abitante, user),
    foreign key (abitante) references Abitante(CodFiscale),
    foreign key (user) references User(UserName)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;



-- domande --
-------------
drop table if exists Domande;
create table Domande 
(
	IDdomanda VARCHAR(10) NOT NULL,
    DettagliDomanda VARCHAR(50) NOT NULL, 
    
    primary key (IDdomanda)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;



-- recupero --
--------------
drop table if exists Recupero;
create table Recupero 
(
	domanda VARCHAR(10) NOT NULL,
    user VARCHAR(10) NOT NULL,
    risposta varchar(10) not null
		check(risposta in ('si', 'no')),
    
    primary key (domanda, user),
    foreign key (domanda) references Domande(IDdomanda),
    foreign key (user) references User(UserName)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;



-- stanza --
-- ----------
drop table if exists Stanza;
create table Stanza 
(
	IDstanza VARCHAR(50) NOT NULL,
    piano int(5) not null,
			-- check(piano >=0),
    altezza double not null,
    larghezza double not null,
    lunghezza double not null,
    EnergiaPerGrado double default null,
    SensoreInterno double default null,
    SensoreExterno double default null,
    primary key (IDstanza)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;



-- puntiAccesso --
-- ----------------
drop table if exists PuntiAccesso;
create table PuntiAccesso 
(
	NomeElemento VARCHAR(30) NOT NULL
		check(NomeElemento in ('finestra', 'porta', 'portafinestra')),
	
    
	primary key (NomeElemento)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;




-- composizione -- 
------------------
drop table if exists Composizione;
create table Composizione 
(
	nome VARCHAR(30) NOT NULL,
    stanza VARCHAR(50) NOT NULL,
    Orientazione varchar(10) not null
		check(Orientazione in ('N', 'NE', 'NW', 'S', 'SE', 'SW', 'E', 'W')),
    
    primary key (nome, stanza, Orientazione),
    foreign key (stanza) references Stanza(IDstanza),
    foreign key (nome) references PuntiAccesso(NomeElemento)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;




-- ElemLuce --
--------------
drop table if exists ElemLuce;
create table ElemLuce
(
	IDelemLuce VARCHAR(10) NOT NULL,
    Nome VARCHAR(20) NOT NULL
		check(Nome in ('faretti', 'spot', 'lampade', 'neon') or null),
    NumVolte int(10)  default 0,
    TemperaturaMax int(20) not null,
    IntensitàMax int(20) not null,
    
    primary key (IDelemLuce)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;



-- presenza1  --
----------------
drop table if exists Presenza1;
create table Presenza1 
(
	ElemLuci VARCHAR(10) NOT NULL,
    stanza VARCHAR(50) NOT NULL,
    
    primary key (ElemLuci, stanza),
    foreign key (stanza) references Stanza(IDstanza),
    foreign key (ElemLuci) references ElemLuce(IDelemLuce)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;



-- configurazioniLuci --
------------------------
drop table if exists ConfigurazioniLuci;
create table ConfigurazioniLuci 
(
	ElemLuci VARCHAR(10) NOT NULL,
    user VARCHAR(10) NOT NULL,
    Intensità int(50) not null,
    Temperatura int(20) not null,
    Timestamp timestamp not null,
    
    primary key (ElemLuci, user, Timestamp),
    foreign key (ElemLuci) references ElemLuce(IDelemLuce),
    foreign key (user) references User(UserName)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;



-- StatoElemLuce --
-------------------
drop table if exists StatoElemLuce;
create table StatoElemLuce
(
	ElemLuci VARCHAR(10) NOT NULL,
    user VARCHAR(10) NOT NULL,
    StatoElemento varchar(20) not null
		check(StatoElemento in ('on', 'off')),
    Timestamp timestamp not null,
    
    primary key (ElemLuci, user, Timestamp),
    foreign key (ElemLuci) references ElemLuce(IDelemLuce),
    foreign key (user) references User(UserName)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;
 
 
 
-- ElemAria --
--------------
drop table if exists ElemAria;
create table ElemAria
(
	IDelemAria VARCHAR(10) NOT NULL,
    
    primary key (IDelemAria) 
)ENGINE = InnoDB DEFAULT CHARSET = latin1;



-- presenza2 --
---------------
drop table if exists Presenza2;
create table Presenza2
(
	ElementoAria VARCHAR(10) NOT NULL,
    stanza VARCHAR(50) NOT NULL,
    
    primary key (ElementoAria, stanza),
    foreign key (ElementoAria) references ElemAria(IDelemAria),
    foreign key (stanza) references Stanza(IDstanza)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;
 
 
 
 
-- SettingCond  --
------------------
drop table if exists SettingCond;
create table SettingCond
(
	ElementoAria VARCHAR(10) NOT NULL,
    user VARCHAR(10) NOT NULL,
    Timestamp timestamp not null,
    Temperatura int(20) default null,
    LivUmidità int(20) default null,
    OraInizio time default null,
    OraFine time default null,
    DataDeferred date default null,
    EnergiaTemperatura double default null,
    
    primary key (ElementoAria, user, Timestamp),
    foreign key (ElementoAria) references ElemAria(IDelemAria),
    foreign key (user) references User(UserName)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;
  



-- RecurrentSettingCond -- 
--------------------------
drop table if exists RecurrentSettingCond;
create table RecurrentSettingCond
(
	ElemAria VARCHAR(10) NOT NULL,
    user VARCHAR(10) NOT NULL,
    Timestamp timestamp not null,
    Temperatura int(20) default null,
    LivUmidità int(20) default null,
    OraInizio time default null,
    OraFine time default null,
    dayweek varchar(20) default 'all'
		check(dayweek in ('lunedì', 'martedì', 'mercoledì', 'giovedì', 'venerdì')),
    mese varchar(10) default 'all',
	season varchar(20) default 'all'
		check(season in ('inverno', 'estate', 'primavera', 'autunno')),
    EnergiaTemperatura double default null,
    
    primary key (ElemAria, user, Timestamp),
    foreign key (ElemAria) references ElemAria(IDelemAria),
    foreign key (user) references User(UserName)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;



-- SmartPlug --
---------------
drop table if exists SmartPlug;
create table SmartPlug
(
	CodiceSmartplug VARCHAR(10) NOT NULL,
    Stato varchar(20) default 'inattivo'
		check(Stato in ('attivo', 'inattivo')), -- 0 = inattivo
    
    primary key (CodiceSmartplug)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;


-- Dispositivi --
drop table if exists Dispositivi;
create table Dispositivi
(
	IDdispositivo VARCHAR(10) NOT NULL,
    ConsumoTotale double default 0,
    Conto int(20) default 0,
    Tipo varchar(20) not null
		check(Tipo in ('on-off', 'programmabili', 'regolabili')),
    UsoSingolo varchar(10) default 'si'
		check(UsoSingolo in ('si', 'no')),
    PotenzaMax double default null,
    PotenzaMin double default null,
    
    primary key (IDdispositivo)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;


-- Presenza3 --
---------------
drop table if exists Presenza3;
create table Presenza3
(
	stanza VARCHAR(50) NOT NULL,
    dispositivo VARCHAR(10) NOT NULL,
    
    primary key (dispositivo, stanza),
    foreign key (dispositivo) references Dispositivi(IDdispositivo),
    foreign key (stanza) references Stanza(IDstanza)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;


-- Collegamento --
------------------
drop table if exists Collegamento;
create table Collegamento
(
	smartplug VARCHAR(10) NOT NULL,
    dispositivo VARCHAR(10) NOT NULL,
    
    primary key (dispositivo, smartplug),
    foreign key (dispositivo) references Dispositivi(IDdispositivo),
    foreign key (smartplug) references SmartPlug(CodiceSmartplug)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;


-- Programmi -- 
---------------
drop table if exists Programmi;
create table Programmi
(
	NomeProg VARCHAR(20) NOT NULL,
    ConsumoMedio double default 0,
    PotenzaProg double not null,
    DurataProg double not null, -- durata in ora
    
    primary key (NomeProg)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;


-- Applicabilità --
-------------------
drop table if exists Applicabilità;
create table Applicabilità
(
	programma VARCHAR(20) NOT NULL,
    dispositivo VARCHAR(10) NOT NULL,
    
    primary key (dispositivo, programma),
    foreign key (dispositivo) references Dispositivi(IDdispositivo),
    foreign key (programma) references Programmi(NomeProg)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;


-- SetProgramDispositivi --
---------------------------
drop table if exists SetProgramDispositivi;
create table SetProgramDispositivi
(
	programma VARCHAR(20) NOT NULL,
    dispositivo VARCHAR(10) NOT NULL,
    user varchar(10) not null,
    Timestamp timestamp not null,
    DataDeferred date default null,
    OraDeferred time default null,
    
    primary key (dispositivo, programma, Timestamp, user),
    foreign key (dispositivo) references Dispositivi(IDdispositivo),
    foreign key (programma) references Programmi(NomeProg),
    foreign key (user) references User(UserName)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;
 

-- SettingDispositivi --
------------------------
drop table if exists SettingDispositivi;
create table SettingDispositivi
(

    dispositivo VARCHAR(10) NOT NULL,
    user varchar(10) not null,
    Timestamp timestamp not null,
    PotenzaSet double default null,
    DurataSet double default null,
    OraDeferred time default null,
    DataDeferred date default null,
    
    primary key (dispositivo, Timestamp, user),
    foreign key (dispositivo) references Dispositivi(IDdispositivo),
    foreign key (user) references User(UserName)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;

SET FOREIGN_KEY_CHECKS = 1;





---------------------------------------------------------------------------
-- -- VINCOLI DI INTEGRITA GENERICI  ------
---------------------------------------------------------------------------

-- Prima di creare un account per un abitante, controllo che il suo documento non sia scaduto

DROP TRIGGER IF EXISTS CheckDocument;
DELIMITER $$
CREATE TRIGGER CheckDocument
BEFORE INSERT ON Registrazione
FOR EACH ROW
BEGIN

-- prima vado a controllare la scadenza nella tabella Abitante
	set @a =
    (
		select Scadenza
        from Abitante
        where CodFiscale = new.abitante
    );
    
	IF
		(@a < current_date())
	THEN
		
-- qui cancello l'account creato nella tabella User
        delete
        from User
        where new.user = UserName;
        
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ATTENTION: DOCUMENTO SCADUTO';
        
    END IF;
    
END $$
DELIMITER ;





-- verificare che un utente sia registrato prima di interagire con i elementi e dipositivi

DROP TRIGGER IF EXISTS CheckUser;
DELIMITER $$
CREATE TRIGGER CheckUser
BEFORE INSERT ON ConfigurazioniLuci
FOR EACH ROW
BEGIN
	IF not exists
    (
		select *
        from User U
        where new.user = U.UserName
	)
	THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ATTENTION: UTENTE NON REGISTRATO';
    END IF;
END $$
DELIMITER ;


DROP TRIGGER IF EXISTS CheckUser;
DELIMITER $$
CREATE TRIGGER CheckUser
BEFORE INSERT ON StatoElemLuce
FOR EACH ROW
BEGIN
	IF not exists
    (
		select *
        from User U
        where new.user = U.UserName
	)
	THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ATTENTION: UTENTE NON REGISTRATO';
    END IF;
END $$
DELIMITER ;



DROP TRIGGER IF EXISTS CheckUser;
DELIMITER $$
CREATE TRIGGER CheckUser
BEFORE INSERT ON SettingCond
FOR EACH ROW
BEGIN
	IF not exists
    (
		select *
        from User U
        where new.user = U.UserName
	)
	THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ATTENTION: UTENTE NON REGISTRATO';
    END IF;
END $$
DELIMITER ;



DROP TRIGGER IF EXISTS CheckUser;
DELIMITER $$
CREATE TRIGGER CheckUser
BEFORE INSERT ON RecurrentSettingCond
FOR EACH ROW
BEGIN
	IF not exists
    (
		select *
        from User U
        where new.user = U.UserName
	)
	THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ATTENTION: UTENTE NON REGISTRATO';
    END IF;
END $$
DELIMITER ;




DROP TRIGGER IF EXISTS CheckUser;
DELIMITER $$
CREATE TRIGGER CheckUser
BEFORE INSERT ON SetProgramDispositivi
FOR EACH ROW
BEGIN
	IF not exists
    (
		select *
        from User U
        where new.user = U.UserName
	)
	THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ATTENTION: UTENTE NON REGISTRATO';
    END IF;
END $$
DELIMITER ;



DROP TRIGGER IF EXISTS CheckUser;
DELIMITER $$
CREATE TRIGGER CheckUser
BEFORE INSERT ON SettingDispositivi
FOR EACH ROW
BEGIN
	IF not exists
    (
		select *
        from User U
        where new.user = U.UserName
	)
	THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ATTENTION: UTENTE NON REGISTRATO';
    END IF;
END $$
DELIMITER ;




-- imposta stato smart plug quando viene collegato con un dispositivo --

drop trigger if exists OnSmartplug;
delimiter $$
create trigger OnSmartplug
after insert on collegamento
for each row
begin
		update SmartPlug
        set Stato = 'attivo'
        where CodiceSmartplug = new.smartplug;
end $$
delimiter ;


-- non si può effettuare un'impostazione su un dispositivo con un programma che non è suo

DROP TRIGGER IF EXISTS checkProgam;
DELIMITER $$
CREATE TRIGGER checkProgam
before INSERT ON SetProgramDispositivi
FOR EACH ROW
BEGIN
	
    if not exists
    (
		select 1
        from Applicabilità A
        where new.programma = A.programma and new.dispositivo = A.dispositivo
    )
    then
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Programma non è di quel dispositivo';
	end if;
END $$
DELIMITER ;




-- imposta la variabile EnergiaPerGrado di una Stanza --------

drop trigger if exists setEnergia;
delimiter $$
create trigger  setEnergia
before insert on Stanza
for each row
begin 
	
    -- ipotesi coeffisciente termico pari a 35 kcal/mc
    set  @a = new.altezza * new.lunghezza * new.larghezza * 35;  -- risultato in kcal devo convertere in KW con la formula 1 Kcal = 1,163 watt
    
    set new.EnergiaPerGrado =( (@a * 1.163) / 1000 );
    
end $$
delimiter ;




-- calcolo dell'energia necessaria per mantenere una temperatura impostata in una stanza ----

drop trigger if exists ConsumoImpostazione;
delimiter $$
create trigger  ConsumoImpostazione
before insert on SettingCond
for each row
begin 
	
    -- EnergiaPerGrado * |TemperaturaImpostata - TemperaturaInterna| +  EnergiaPerGrado * (percentuale del livello di dispersione della temperatura interna)
    -- ipotesi : 1 punto di accesso diminuisce di 5% la temperatura interna. 
    -- vado a ricavare il numero di Punti di accesso della stanza su cui si effettua l'impostazione
    set @a = 
			(
				select count(*)
                from composizione C inner join presenza2 P on P.stanza = C.stanza
                where P.ElementoAria = new.ElementoAria
            );
    
    
    -- leggo EnergiaPerGrado e la temperatura interna della stanza per fare variare di un grado la temperatura interna.
    set @b = 
			(
				select EnergiaPerGrado
                from stanza S inner join presenza2 P on P.stanza = S.IDstanza
                where new.ElementoAria = P.ElementoAria
            );
	set @TempInterna =
			(
				select SensoreInterno
                from stanza S inner join presenza2 P on P.stanza = S.IDstanza
                where new.ElementoAria = P.ElementoAria
            );
	
    -- ricavo la differanza di temperatura
	if(@TempInterna >= new.Temperatura) then set@TempDiff = @TempInterna - new.Temperatura;
    else set@TempDiff = new.Temperatura - @TempInterna;
    end if;
    
    set new.EnergiaTemperatura = (@TempDiff * @b) + (@a * 0.05) * @TempInterna;
     
end $$
delimiter ;




-- aggiorno la Temperatura interna della stanza ----

drop trigger if exists aggiornaTempStanza;
delimiter $$
create trigger aggiornaTempStanza
after insert on SettingCond
for each row
begin
	
    update Stanza
    set SensoreInterno = new.Temperatura
    where IDstanza = (
						select P.stanza
                        from presenza2 P
                        where new.ElementoAria = P.ElementoAria
					 );
end $$
delimiter ;






-- -------------------------------------------
-- AGGIORNAMENTO DELLE RIDONDANZE ------------
-- -------------------------------------------



-- aggiorna la ridondanza NumVolte -------

DROP TRIGGER IF EXISTS aggiorna1;
DELIMITER $$
CREATE TRIGGER aggiorna1
after INSERT ON ConfigurazioniLuci
FOR EACH ROW
BEGIN
	update ElemLuce
    set NumVolte = NumVolte + 1
    where new.ElemLuci = IDelemLuci;
END $$
DELIMITER ;



-- aggiorna Conto --------------

DROP TRIGGER IF EXISTS aggiorna2;
DELIMITER $$
CREATE TRIGGER aggiorna2
after INSERT ON SettingDispositivi
FOR EACH ROW
BEGIN
	update Dispositivi
    set Conto = Conto + 1
    where new.dispositivo = IDdispositivo;
END $$
DELIMITER ;


DROP TRIGGER IF EXISTS aggiorna3;
DELIMITER $$
CREATE TRIGGER aggiorna3
after INSERT ON SetProgramDispositivi
FOR EACH ROW
BEGIN
	update Dispositivi
    set Conto = Conto + 1
    where new.dispositivo = IDdispositivo;
END $$
DELIMITER ;


-- aggiorna ConsumoTotale

DROP TRIGGER IF EXISTS aggiorna4;
DELIMITER $$
CREATE TRIGGER aggiorna4
after INSERT ON SetProgramDispositivi
FOR EACH ROW
BEGIN
    set @a =
    (
		select DurataProg * PotenzaProg
        from Programmi
        where new.Programma = NomeProg
	);
    
	update Dispositivi
    set ConsumoTotale = ConsumoTotale + @a
    where new.dispositivo = IDdispositivo;
END $$
DELIMITER ;



DROP TRIGGER IF EXISTS aggiorna5;
DELIMITER $$
CREATE TRIGGER aggiorna5
after INSERT ON SettingDispositivi
FOR EACH ROW
BEGIN
	update Dispositivi
    set ConsumoTotale = ConsumoTotale + (new.DurataSet * new.PotenzaSet)
    where new.dispositivo = IDdispositivo;
END $$
DELIMITER ;
