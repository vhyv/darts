USE sipky;
GO

CREATE TABLE players
	(
	p_id		int		IDENTITY(1,1)
	,jmeno		nvarchar(255)	NULL
	,prijmeni	nvarchar(255)	NULL
	,nickname	nvarchar(255)	NOT NULL
	,CONSTRAINT PK_players	PRIMARY KEY(p_id)
	)
;
GO

CREATE TABLE typ_hry
	(
	id_hra		int		IDENTITY(1,1)
	,typ_hry	nvarchar(255)	NOT NULL
	,CONSTRAINT PK_typhry	PRIMARY KEY(id_hra)
	)
;
GO

CREATE TABLE typ_otvor
	(
	id_otvor	int		IDENTITY(1,1)
	,otvor		nvarchar(255)	NOT NULL
	,zatvor		nvarchar(255)	NOT NULL
	,CONSTRAINT	PK_otvorzatvor	PRIMARY KEY(id_otvor)
	)
;
GO

CREATE TABLE zapas
	(
	id_zapas	int		IDENTITY(1,1)
	,datum		date	NOT NULL
	,player1	int		NOT NULL
	,player2	int		NOT NULL
	,result		int		NOT NULL
	,typ_hry	int		NOT NULL
	,typ_otvor	int		NOT NULL
	,pocet_setu	int		NOT NULL
	,pocet_legu	int		NOT NULL
	,CONSTRAINT PK_zapas	PRIMARY KEY(id_zapas)
	,CONSTRAINT FK_zapas_p1	FOREIGN KEY(player1)
		REFERENCES players(p_id)
		ON UPDATE CASCADE
		ON DELETE CASCADE
	,CONSTRAINT FK_zapas_p2	FOREIGN KEY(player2)
		REFERENCES players(p_id)
	,CONSTRAINT FK_zapas_typhry	FOREIGN KEY(typ_hry)
		REFERENCES typ_hry(id_hra)
		ON UPDATE CASCADE
		ON DELETE CASCADE
	,CONSTRAINT FK_zapas_otvor	FOREIGN KEY(typ_otvor)
		REFERENCES typ_otvor(id_otvor)
		ON UPDATE CASCADE
		ON DELETE CASCADE
	,CONSTRAINT check_zapas_result	
		CHECK (result IN (player1, player2))
	)
;
GO

CREATE TABLE detaily
	(
	id_zapas	int		NOT NULL
	,player		int		NOT NULL
	,vyhrane_sety	int	NOT NULL
	,vyhrane_legy	int	NOT NULL
	,maximum	int		NULL
	,prumer		numeric(7,2)	NOT NULL
	,prumer6_9	numeric(7,2)	NOT NULL
	,nejrychlejsi	int	NOT NULL
	,finish		int		NOT NULL
	,[100plus]	int			NULL
	,[140plus]	int			NULL
	,[180]		int			NULL
	,topavg		numeric(7,2)	NULL
	,botavg		numeric(7,2)	NULL
	,doubles	numeric(7,2)	NULL
	,[20minus]	int		NULL
	,[20plus]		int		NULL
	,[40plus]		int		NULL
	,[60plus]		int		NULL
	,[80plus]		int		NULL
	,CONSTRAINT	PK_detaily	PRIMARY KEY(id_zapas, player)
	,CONSTRAINT FK_detaily_zapas	FOREIGN KEY(id_zapas)
		REFERENCES zapas(id_zapas)
		ON DELETE CASCADE
		ON UPDATE CASCADE
	,CONSTRAINT FK_detaily_players	FOREIGN KEY(player)
		REFERENCES players(p_id)
	)
;
go


