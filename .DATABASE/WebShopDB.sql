create database webshop
use webshop


Create table Artikal(
artikal_id INT Primary Key identity(1,1),
ime nvarchar(100) not null,
cena int not null,
statusArtikla_id int,
kategorija_id int,
slika_id int,
opis nvarchar(250),
magacin int
)


Create table Kategorija (
kategorija_id int Primary Key identity(1,1),
kategorija_ime nvarchar(100)
)


Create table StatusArtikla (
statusArtikla_id int Primary Key identity(1,1),
is_vidljivo BIT default(0)
)


Create table Slika (
slika_id int Primary Key identity(1,1),
slika_ref nvarchar(150) not null unique
)


Create table Porudzbina (
porudzbina_id INT PRIMARY KEY identity(1,1),
korisnik_id INT not null,
artikal_id INT not null,
is_zavrseno BIT DEFAULT (0),
vreme_porudzbina DATETIME NOT NULL,
kolicina_kupovine INT NOT NULL
)


Create table Korisnik (
korisnik_id int Primary Key identity(1,1),
ime_korisnik nvarchar(100) not null,
prezime_korisnik nvarchar(100) not null,
lozinka_hash nvarchar(255) not null,
email nvarchar(255) not null unique,
drzava nvarchar(100) not null,
grad nvarchar(100) not null,
opstina nvarchar(100) not null,
postanski_br int not null,
adresa nvarchar(255) not null,
tip_korisnik_id int,
pol nvarchar(10) not null check (pol in('Musko', 'Zensko'))
)


Create table TipKorisnik (
tip_korisnik_id int Primary Key identity(1,1),
is_administrator BIT DEFAULT (0)
)



ALTER table Artikal
add constraint FK_statusArtikla_id
FOREIGN KEY (statusArtikla_id)
REFERENCES StatusArtikla(statusArtikla_id);

ALTER table Artikal
add constraint FK_kategorija_id
FOREIGN KEY (kategorija_id)
REFERENCES Kategorija(kategorija_id);

ALTER table Artikal
add constraint FK_slika_id
FOREIGN KEY (slika_id)
REFERENCES Slika(slika_id);



ALTER table Porudzbina
add constraint FK_korisnik_id
FOREIGN KEY (korisnik_id)
REFERENCES Korisnik(korisnik_id);

ALTER table Porudzbina
add constraint FK_artikal_id
FOREIGN KEY (artikal_id)
REFERENCES Artikal(artikal_id);



ALTER table Korisnik
add constraint FK_tip_korisnik_id
FOREIGN KEY (tip_korisnik_id)
REFERENCES TipKorisnik(tip_korisnik_id);




/*Provera postojanja korisnika*/
GO
Create PROC dbo.Korisnik_Email
@email nvarchar(50),
@loz nvarchar(100)
AS
SET LOCK_TIMEOUT 3000;
BEGIN TRY
	IF EXISTS(SELECT TOP 1 email FROM Korisnik
	WHERE email = @email and lozinka_hash=@loz)
	Begin
	RETURN 0
	end
	RETURN 1
END TRY
BEGIN CATCH
	RETURN @@error;
END CATCH
GO


GO
CREATE PROC Korisnik_Insert
@ime_korisnik nvarchar(100),
@prezime_korisnik nvarchar(100),
@lozinka_hash nvarchar(255),
@email nvarchar(255),
@drzava nvarchar(100),
@grad nvarchar(100),
@opstina nvarchar(100),
@postanski_br int,
@adresa nvarchar(255),
@tip_korisnik_id int,
@pol nvarchar(10)
AS
SET LOCK_TIMEOUT 3000;
BEGIN TRY
	IF EXISTS(SELECT TOP 1 email FROM Korisnik
	WHERE email = @email and lozinka_hash=@lozinka_hash)
	Return 1
	else
	Insert Into Korisnik(ime_korisnik,prezime_korisnik,lozinka_hash,email,drzava,grad,opstina,postanski_br,adresa,tip_korisnik_id,pol)
	Values(@ime_korisnik,@prezime_korisnik,@lozinka_hash,@email,@drzava,@grad,@opstina,@postanski_br,@adresa,@tip_korisnik_id,@pol)
		RETURN 0;
