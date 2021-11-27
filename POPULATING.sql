use smarthome;

insert into Abitante(CodFiscale, Nome, Cognome, Scadenza, NumDoc, EnteRilascio, TipoDoc, Telefono)
values ('ZZNBRC94R40Z306G', 'Maria', 'Rossi', '2022-08-08', '123456', 'comune', 'carta identità', '3381234567'),
		('DDNBRC94R03Z306D', 'Luca', 'Dangelo', '2022-10-08', '223456', 'governo', 'passaporto', '4481234567'),
        ('SSNBRC94R03Z306T', 'Toni', 'Sandro', '2023-08-08', '323456', 'comune', 'carta identità', '3381234567'),
        ('FFNBRC94R03Z306F', 'Eric', 'Molli', '2024-05-05', '423456', 'comune', 'carta identità', '0081234567');
        
    

insert into User(UserName)
values ('user1'),
		('user2');
        
        
insert into Registrazione(user, abitante, DataRegistrazione)
values ('user1', 'ZZNBRC94R40Z306G', '2021-05-10'),
		('user2', 'FFNBRC94R03Z306F', '2021-07-10');
        
        

insert into Domande(IDdomanda, DettagliDomanda)
values ('ask1', 'sei vegetariano ?'),
		('ask2', 'una mela ?'),
        ('ask3', 'mangi il dolce ?'),
        ('ask4', 'bevi il vino ?'),
        ('ask5', 'euro2020 vince Italia ?');
        


insert into Recupero(user, domanda, Risposta)
values ('user1', 'ask5', 'si'),
		('user2', 'ask2', 'no');
	


insert into Stanza(IDstanza, piano, altezza, lunghezza, larghezza, SensoreInterno)
values ('cam2', 0, 2.6, 2.1, 3.1, 19),
	    ('cam5', 1, 2.3, 3, 5, 19),
        ('cam3', 2, 2.5, 5, 5, 20),
        ('cam8', 0, 2.6, 3.3, 3.3, 18);



insert into PuntiAccesso(NomeElemento)
values ('finestra'),
		('porta'),
        ('portafinestra');
        




insert into Programmi(NomeProg, PotenzaProg, DurataProg)
values ('clean1', 150, 1.5),
		('color1', 100, 1),
        ('hard1', 200, 2),
        ('fresh1', 70, 0.80);
        
        
        
        

insert into SmartPlug(CodiceSmartPlug)
values ('sd1'),
		('sd2'),
        ('sd3'),
        ('sd4'),
        ('sd5'),
        ('sd6'),
        ('sd7');
        


insert into Dispositivi(IDdispositivo, Tipo, UsoSingolo, PotenzaMax, PotenzaMin)
values ('device1', 'regolabili', 'si', 2000, 1000),
		('device2', 'programmabili', 'si', 2000, 1000),
        ('device4', 'on-off', 'si', 200, 50),
        ('device5', 'on-off', 'si', 2000, 1000),
        ('device9', 'regolabili', 'no', 2000, 1000),
        ('device0', 'on-off', 'no', 150, 50);
        



insert into SettingDispositivi (dispositivo, user, Timestamp, PotenzaSet, DurataSet, OraDeferred, DataDeferred)
values 
	 ('device1', 'user1', current_timestamp(), 200, 1, current_time(), current_time() + interval 30 minute),
      ('device2', 'user2', current_timestamp(), 150, 2, null, null);



insert into Applicabilità
values ('clean1', 'device2'),
		('fresh1', 'device2'),
        ('color1', 'device2');
        


insert into SetProgramDispositivi
values ('clean1', 'device2', 'user2', current_timestamp(), null, null),
		('color1', 'device2', 'user1', current_timestamp(), current_date(), current_time());
        
        
insert into collegamento
values ('sd1', 'device1'),
		('sd2', 'device2'),
        ('sd3', 'device4'),
        ('sd4', 'device5'),
        ('sd5', 'device0'),
        ('sd6', 'device9');
        



insert into presenza3
values('cam2', 'device1'),
		('cam2', 'device2'),
        ('cam3', 'device4'),
        ('cam5', 'device5'),
        ('cam8', 'device0'),
        ('cam5', 'device9');
        
        
insert into ElemAria(IDelemAria)
values ('samsung1'),
		('lg3'),
        ('novotech4'),
        ('hay9');


insert into presenza2
values ('samsung1', 'cam2'),
		('lg3', 'cam3'),
        ('novotech4', 'cam5'),
        ('hay9', 'cam8');



insert into ElemLuce (IDelemLuce, Nome, TemperaturaMax, Intensitàmax)
values ('neon2', 'neon', 80, 100),
		('neon3', 'neon', 80, 100),
        ('neon8', 'neon', 80, 100),
		('neon5', 'neon', 50, 100),
        ('lampade3', 'lampada', 70, 100),
        ('lampade5', 'lampada', 70, 100),
        ('lampade8', 'lampada', 70, 100),
        ('spot3', 'spot', 70, 100),
        ('spot5', 'spot', 70, 100),
        ('spot8', 'spot', 70, 100),
        ('feretti3', 'faretti', 30, 100),
        ('feretti5', 'faretti', 30, 100),
        ('feretti8', 'faretti', 30, 100);


insert into ElemLuce(IDelemLuce, Nome, TemperaturaMax, Intensitàmax)
values('lampade2', 'lampada', 50, 150),
		('neon1', 'neon', 50, 150),
        ('neon4', 'neon', 50, 150),
        ('spot1', 'spot', 50, 150),
        ('feretti1', 'faretti', 50, 150);



insert into presenza1
values ('neon2', 'cam2'),
		('neon3', 'cam3'),
        ('neon5', 'cam5'),
        ('neon8', 'cam8'),

        ('spot1', 'cam2'),
		('spot3', 'cam3'),
        ('spot5', 'cam5'),
        ('spot8', 'cam8'),
        
        ('lampade2', 'cam2'),
		('lampade3', 'cam3'),
        ('lampade5', 'cam5'),
        ('lampade8', 'cam8'),
        
        ('feretti1', 'cam2'),
		('feretti3', 'cam3'),
        ('feretti5', 'cam5'),
        ('feretti8', 'cam8'),
        
        ('neon1', 'cam8'),
        ('neon4', 'cam5');



insert into composizione
values ('porta', 'cam2', 'N'),
		('finestra','cam2', 'NW'),
        ('porta', 'cam3', 'W'),
        ('portafinestra', 'cam3', 'SW'),
        ('finestra', 'cam3', 'S'),
        ('finestra', 'cam5', 'N'),
        ('porta', 'cam5', 'N'),
        ('porta', 'cam8', 'E'),
        ('finestra', 'cam8', 'SW');




insert into RecurrentSettingCond(ElemAria, user, Timestamp, Temperatura, OraInizio, OraFine, dayweek, season)
values ('hay9', 'user1', current_timestamp(), 21, current_time(), current_time() + 10, 'venerdì', 'inverno');



