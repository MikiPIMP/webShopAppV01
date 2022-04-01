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

