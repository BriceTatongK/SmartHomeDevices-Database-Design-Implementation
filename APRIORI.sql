#------------------------------------------------------------------------
#+++++	CREAZIONE DELLE TAB PER RACCOLTA DATI ( ITEMS E TRANSACTIONS ) ++
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


# TABELLA UTILIZZO PER LE TRANSAZIONI
#-------------------------------------

drop table if exists Utilizzo;
CREATE TABLE Utilizzo (
	Transactions INT AUTO_INCREMENT PRIMARY KEY,
    
    ItemSets VARCHAR(200) NOT NULL

)ENGINE = InnoDB DEFAULT CHARSET = latin1;




# TABELLA CANDIDATE1 CHE CONTIENE L'INSIEME DI ITEMS  I = {item1, item2 ....}
#----------------------------------------------------------------------------

drop table if exists Candidate1;
CREATE TABLE Candidate1 (

    Items VARCHAR(200) NOT NULL,
	Supporto double default null,
    
    primary key (Items)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;


#------------------------------------------------
#+++ POPOLO LE DUE TABELLE ++++++++++++++++++++++
#++++++++++++++++++++++++++++++++++++++++++++++++

insert into Utilizzo(ItemSets) values ('device1'), ('device1, device3'), ('device3, device1, device4'), ('device1, device2'), ('device3, device4'), ('device3, device5, device1'),
										('device2'), ('device3, device1'), ('device3, device5, device4'), ('device4, device3'), ('device2, device5'), ('device4, device5, device1');
								
		
        
insert into Candidate1(Items) values('device1'), ('device2'), ('device3'), ('device4'), ('device5');



# CALCOLA I SUPPORT DI OGNI ITEMS DELL'INSIEME I = {item1, item2 ....}
#---------------------------------------------------------------------
update Candidate1
set supporto = (
					select sum(if(locate(Items, ItemSets) <> 0, 1, 0))
                    from Utilizzo
				);





#----------------------------------------------------
#####################################################
#  STORE PROCEDURE APRIORI(supporto, confidenza)    #
#####################################################
#----------------------------------------------------


DROP PROCEDURE IF EXISTS APRIORI;
DELIMITER $$
CREATE PROCEDURE APRIORI(IN _MinSupp double, IN _MinConf double)
BEGIN

        
        
#########################
######## PASSO 1 ########
#########################
#creazione tabella L (k-1) large items 
#----------------------------------

	drop table Large1;
	CREATE TABLE Large1 (
		-- IDinteraction INT AUTO_INCREMENT PRIMARY KEY,
		Items VARCHAR(200) NOT NULL,
		-- supporto double default null,
		
		primary key (Items)
		-- FOREIGN KEY (dispositivo) REFERENCES Dispositivi(IDdispositivo)
	)ENGINE = InnoDB DEFAULT CHARSET = latin1;



	insert into Large1
	(
		select Items
		from candidate1
		where Supporto >=  _MinSupp
	);





#########################
######## PASSO 2 ########
#########################

#crea tab C2 e effettuo JOIN
#---------------------------


	drop table if exists Candidate2;
	CREATE TABLE Candidate2 (

		Items1 VARCHAR(200) NOT NULL,
		Items2 VARCHAR(200) NOT NULL,
		Supporto double default null,
		
		primary key (Items1, Items2)
	)ENGINE = InnoDB DEFAULT CHARSET = latin1;


	insert into candidate2(Items1, Items2)
	(
		select distinct t1.Items, t2.Items
		from Large1 t1 cross join Large1 t2
		where t1.Items <> t2.Items
	);


	-- calcolo i supporto 
	-- ++++++++++++++++++

	update Candidate2
	set supporto = (
						select count(*)
						from Utilizzo
						where locate(Items1, ItemSets) <> 0 and locate(Items2, ItemSets) <> 0
					);


#############################
######## PASSO 3 & 4 ########
#############################

# creazione tabella L2 large items, effettuo il PRUNING DEI ELEMENTI IN C(1) E TRANSFERISCO IN L2 QUELLI RIMQNENTI
#++++++++++++++++++++++++++++++++++

	drop table if exists Large2;
	CREATE TABLE Large2 (
		-- IDinteraction INT AUTO_INCREMENT PRIMARY KEY,
		Items1 VARCHAR(200) NOT NULL,
		Items2 VARCHAR(200) NOT NULL,
		-- supporto double default null,
		
		primary key (Items1, Items2)
		-- FOREIGN KEY (dispositivo) REFERENCES Dispositivi(IDdispositivo)
	)ENGINE = InnoDB DEFAULT CHARSET = latin1;


	insert into Large2
	(
		select Items1, Items2
		from candidate2
		where Supporto >=  _MinSupp
	);

	-- select *
	-- from Large2;




# QUI CONTROLLO SE L'INSIEME 'L2' E VUOTO DOPO AVER EFFETTUATO IL PRUNING NELLA TABELLA C2
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Mi fermo ?? 
#++++++++++++


set @a = (select count(*) from Large2);

if 
	@a = 0

then
        select *
        from candidate2;
        
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'L2 VUOTO:  L1 -> NESSUN LARGE ITEMSETS OTTENUTO !';
        
        
end if;



#+++++++++++++++++++++++++++++++++++++++++++++
# ALTRIMENTI RIPRENDO IL PASSO 3 DI JOIN 
#+++++++++++++++++++++++++++++++++++++++++++++
	-- crea tab C3
	-- +++++++++++++

	drop table if exists Candidate3;
	CREATE TABLE Candidate3 (

		Items1 VARCHAR(200) NOT NULL,
		Items2 VARCHAR(200) NOT NULL,
		Items3 VARCHAR(200) NOT NULL,
		Supporto double default null,
		
		primary key (Items1, Items2, Items3)
	)ENGINE = InnoDB DEFAULT CHARSET = latin1;


	insert into candidate3(Items1, Items2, Items3)
	(
		select distinct t1.Items1, t1.Items2, t2.Items2
		from 
			(
				select t2.Items2
				from Large2 t2
			)as t2
			cross join Large2 t1
		where t2.Items2 <> t1.Items1 and t2.Items2 <> t1.Items2
	);



	-- calcolo i supporto 
	-- ++++++++++++++++++
	update Candidate3
	set supporto = (
						select count(*)
						from Utilizzo
						where locate(Items1, ItemSets) <> 0 and locate(Items2, ItemSets) <> 0 and locate(Items3, ItemSets) <> 0
					);




	# creo Large3
	# ++++++++++++
    
	drop table if exists Large3;
	CREATE TABLE Large3 (
		
		Items1 VARCHAR(200) NOT NULL,
		Items2 VARCHAR(200) NOT NULL,
		Items3 VARCHAR(200) NOT NULL,
		
		
		primary key (Items1, Items2, Items3)
	)ENGINE = InnoDB DEFAULT CHARSET = latin1;


	insert into Large3
	(
		select Items1, Items2, Items3
		from candidate3
		where Supporto >=  _MinSupp
	);



# CONTROLLO DOPO IL PRUNING
#++++++++++++++++++++++++++
	-- MI fermo ?? 
	-- +++++++++++++


set @a = (select count(*) from Large3);

if @a = 0

then

	drop table if exists ARules2;
	CREATE TABLE Arules2 (
	ID INT AUTO_INCREMENT PRIMARY KEY,
	Antecedente VARCHAR(200) NOT NULL,
	Conseguente VARCHAR(200) NOT NULL,
	Confidenza double default null
		
	)ENGINE = InnoDB DEFAULT CHARSET = latin1;



	insert into ARules2(Antecedente, Conseguente, Confidenza)
	(
		select L.Items1, L.Items2, ((select C2.supporto from candidate2 C2 where C2.Items1 = L.Items1 and C2.Items2 = L.Items2)/(select C1.supporto from candidate1 C1 where C1.Items = L.Items1))*100
		from Large2 L
	);
    
    select *
	from ARules2;
    -- where Confidenza > _MinConf;
    
    
    signal sqlstate '45000'
	set message_text = 'STOP: L3 VUOTO !! CONSIDERO L2';
    
    
end if;


#+++++++++++++++++++++++++++++++++++++++++++++
# ALTRIMENTI RIPRENDO IL PASSO 3 DI JOIN 
#+++++++++++++++++++++++++++++++++++++++++++++
	-- crea tab C4
	-- +++++++++++++

	drop table if exists Candidate4;
	CREATE TABLE Candidate4 (

		Items1 VARCHAR(200) NOT NULL,
		Items2 VARCHAR(200) NOT NULL,
		Items3 VARCHAR(200) NOT NULL,
        Items4 VARCHAR(200) NOT NULL,
		Supporto double default null,
		
		primary key (Items1, Items2, Items3, Items4)
	)ENGINE = InnoDB DEFAULT CHARSET = latin1;


	insert into candidate4(Items1, Items2, Items3, Items4)
	(
		select distinct t2.Items1, t2.Items2, t2.Items3, t3.Items3
		from 
			(
				select t3.Items3
				from Large3 t3
			)as t3
			cross join Large3 t2
		where t3.Items3 <> t2.Items1 and t3.Items3 <> t2.Items2 and t3.Items3 <> t2.Items3
	);





	-- calcolo i supporto 
	-- ++++++++++++++++++
	update Candidate4
	set supporto = (
						select count(*)
						from Utilizzo
						where locate(Items1, ItemSets) <> 0 and locate(Items2, ItemSets) <> 0 and locate(Items3, ItemSets) <> 0 and locate(Items4, ItemSets) <> 0
					);



	# creo Large4
	# ++++++++++++
    
	drop table if exists Large4;
	CREATE TABLE Large4 (
		
		Items1 VARCHAR(200) NOT NULL,
		Items2 VARCHAR(200) NOT NULL,
		Items3 VARCHAR(200) NOT NULL,
        Items4 VARCHAR(200) NOT NULL,
		
		
		primary key (Items1, Items2, Items3, Items4)
	)ENGINE = InnoDB DEFAULT CHARSET = latin1;


	insert into Large4
	(
		select Items1, Items2, Items3, Items4
		from candidate4
		where Supporto >=  _MinSupp
	);







# CONTROLLO DOPO IL PRUNING
#++++++++++++++++++++++++++
	-- MI fermo ?? 
	-- +++++++++++++


set @a = (select count(*) from Large4);

if @a = 0

then

		drop table if exists ARules3;
		CREATE TABLE ARules3 (
		
		ID INT AUTO_INCREMENT PRIMARY KEY,
		Antecedente1 VARCHAR(200) NOT NULL,
		Conseguente1 VARCHAR(200) NOT NULL,
		Conseguente2 VARCHAR(200) NOT NULL,
		Confidenza double default null,
		InvConfidenza double default null
		
	)ENGINE = InnoDB DEFAULT CHARSET = latin1;



	insert into ARules3(Antecedente1, Conseguente1, Conseguente2, Confidenza, InvConfidenza)
	(
		select L.Items1, L.Items2, L.Items3,
		((select C3.supporto from candidate3 C3 where C3.Items1 = L.Items1 and C3.Items2 = L.Items2 and C3.Items3 = L.Items3)/(select C1.supporto from candidate1 C1 where C1.Items = L.Items1))*100,
		((select C3.supporto from candidate3 C3 where C3.Items1 = L.Items1 and C3.Items2 = L.Items2 and C3.Items3 = L.Items3)/(select C2.supporto from candidate2 C2 where C2.Items1 = L.Items2 and C2.Items2 = L.Items3))*100
		from Large3 L
	);
    
    select *
	from ARules3;
    -- where Confidenza > _MinConf OR InvConfidenza > _MinConf;
    
    
    signal sqlstate '45000'
	set message_text = 'STOP: L4 VUOTO !! CONSIDERO L3';

end if;


select *
from candidate4;


signal sqlstate '45000'
set message_text = 'NON STOP: LARGE ITEMSETS OLTRE L4';

END $$
DELIMITER ;

