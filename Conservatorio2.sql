-- phpMyAdmin SQL Dump
-- version 5.0.3
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Creato il: Mag 24, 2021 alle 23:37
-- Versione del server: 10.4.14-MariaDB
-- Versione PHP: 7.4.11

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `Conservatorio2`
--

DELIMITER $$
--
-- Procedure
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `AffittoAula` (IN `Matricola` VARCHAR(20), IN `numero_aula_affitto` INT, IN `Data_affitto` DATE)  BEGIN
    IF
        NOT EXISTS(
            SELECT* 
            FROM Studente s 
            WHERE s.Matricola IN
                (
                SELECT affitto.Matricola
                FROM affitto
                WHERE affitto.data = Data_affitto
                )
            ) 
        AND 
        NOT EXISTS(
            SELECT* 
            FROM Aula
            WHERE Aula.numero_aula IN
                (
                SELECT affitto.numero_aula_affitto
                FROM affitto
                WHERE affitto.data = Data_affitto
                )
            )
    THEN
    INSERT INTO affitto(Matricola,numero_aula_affitto,data) VALUES (Matricola,numero_aula_affitto,Data_affitto);
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `AggiungiOrchestrale` (IN `matricola` VARCHAR(20), IN `nome_orchestra` VARCHAR(20))  BEGIN
INSERT INTO suona (matricola,nome)
VALUES (matricola,nome_orchestra);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `CalcoloPensione` ()  BEGIN
	SELECT ImpiegatiPensionabili.nome,ImpiegatiPensionabili.cognome,(ImpiegatiPensionabili.Stipendio*0.95) AS Pensione
	FROM ImpiegatiPensionabili;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DocentiCheInsegnanoPiano` ()  BEGIN
SELECT p.nome from Docente d, Personale p where p.id = d.id AND d.strumento LIKE 'Pianoforte';
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `FrequentaCorso` (IN `id_corso` VARCHAR(20), IN `Matricola` VARCHAR(20))  BEGIN
	IF EXISTS (
        SELECT *
   		FROM Corso
   		WHERE Corso.id_corso = id_corso AND Corso.anno = YEAR(CURRENT_DATE())
    )THEN 
    INSERT INTO Frequenza_corrente VALUES(id_corso,Matricola);
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PrenotazioneEsami` (IN `id_prenotazione` VARCHAR(20), IN `Matricola` VARCHAR(20))  BEGIN
UPDATE Prenotazione set Prenotazione.id_prenotazione = id_prenotazione AND Prenotazione.portale = Maticola WHERE NOW() <> Esame.data_ora;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `StudentiMaterieAnno` (IN `anno` YEAR, IN `nome_corso1` VARCHAR(20), IN `nome_corso2` VARCHAR(20))  BEGIN
    SELECT s.nome, s.cognome 
    FROM Frequenza_Passata fp,Corso c,Studente s 
    WHERE fp.id_corso = c.id_corso AND fp.matricola = s.matricola AND c.anno = anno  
    GROUP BY s.matricola 
    HAVING COUNT(c.materia LIKE nome_corso1)>0 AND COUNT(c.materia LIKE nome_corso2)>0; 
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Struttura della tabella `affitto`
--

