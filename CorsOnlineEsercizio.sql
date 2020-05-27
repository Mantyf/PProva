-- societa (idsocieta (primario), nome, sede, numerodipendenti)
-- docente (iddocente (primario), nome, cognome, eta, FKsocieta, FKcorso)
-- corso (idcorso (primario), nome, orainizio, orafine, datainizio, datafine, FKsocieta)
-- argomento (idargomento (primario), nome, livello, orededicate)
-- trattato (idtrattato (primario), FKcorso, FKargomento)
-- scuola (idscuola (primario), nome, zona, piani, numeroAule)
-- aula (idaula (primario), piano, capienzAlunni, numeroComputer, FKscuola)
-- dedicata (iddedicata (primario), FKcorso, FKaula)
create schema corsOnline;
use corsOnline;
create table societa (
idsocieta int (11) PRIMARY KEY AUTO_INCREMENT,
nome varchar (9) NOT NULL,
sede varchar (12) NOT NULL,
numeroDipendenti int (6) NOT NULL
);
create table societaDue (
idsocieta int (11) PRIMARY KEY AUTO_INCREMENT,
nome varchar (9) NOT NULL,
sede varchar (12) NOT NULL,
numeroDipendenti int (6) NOT NULL
);
create table corso (
idcorso int (11) PRIMARY KEY AUTO_INCREMENT,
nome varchar (18) NOT NULL,
oraInizion time NOT NULL,
oraFine time NOT NULL,
dataInizio date NOT NULL,
FKcorso_societa int (11),
FOREIGN KEY FKcorso_societa (FKcorso_societa) REFERENCES societa (idsocieta)
);
create table docente (
iddocente int (11) PRIMARY KEY AUTO_INCREMENT,
nome varchar (12) NOT NULL,
cognome varchar (12) NOT NULL,
eta int (2) NOT NULL,
FKdocente_societa int (11) NOT NULL,
FKdocente_corso int (11),
FOREIGN KEY FKsocieta (FKdocente_societa) REFERENCES societa (idsocieta),
FOREIGN KEY FKcorso (FKdocente_corso) REFERENCES corso (idcorso)
);
create table argomento (
idargomento int (11) PRIMARY KEY AUTO_INCREMENT,
nome varchar (12) NOT NULL,
livello varchar (9),
oreDedicate time
);
create table corso_argomento (
idcorsoargomento int (11) PRIMARY KEY AUTO_INCREMENT,
FKcorso int (11) NOT NULL,
FKargomento int (11) NOT NULL,
FOREIGN KEY FKcorso (FKcorso) REFERENCES corso (idcorso),
FOREIGN KEY FKargomento (FKargomento) REFERENCES argomento (idargomento)
);
create table scuola (
idscuola int (11) PRIMARY KEY AUTO_INCREMENT,
nome varchar (24) NOT NULL, 
zona varchar (18) NOT NULL, 
piani int (1) NOT NULL, 
numeroAule int (2) NOT NULL
);
create table aula (
idaula int (11) PRIMARY KEY AUTO_INCREMENT, 
piano int (1) NOT NULL, 
capienzAlunni int (2) NOT NULL, 
numeroComputer int (2) NOT NULL, 
FKaula_scuola int (11) NOT NULL,
FOREIGN KEY FKaula_scuola (FKaula_scuola) REFERENCES scuola (idscuola)
);
create table aula_corso (
idaula_corso int (11) PRIMARY KEY AUTO_INCREMENT, 
FKcorso int (11), 
FKaula int (11),
FOREIGN KEY FKcorso (FKcorso) REFERENCES corso (idcorso),
FOREIGN KEY FKaula (FKaula) REFERENCES corso (idcorso)
);
SELECT * FROM societa;
SELECT* FROM corso;
create table studente (
idstudente int (11) PRIMARY KEY AUTO_INCREMENT,
nome varchar (12) NOT NULL,
cognome varchar (12) NOT NULL,
dataNascita DATE NOT NULL,
laureato BINARY
);
create table studente_corso (
idstudentecorso int (11) PRIMARY KEY AUTO_INCREMENT,
FKstudente int (11),
FKcorso int (11),
FOREIGN KEY FKstudente (FKstudente) REFERENCES studente(idstudente),
FOREIGN KEY FKcorso (FKcorso) REFERENCES corso(idcorso)
);
ALTER TABLE corso ADD dataFine DATE AFTER dataInizio;
-- Mostra solo assegnati
SELECT d.nome, d.cognome, d.eta, s.nome, s.sede, s.numeroDipendenti, c.nome FROM docente d, societa s, corso c WHERE d.FKdocente_societa=s.idsocieta AND c.FKcorso_societa=s.idsocieta;
-- Mostra tutti i corsi, ma solo le società che hanno assunto docenti
SELECT d.nome, d.cognome, d.eta, s.nome, s.sede, s.numeroDipendenti, c.nome FROM docente d INNER JOIN societa s RIGHT JOIN corso c ON d.FKdocente_societa=s.idsocieta AND c.FKcorso_societa=s.idsocieta;
SELECT c.nome, a.numeroComputer FROM corso c, aula a, aula_corso d WHERE d.FKcorso=c.idcorso AND d.FKaula=a.idaula AND a.numeroComputer>5;
SELECT nome, cognome FROM studente WHERE DATE_FORMAT(dataNascita, '%y%') LIKE '9%';
-- Questa controlla anche l'efftiva data di nascita
SELECT nome, cognome, dataNascita FROM studente WHERE DATE_FORMAT(dataNascita, '%y%') LIKE '9%';
SELECT COUNT(FKdocente_corso) FROM docente WHERE FKdocente_corso=3;
SELECT nome FROM societa WHERE (SELECT COUNT(d.FKdocente_corso) FROM societa s, docente d WHERE d.FKdocente_corso=s.idsocieta)>3;
SELECT c.nome FROM corso c, aula a, aula_corso d WHERE d.FKcorso=c.idcorso GROUP BY c.nome;
SELECT nome FROM scuola WHERE (SELECT COUNT(a.numeroComputer) FROM aula a, scuola s WHERE a.numeroComputer>9 AND a.FKaula_scuola=s.idscuola)>3;
SELECT nome FROM corso WHERE (SELECT COUNT(c.nome) FROM corso c, argomento a, corso_argomento d WHERE d.FKcorso=c.idcorso AND d.FKargomento=a.idargomento)=1;
SELECT nome, cognome FROM docente WHERE cognome LIKE 'M%';
SELECT nome, cognome FROM studente WHERE date_format(dataNascita, '%Y%')>=1995 AND date_format(dataNascita, '%m%')>03;
SELECT nome FROM corso WHERE date_format(dataInizio, '%m%')>=09 AND date_format(dataInizio, '%m%')<11;
SELECT nome FROM societa WHERE sede='Milano';
ALTER TABLE scuola ADD COLUMN citta varchar(20);
SELECT c.nome FROM corso c, scuola s, aula a, aula_corso d WHERE d.FKcorso=c.idcorso AND d.FKaula=a.idaula AND a.FKaula_scuola=s.idscuola AND s.citta='Roma';
DROP TABLE corsonline.argomento;
ALTER TABLE corsonline.corso ADD numeroArgomenti int (1) AFTER oraFine;
DROP TABLE corsonline.corso_argomento;