END TRY
	
BEGIN CATCH
	RETURN @@ERROR;
END CATCH
GO



/*  OVO JE VEC GORE NAPRAVLJENO, Da li je greskom ponovljeno ??
GO
Create PROC dbo.Korisnik_Email
@email nvarchar(50),
@loz nvarchar(100)
AS
SET LOCK_TIMEOUT 3000;
BEGIN TRY
	IF EXISTS(SELECT TOP 1 email FROM Korisnik
	WHERE email = @email and lozinka_hash=@loz)
	Begin
	RETURN 0
	end
	RETURN 1
END TRY
BEGIN CATCH
	RETURN @@error;
END CATCH
GO
*/



/*-------------------------------------- Radio sam odavde -------------------------------------------*/
/* Nisam pokretao u SSMS-u */
/* Provera broja u magacinu >>> tabela Artikal*/
GO
Create PROC dbo.Artikal_Magacin
@ime nvarchar(100),
@magacin int
AS
SET LOCK_TIMEOUT 3000;
BEGIN TRY
	IF EXISTS(SELECT TOP 1 ime FROM Artikal
	WHERE ime = @ime and magacin = @magacin)
	Begin
	RETURN 0
	end
	RETURN 1
END TRY
BEGIN CATCH
	RETURN @@error;
END CATCH
GO

GO
CREATE PROC Artikal_Insert
@ime nvarchar(100),
@cena int,
@statusArtikla_id int,
@kategorija_id int,
@slika_id int,
@opis nvarchar(250),
@magacin int
AS
SET LOCK_TIMEOUT 3000;
BEGIN TRY
	IF EXISTS(SELECT TOP 1 ime FROM Artikal
	WHERE ime = @ime and magacin = @magacin)
	Return 1
	else
	Insert Into Artikal(ime, cena, statusArtikla_id, kategorija_id, slika_id, opis, magacin)
	Values(@ime, @cena, @statusArtikla_id, @kategorija_id, @slika_id, @opis, @magacin)
		RETURN 0;
END TRY
	
BEGIN CATCH
	RETURN @@ERROR;
END CATCH
GO



/* ----------------------Tabela Kategorija -------------------- */
GO
Create PROC dbo.Kategorija_Ime
@kategorija_ime nvarchar(100)
AS
SET LOCK_TIMEOUT 3000;
BEGIN TRY
	IF EXISTS(SELECT TOP 1 kategorija_ime FROM Kategorija
	WHERE kategorija_ime = @kategorija_ime)
	Begin
	RETURN 0
	end
	RETURN 1
END TRY
BEGIN CATCH
	RETURN @@error;
END CATCH
GO


GO
CREATE PROC Kategorija_Insert
@kategorija_ime nvarchar(100)
AS
SET LOCK_TIMEOUT 3000;
BEGIN TRY
	IF EXISTS(SELECT TOP 1 kategorija_ime FROM Kategorija
	WHERE kategorija_ime = @kategorija_ime)
	Return 1
	else
	Insert Into Kategorija(kategorija_ime)
	Values(@kategorija_ime)
		RETURN 0;
END TRY
	
BEGIN CATCH
	RETURN @@ERROR;
END CATCH
GO




/* ----------------------Tabela StatusArtikla, Da li i za ovu tabelu pravimo proceduru? -------------------- */
GO
Create PROC dbo.StatusArtikla_Status
@is_vidljivo BIT
AS
SET LOCK_TIMEOUT 3000;
BEGIN TRY
	IF EXISTS(SELECT TOP 1 is_vidljivo FROM StatusArtikla                      /*Ovde kao da fali neka dodatna funkcija..*/
	WHERE is_vidljivo = @is_vidljivo)
	Begin
	RETURN 0
	end
	RETURN 1
END TRY
BEGIN CATCH
	RETURN @@error;
END CATCH
GO