CREATE TABLE `affitto` (
  `Matricola` varchar(20) NOT NULL,
  `numero_aula_affitto` int(11) NOT NULL,
  `data` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `affitto`
--

INSERT INTO `affitto` (`Matricola`, `numero_aula_affitto`, `data`) VALUES
('00034', 1, '2021-01-17');

-- --------------------------------------------------------

--
-- Struttura della tabella `Aula`
--

CREATE TABLE `Aula` (
  `numero_aula` int(11) NOT NULL,
  `piano` int(11) DEFAULT NULL,
  `posti` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `Aula`
--

INSERT INTO `Aula` (`numero_aula`, `piano`, `posti`) VALUES
(1, 1, 9),
(2, 1, 10),
(10, 2, 10),
(20, 3, 9);

-- --------------------------------------------------------

--
-- Struttura della tabella `Bustapaga`
--

CREATE TABLE `Bustapaga` (
  `Id_bustapaga` varchar(30) NOT NULL,
  `Stipendio` int(11) DEFAULT NULL,
  `id` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `Bustapaga`
--

INSERT INTO `Bustapaga` (`Id_bustapaga`, `Stipendio`, `id`) VALUES
('01', 1500, '12367'),
('01', 1500, '6789'),
('02', 2000, '95030'),
('03', 900, '9999');

-- --------------------------------------------------------

--
-- Struttura della tabella `Concorso`
--

CREATE TABLE `Concorso` (
  `nome` varchar(30) NOT NULL,
  `anno_creazione` year(4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Struttura della tabella `Corso`
--

CREATE TABLE `Corso` (
  `id_corso` varchar(20) NOT NULL,
  `programma` varchar(1000) DEFAULT NULL,
  `materia` varchar(30) DEFAULT NULL,
  `responsabile` varchar(20) DEFAULT NULL,
  `anno` year(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `Corso`
--

INSERT INTO `Corso` (`id_corso`, `programma`, `materia`, `responsabile`, `anno`) VALUES
('01', 'Chopin,Bach,...', 'Storia della Musica', '6789', 2018),
('012', 'Tecnica Pianistica,Sonate romantiche...', 'Pianoforte', '12367', 2018),
('016', NULL, 'Armonia 2', '95030', 2021),
('019', NULL, 'Armonia 1', '6789', 2021),
('09', 'sasdad', 'Consapevolezza corporea', '12367', 2021),
('2312', 'dsfsd', 'Storia della Musica 2', '6789', 2021);

-- --------------------------------------------------------

--
-- Struttura della tabella `Dirigente`
--

CREATE TABLE `Dirigente` (
  `id` varchar(20) NOT NULL,
  `Incarico` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Struttura della tabella `Docente`
--

CREATE TABLE `Docente` (
  `id` varchar(20) NOT NULL,
  `strumento` varchar(30) DEFAULT NULL,
  `email` varchar(30) NOT NULL,
  `password` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `Docente`
--

INSERT INTO `Docente` (`id`, `strumento`, `email`, `password`) VALUES
('12367', 'Bombardino', '', ''),
('6789', 'Storia Della Musica', '', ''),
('95030', 'Pianoforte', '', '');

-- --------------------------------------------------------

--
-- Struttura della tabella `Erasmus`
--

CREATE TABLE `Erasmus` (
  `a_accademico` year(4) NOT NULL,
  `strumento` varchar(30) NOT NULL,
  `meta` varchar(30) NOT NULL,
  `stato` varchar(30) DEFAULT NULL,
  `numero_partecipanti` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `Erasmus`
--

INSERT INTO `Erasmus` (`a_accademico`, `strumento`, `meta`, `stato`, `numero_partecipanti`) VALUES
(2018, 'Pianoforte', 'Strasburgo', 'Austria', 1);

-- --------------------------------------------------------

--
-- Struttura della tabella `Esame`
--

CREATE TABLE `Esame` (
  `aula` int(11) DEFAULT NULL,
  `data_ora` datetime DEFAULT NULL,
  `id_esame` varchar(20) NOT NULL,
  `appello` varchar(20) DEFAULT NULL,
  `prenotazione_esame` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `Esame`
--

INSERT INTO `Esame` (`aula`, `data_ora`, `id_esame`, `appello`, `prenotazione_esame`) VALUES
(1, '2021-01-13 00:00:00', '01', '01', NULL),
(1, '2020-01-13 00:00:00', '012', '01', 1534),
(1, '2021-05-27 21:49:34', '016', '016', NULL),
(1, '2021-05-26 21:39:02', '019', '019', NULL),
(1, '2021-05-26 00:00:00', '09', '09', NULL),
(1, '2021-05-26 21:39:02', '2312', '2312', NULL);

-- --------------------------------------------------------

--
-- Struttura della tabella `Frequenza_corrente`
--

CREATE TABLE `Frequenza_corrente` (
  `id_corso` varchar(20) NOT NULL,
  `matricola` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `Frequenza_corrente`
--

INSERT INTO `Frequenza_corrente` (`id_corso`, `matricola`) VALUES
('2312', '00034');

-- --------------------------------------------------------

--
-- Struttura della tabella `Frequenza_Passata`
--

CREATE TABLE `Frequenza_Passata` (
  `id_corso` varchar(20) NOT NULL,
  `matricola` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `Frequenza_Passata`
--

INSERT INTO `Frequenza_Passata` (`id_corso`, `matricola`) VALUES
('01', '00034'),
('012', '00034');

-- --------------------------------------------------------

--
-- Struttura stand-in per le viste `ImpiegatiPensionabili`
-- (Vedi sotto per la vista effettiva)
--
CREATE TABLE `ImpiegatiPensionabili` (
`nome` varchar(20)
,`cognome` varchar(20)
,`Stipendio` int(11)
);

-- --------------------------------------------------------

--
-- Struttura della tabella `Lezione`
--

CREATE TABLE `Lezione` (
  `id_corso` varchar(20) NOT NULL,
  `numero_aula` int(11) NOT NULL,
  `id_docente` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Struttura della tabella `Manutenzioni`
--

CREATE TABLE `Manutenzioni` (
  `note` varchar(200) DEFAULT NULL,
  `costo` double DEFAULT NULL,
  `data` date DEFAULT NULL,
  `cura` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Struttura della tabella `Orchestra`
--

CREATE TABLE `Orchestra` (
  `n_orchestrali` int(11) DEFAULT NULL,
  `nome` varchar(50) NOT NULL,
  `id` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `Orchestra`
--

INSERT INTO `Orchestra` (`n_orchestrali`, `nome`, `id`) VALUES
(4, 'V_Bellini', '95030');

-- --------------------------------------------------------

--
-- Struttura della tabella `Partecipazione`
--

CREATE TABLE `Partecipazione` (
  `a_accademico` year(4) NOT NULL,
  `strumento` varchar(30) NOT NULL,
  `meta` varchar(20) NOT NULL,
  `Matricola` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `Partecipazione`
--

INSERT INTO `Partecipazione` (`a_accademico`, `strumento`, `meta`, `Matricola`) VALUES
(2018, 'Pianoforte', 'Strasburgo', '00034');

--
-- Trigger `Partecipazione`
--
DELIMITER $$
CREATE TRIGGER `allineamentonumero_PartecipantiPartecipazione` BEFORE INSERT ON `Partecipazione` FOR EACH ROW UPDATE Erasmus e SET e.numero_partecipanti = e.numero_partecipanti +1 where new.meta like e.meta and new.strumento like e.strumento and new.a_accademico = e.a_accademico
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struttura della tabella `Personale`
--

CREATE TABLE `Personale` (
  `nome` varchar(20) DEFAULT NULL,
  `cognome` varchar(20) DEFAULT NULL,
  `eta` int(11) DEFAULT NULL,
  `data_nascita` date DEFAULT NULL,
  `tipo` varchar(20) DEFAULT NULL,
  `data_fine_rapporto` date DEFAULT NULL,
  `data_inizio_rapporto` date DEFAULT NULL,
  `id` varchar(20) NOT NULL,
  `email` varchar(30) NOT NULL,
  `password` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `Personale`
--

INSERT INTO `Personale` (`nome`, `cognome`, `eta`, `data_nascita`, `tipo`, `data_fine_rapporto`, `data_inizio_rapporto`, `id`, `email`, `password`) VALUES
('Giovanni', 'Cultrera', 55, '1965-04-09', 'Personale Corrente', NULL, '1992-04-08', '12367', '', ''),
('Antonella', 'Bevilacqua', 53, '1968-03-05', 'Personale Corrente', NULL, '2002-09-11', '6789', '', ''),
('Epifanio', 'Comis', 63, '1958-01-26', 'Personale Corrente', NULL, '1991-03-03', '95030', '', ''),
('Pippo', 'Rapisarda', 65, '1955-09-24', 'Personale Corrente', NULL, '1988-09-30', '9999', '', '');

-- --------------------------------------------------------

--
-- Struttura della tabella `Prenotazione`
--

CREATE TABLE `Prenotazione` (
  `id_prenotazione` varchar(20) NOT NULL,
  `portale` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `Prenotazione`
--

INSERT INTO `Prenotazione` (`id_prenotazione`, `portale`) VALUES
('1', '1534'),
('19', '1534'),
('2312', '1534'),
('9', '1534');

-- --------------------------------------------------------

--
-- Struttura della tabella `Provvedimento`
--

CREATE TABLE `Provvedimento` (
  `codice` varchar(20) NOT NULL,
  `data_provvedimento` date DEFAULT NULL,
  `descrizione` varchar(30) DEFAULT NULL,
  `tipo` varchar(20) DEFAULT NULL,
  `provvedimento_dirigente` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Struttura della tabella `Richiesta`
--

CREATE TABLE `Richiesta` (
  `invio` varchar(20) DEFAULT NULL,
  `testo` varchar(100) DEFAULT NULL,
  `id_richiesta` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Struttura della tabella `Risposta`
--

CREATE TABLE `Risposta` (
  `id_richiesta` varchar(20) NOT NULL,
  `testo` varchar(100) DEFAULT NULL,
  `lettura` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Struttura della tabella `Segretario`
--

CREATE TABLE `Segretario` (
  `id` varchar(20) NOT NULL,
  `grado` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Struttura della tabella `Sostenuto`
--

CREATE TABLE `Sostenuto` (
  `id_esame` varchar(20) NOT NULL,
  `Matricola` varchar(20) NOT NULL,
  `Esito` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Struttura della tabella `Strumenti_conservatorio`
--

CREATE TABLE `Strumenti_conservatorio` (
  `nome` varchar(30) DEFAULT NULL,
  `data_acquisto` date DEFAULT NULL,
  `id_strumento` varchar(20) NOT NULL,
  `numero_aula` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Struttura della tabella `Studente`
--

CREATE TABLE `Studente` (
  `Matricola` varchar(30) NOT NULL,
  `Nome` varchar(30) DEFAULT NULL,
  `Cognome` varchar(30) DEFAULT NULL,
  `strumento` varchar(30) DEFAULT NULL,
  `email` varchar(50) NOT NULL,
  `password` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `Studente`
--

INSERT INTO `Studente` (`Matricola`, `Nome`, `Cognome`, `strumento`, `email`, `password`) VALUES
('00034', 'Mary', 'Di Gregorio', 'Pianoforte', '', ''),
('012345', 'Antonella', 'Falzone', 'Pianoforte', '', ''),
('12345', 'Giuseppe', 'Conte', 'Tamburo', '', ''),
('123456', 'Davide', 'Grimaldi', 'Bombardino', '', ''),
('1534', 'Francesca', 'laurenti', 'violino', 'c@email.com', '1234'),
('34', 'Mary', 'Rapisarda', 'violino', 'm@email.com', '567'),
('509', 'Dav', 'Grim', 'Pianoforte', 'd@email.com', '345');

-- --------------------------------------------------------

--
-- Struttura della tabella `Studenti_concorso`
--

CREATE TABLE `Studenti_concorso` (
  `Matricola` varchar(20) NOT NULL,
  `anno` year(4) NOT NULL,
  `nome` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Struttura della tabella `suona`
--

CREATE TABLE `suona` (
  `Matricola` varchar(20) NOT NULL,
  `nome` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `suona`
--

INSERT INTO `suona` (`Matricola`, `nome`) VALUES
('00034', 'V_Bellini'),
('012345', 'V_Bellini'),
('12345', 'V_Bellini'),
('123456', 'V_Bellini');

--
-- Trigger `suona`
--
DELIMITER $$
CREATE TRIGGER `allineamentoRidondanzaOrchestraliSuona` BEFORE INSERT ON `suona` FOR EACH ROW UPDATE Orchestra o SET o.n_orchestrali = o.n_orchestrali +1 where new.nome like o.nome
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struttura per vista `ImpiegatiPensionabili`
--
DROP TABLE IF EXISTS `ImpiegatiPensionabili`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `ImpiegatiPensionabili`  AS SELECT `Personale`.`nome` AS `nome`, `Personale`.`cognome` AS `cognome`, `Bustapaga`.`Stipendio` AS `Stipendio` FROM (`Personale` join `Bustapaga`) WHERE `Personale`.`id` = `Bustapaga`.`id` AND `Personale`.`eta` > 61 ;

--
-- Indici per le tabelle scaricate
--

--
-- Indici per le tabelle `affitto`
--
ALTER TABLE `affitto`
  ADD PRIMARY KEY (`Matricola`,`numero_aula_affitto`),
  ADD KEY `numero_aula_affitto` (`numero_aula_affitto`);

--
-- Indici per le tabelle `Aula`
--
ALTER TABLE `Aula`
  ADD PRIMARY KEY (`numero_aula`);

--
-- Indici per le tabelle `Bustapaga`
--
ALTER TABLE `Bustapaga`
  ADD PRIMARY KEY (`Id_bustapaga`,`id`),
  ADD KEY `Bustapaga_ibfk_1` (`id`);

--
-- Indici per le tabelle `Concorso`
--
ALTER TABLE `Concorso`
  ADD PRIMARY KEY (`nome`);

--
-- Indici per le tabelle `Corso`
--
ALTER TABLE `Corso`
  ADD PRIMARY KEY (`id_corso`,`anno`),
  ADD KEY `responsabile` (`responsabile`);

--
-- Indici per le tabelle `Dirigente`
--
ALTER TABLE `Dirigente`
  ADD PRIMARY KEY (`id`);

--
-- Indici per le tabelle `Docente`
--
ALTER TABLE `Docente`
  ADD PRIMARY KEY (`id`);

--
-- Indici per le tabelle `Erasmus`
--
ALTER TABLE `Erasmus`
  ADD PRIMARY KEY (`a_accademico`,`strumento`,`meta`);

--
-- Indici per le tabelle `Esame`
--
ALTER TABLE `Esame`
  ADD PRIMARY KEY (`id_esame`),
  ADD KEY `appello` (`appello`),
  ADD KEY `prenotazione_esame` (`prenotazione_esame`);

--
-- Indici per le tabelle `Frequenza_corrente`
--
ALTER TABLE `Frequenza_corrente`
  ADD PRIMARY KEY (`id_corso`,`matricola`),
  ADD KEY `matricola` (`matricola`);

--
-- Indici per le tabelle `Frequenza_Passata`
--
ALTER TABLE `Frequenza_Passata`
  ADD PRIMARY KEY (`id_corso`,`matricola`),
  ADD KEY `matricola` (`matricola`);

--
-- Indici per le tabelle `Lezione`
--
ALTER TABLE `Lezione`
  ADD PRIMARY KEY (`id_corso`,`numero_aula`,`id_docente`),
  ADD KEY `numero_aula` (`numero_aula`),
  ADD KEY `id_docente` (`id_docente`);

--
-- Indici per le tabelle `Manutenzioni`
--
ALTER TABLE `Manutenzioni`
  ADD KEY `cura` (`cura`);

--
-- Indici per le tabelle `Orchestra`
--
ALTER TABLE `Orchestra`
  ADD PRIMARY KEY (`nome`),
  ADD KEY `id` (`id`);

--
-- Indici per le tabelle `Partecipazione`
--
ALTER TABLE `Partecipazione`
  ADD PRIMARY KEY (`a_accademico`,`strumento`,`meta`),
  ADD KEY `Matricola` (`Matricola`);

--
-- Indici per le tabelle `Personale`
--
ALTER TABLE `Personale`
  ADD PRIMARY KEY (`id`);

--
-- Indici per le tabelle `Prenotazione`
--
ALTER TABLE `Prenotazione`
  ADD PRIMARY KEY (`id_prenotazione`),
  ADD KEY `portale` (`portale`);

--
-- Indici per le tabelle `Provvedimento`
--
ALTER TABLE `Provvedimento`
  ADD PRIMARY KEY (`codice`),
  ADD KEY `provvedimento_dirigente` (`provvedimento_dirigente`);

--
-- Indici per le tabelle `Richiesta`
--
ALTER TABLE `Richiesta`
  ADD PRIMARY KEY (`id_richiesta`),
  ADD KEY `invio` (`invio`);

--
-- Indici per le tabelle `Risposta`
--
ALTER TABLE `Risposta`
  ADD PRIMARY KEY (`id_richiesta`),
  ADD KEY `lettura` (`lettura`);

--
-- Indici per le tabelle `Segretario`
--
ALTER TABLE `Segretario`
  ADD PRIMARY KEY (`id`);

--
-- Indici per le tabelle `Sostenuto`
--
ALTER TABLE `Sostenuto`
  ADD PRIMARY KEY (`id_esame`,`Matricola`),
  ADD KEY `Matricola` (`Matricola`);

--
-- Indici per le tabelle `Strumenti_conservatorio`
--
ALTER TABLE `Strumenti_conservatorio`
  ADD PRIMARY KEY (`id_strumento`),
  ADD KEY `numero_aula` (`numero_aula`);

--
-- Indici per le tabelle `Studente`
--
ALTER TABLE `Studente`
  ADD PRIMARY KEY (`Matricola`);

--
-- Indici per le tabelle `Studenti_concorso`
--
ALTER TABLE `Studenti_concorso`
  ADD PRIMARY KEY (`Matricola`,`anno`,`nome`);

--
-- Indici per le tabelle `suona`
--
ALTER TABLE `suona`
  ADD PRIMARY KEY (`Matricola`,`nome`),
  ADD KEY `nome` (`nome`);

--
-- Limiti per le tabelle scaricate
--

--
-- Limiti per la tabella `affitto`
--
ALTER TABLE `affitto`
  ADD CONSTRAINT `affitto_ibfk_1` FOREIGN KEY (`Matricola`) REFERENCES `Studente` (`Matricola`),
  ADD CONSTRAINT `affitto_ibfk_2` FOREIGN KEY (`numero_aula_affitto`) REFERENCES `Aula` (`numero_aula`);

--
-- Limiti per la tabella `Bustapaga`
--
ALTER TABLE `Bustapaga`
  ADD CONSTRAINT `Bustapaga_ibfk_1` FOREIGN KEY (`id`) REFERENCES `Personale` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limiti per la tabella `Corso`
--
ALTER TABLE `Corso`
  ADD CONSTRAINT `Corso_ibfk_1` FOREIGN KEY (`responsabile`) REFERENCES `Docente` (`id`);

--
-- Limiti per la tabella `Dirigente`
--
ALTER TABLE `Dirigente`
  ADD CONSTRAINT `Dirigente_ibfk_1` FOREIGN KEY (`id`) REFERENCES `Personale` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limiti per la tabella `Docente`
--
ALTER TABLE `Docente`
  ADD CONSTRAINT `Docente_ibfk_1` FOREIGN KEY (`id`) REFERENCES `Personale` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limiti per la tabella `Esame`
--
ALTER TABLE `Esame`
  ADD CONSTRAINT `Esame_ibfk_1` FOREIGN KEY (`appello`) REFERENCES `Corso` (`id_corso`);

--
-- Limiti per la tabella `Frequenza_corrente`
--
ALTER TABLE `Frequenza_corrente`
  ADD CONSTRAINT `Frequenza_corrente_ibfk_1` FOREIGN KEY (`matricola`) REFERENCES `Studente` (`Matricola`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `Frequenza_corrente_ibfk_2` FOREIGN KEY (`id_corso`) REFERENCES `Corso` (`id_corso`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limiti per la tabella `Frequenza_Passata`
--
ALTER TABLE `Frequenza_Passata`
  ADD CONSTRAINT `Frequenza_Passata_ibfk_1` FOREIGN KEY (`matricola`) REFERENCES `Studente` (`Matricola`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `Frequenza_Passata_ibfk_2` FOREIGN KEY (`id_corso`) REFERENCES `Corso` (`id_corso`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limiti per la tabella `Lezione`
--
ALTER TABLE `Lezione`
  ADD CONSTRAINT `Lezione_ibfk_1` FOREIGN KEY (`id_corso`) REFERENCES `Corso` (`id_corso`),
  ADD CONSTRAINT `Lezione_ibfk_2` FOREIGN KEY (`numero_aula`) REFERENCES `Aula` (`numero_aula`),
  ADD CONSTRAINT `Lezione_ibfk_3` FOREIGN KEY (`id_docente`) REFERENCES `Docente` (`id`);

--
-- Limiti per la tabella `Manutenzioni`
--
ALTER TABLE `Manutenzioni`
  ADD CONSTRAINT `Manutenzioni_ibfk_1` FOREIGN KEY (`cura`) REFERENCES `Strumenti_conservatorio` (`id_strumento`);

--
-- Limiti per la tabella `Orchestra`
--
ALTER TABLE `Orchestra`
  ADD CONSTRAINT `Orchestra_ibfk_1` FOREIGN KEY (`id`) REFERENCES `Docente` (`id`);

--
-- Limiti per la tabella `Partecipazione`
--
ALTER TABLE `Partecipazione`
  ADD CONSTRAINT `Partecipazione_ibfk_1` FOREIGN KEY (`Matricola`) REFERENCES `Studente` (`Matricola`),
  ADD CONSTRAINT `Partecipazione_ibfk_2` FOREIGN KEY (`a_accademico`,`strumento`,`meta`) REFERENCES `Erasmus` (`a_accademico`, `strumento`, `meta`);

--
-- Limiti per la tabella `Prenotazione`
--
ALTER TABLE `Prenotazione`
  ADD CONSTRAINT `Prenotazione_ibfk_1` FOREIGN KEY (`portale`) REFERENCES `Studente` (`Matricola`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limiti per la tabella `Provvedimento`
--
ALTER TABLE `Provvedimento`
  ADD CONSTRAINT `Provvedimento_ibfk_1` FOREIGN KEY (`provvedimento_dirigente`) REFERENCES `Dirigente` (`id`);

--
-- Limiti per la tabella `Richiesta`
--
ALTER TABLE `Richiesta`
  ADD CONSTRAINT `Richiesta_ibfk_1` FOREIGN KEY (`invio`) REFERENCES `Studente` (`Matricola`);

--
-- Limiti per la tabella `Risposta`
--
ALTER TABLE `Risposta`
  ADD CONSTRAINT `Risposta_ibfk_1` FOREIGN KEY (`id_richiesta`) REFERENCES `Richiesta` (`id_richiesta`),
  ADD CONSTRAINT `Risposta_ibfk_2` FOREIGN KEY (`lettura`) REFERENCES `Segretario` (`id`);

--
-- Limiti per la tabella `Segretario`
--
ALTER TABLE `Segretario`
  ADD CONSTRAINT `Segretario_ibfk_1` FOREIGN KEY (`id`) REFERENCES `Personale` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limiti per la tabella `Sostenuto`
--
ALTER TABLE `Sostenuto`
  ADD CONSTRAINT `Sostenuto_ibfk_1` FOREIGN KEY (`id_esame`) REFERENCES `Esame` (`id_esame`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `Sostenuto_ibfk_2` FOREIGN KEY (`Matricola`) REFERENCES `Studente` (`Matricola`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limiti per la tabella `Strumenti_conservatorio`
--
ALTER TABLE `Strumenti_conservatorio`
  ADD CONSTRAINT `Strumenti_conservatorio_ibfk_1` FOREIGN KEY (`numero_aula`) REFERENCES `Aula` (`numero_aula`);

--
-- Limiti per la tabella `suona`
--
ALTER TABLE `suona`
  ADD CONSTRAINT `suona_ibfk_1` FOREIGN KEY (`nome`) REFERENCES `Orchestra` (`nome`) ON UPDATE CASCADE,
  ADD CONSTRAINT `suona_ibfk_2` FOREIGN KEY (`Matricola`) REFERENCES `Studente` (`Matricola`) ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