GO
CREATE PROC StatusArtikla_Insert
@is_vidljivo BIT
AS
SET LOCK_TIMEOUT 3000;
BEGIN TRY
	IF EXISTS(SELECT TOP 1 is_vidljivo FROM StatusArtikla
	WHERE is_vidljivo = @is_vidljivo)
	Return 1
	else
	Insert Into StatusArtikla(is_vidljivo)
	Values(@is_vidljivo)
		RETURN 0;
END TRY
	
BEGIN CATCH
	RETURN @@ERROR;
END CATCH
GO



/* ---------------------- Tabela Slika ---------------------- */
GO
Create PROC dbo.Slika_Ref
@slika_ref nvarchar(150)
AS
SET LOCK_TIMEOUT 3000;
BEGIN TRY
	IF EXISTS(SELECT TOP 1 slika_ref FROM Slika
	WHERE slika_ref = @slika_ref)
	Begin
	RETURN 0
	end
	RETURN 1
END TRY
BEGIN CATCH
	RETURN @@error;
END CATCH
GO


GO
CREATE PROC Slika_Insert
@slika_ref nvarchar(150)
AS
SET LOCK_TIMEOUT 3000;
BEGIN TRY
	IF EXISTS(SELECT TOP 1 slika_ref FROM Slika
	WHERE slika_ref = @slika_ref)
	Return 1
	else
	Insert Into Slika(slika_ref)
	Values(@slika_ref)
		RETURN 0;
END TRY
	
BEGIN CATCH
	RETURN @@ERROR;
END CATCH
GO



/* ---------------------- Tabela Porudzbina ---------------------- */
GO
Create PROC dbo.Porudzbina_Artikal
@korisnik_id INT,
@artikal_id INT
AS
SET LOCK_TIMEOUT 3000;
BEGIN TRY
	IF EXISTS(SELECT TOP 1 korisnik_id FROM Porudzbina
	WHERE korisnik_id = @korisnik_id and artikal_id = @artikal_id)
	Begin
	RETURN 0
	end
	RETURN 1
END TRY
BEGIN CATCH
	RETURN @@error;
END CATCH
GO


GO
CREATE PROC Porudzbina_Insert
@korisnik_id INT,
@artikal_id INT,
@is_zavrseno BIT,
@vreme_porudzbina DATETIME,
@kolicina_kupovine INT
AS
SET LOCK_TIMEOUT 3000;
BEGIN TRY
	IF EXISTS(SELECT TOP 1 korisnik_id FROM Porudzbina
	WHERE korisnik_id = @korisnik_id and artikal_id = @artikal_id)
	Return 1
	else
	Insert Into Porudzbina(korisnik_id, artikal_id, is_zavrseno, vreme_porudzbina, kolicina_kupovine)
	Values(@korisnik_id, @artikal_id, @is_zavrseno, @vreme_porudzbina, @kolicina_kupovine)
		RETURN 0;
END TRY
	
BEGIN CATCH
	RETURN @@ERROR;
END CATCH
GO



/* ---------------------- Tabela TipKorisnik ---------------------- */
GO
Create PROC dbo.TipKorisnik_Korisnik
@is_administrator BIT
AS
SET LOCK_TIMEOUT 3000;
BEGIN TRY
	IF EXISTS(SELECT TOP 1 is_administrator FROM TipKorisnik
	WHERE is_administrator = @is_administrator)
	Begin
	RETURN 0
	end
	RETURN 1
END TRY
BEGIN CATCH
	RETURN @@error;
END CATCH
GO


GO
CREATE PROC TipKorisnik_Insert
@is_administrator BIT
AS
SET LOCK_TIMEOUT 3000;
BEGIN TRY
	IF EXISTS(SELECT TOP 1 is_administrator FROM TipKorisnik
	WHERE is_administrator = @is_administrator)
	Return 1
	else
	Insert Into TipKorisnik(is_administrator)
	Values(@is_administrator)
		RETURN 0;
END TRY
	
BEGIN CATCH
	RETURN @@ERROR;
END CATCH
GO

/*------kraj-----------*/

