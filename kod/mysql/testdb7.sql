-- MySQL dump 10.13  Distrib 9.6.0, for Linux (x86_64)
--
-- Host: localhost    Database: testdb7
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
SET @MYSQLDUMP_TEMP_LOG_BIN = @@SESSION.SQL_LOG_BIN;
SET @@SESSION.SQL_LOG_BIN= 0;

--
-- GTID state at the beginning of the backup 
--

SET @@GLOBAL.GTID_PURGED=/*!80000 '+'*/ '1d0e90ad-7f1e-11f1-a597-fe8e1f563f91:1-37';

--
-- Current Database: `testdb7`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `testdb7` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `testdb7`;

--
-- Table structure for table `plants`
--

DROP TABLE IF EXISTS `plants`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `plants` (
  `plant_id` int NOT NULL,
  `plant_hierarchy_id` int NOT NULL,
  `family_id` int NOT NULL,
  `plant_details` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`plant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `plants`
--

LOCK TABLES `plants` WRITE;
/*!40000 ALTER TABLE `plants` DISABLE KEYS */;
INSERT INTO `plants` VALUES (1,101,501,'Rosa canina (Rua pov) - Vytrval ker, lieiv rastlina znma vysokm obsahom vitaminu C.'),(2,101,501,'Malus domestica (Jablo domca) - Ovocn strom, iroko pestovan pre svoje plody v miernom psme.'),(3,102,502,'Solanum lycopersicum (Rajiak jedl) - Jednoron bylina, hospodrsky vznamn teplomiln zelenina.'),(4,102,502,'Solanum tuberosum (uok zemiakov) - Viacron huznat ponohospodrska plodina.'),(5,103,503,'Lavandula angustifolia (Levandua lekrska) - Poloker pestovan pre aromatick esencilne oleje.'),(6,103,503,'Mentha x piperita (Mta pieporn) - Vytrval bylina s vraznou mentolovou vou, vyuvan v ajoch.'),(7,104,504,'Pinus sylvestris (Borovica lesn) - Stlezelen ihlinat strom s vysokou hospodrskou hodnotou dreva.'),(8,104,504,'Picea abies (Smrek obyajn) - Najroznej ihlinan v naich lesoch, nchyln na sucho.'),(9,105,505,'Taraxacum officinale (Ppava lekrska) - Hojne rozren trvca bylina s charakteristickmi ltmi kvetmi.'),(10,105,505,'Helianthus annuus (Slnenica ron) - Vysok priemyseln plodina pestovan pre olejnat semen.'),(11,101,501,'Fragaria vesca (Jahoda obyajn) - Trvca bylina znma svojimi chutnymi ervenmi plodmi.'),(12,101,501,'Prunus avium (erea vtia) - Strom s rannm kvtnutm a sladkmi kstkovicami.'),(13,101,501,'Prunus domestica (Slivka domca) - Tradin ovocn strom pestovan v strednej Eurpe.'),(14,101,501,'Prunus armeniaca (Marhua obyajn) - Teplomiln strom vyadujci chrnen stanovitia.'),(15,101,501,'Prunus persica (Broskya obyajn) - Nzky strom s plstnatmi, vemi avnatmi plodmi.'),(16,101,501,'Pyrus communis (Hruka domca) - Dlhovek ovocn strom s typicky pretiahnutmi plodmi.'),(17,101,501,'Rubus idaeus (Malina ostruinov) - Ker s tnistmi vhonkami a voavmi ervenmi plodmi.'),(18,101,501,'Rubus fruticosus (Ostruina ernicov) - Plaziv ker s tmavofialovmi a iernymi plodmi.'),(19,101,501,'Crataegus monogyna (Hloh jednosemenn) - Tnist ker, ktorho kvety a plody podporuj kardiovaskulrny systm.'),(20,101,501,'Sorbus aucuparia (Jarabina vtia) - Strom s npadnymi ervenmi malvicami, ktor obubuje vtctvo.'),(21,102,502,'Capsicum annuum (Paprika ron) - Hospodrsky dleit zelenina s vysokm obsahom kapsaicnu.'),(22,102,502,'Solanum melongena (uok baklanov) - Teplomiln rastlina s tmavofialovmi bobuovmi plodmi.'),(23,102,502,'Nicotiana tabacum (Tabak virginsky) - Jednoron priemyseln rastlina pestovan pre listy s obsahom nikotnu.'),(24,102,502,'Atropa bella-donna (ukovec zlomocn) - Prudko jedovat lesn bylina vyuvan vo farmcii.'),(25,102,502,'Datura stramonium (Durman obyajn) - Halucinognna a jedovat rastlina s pichavmi tobolkami.'),(26,102,502,'Physalis peruviana (erea perunska) - Exotick rastlina pestovan pre plody v lampikovom obale.'),(27,102,502,'Petunia hybrida (Petnia hybridn) - Populrna balknov letnika s bohatm farebnm kvitnutm.'),(28,103,503,'Rosmarinus officinalis (Rozmarn lekrsky) - Stlezelen aromatick poloker pouvan ako korenie.'),(29,103,503,'Thymus vulgaris (Dka tymianov) - Silne voav bylinka s antiseptickmi inkami.'),(30,103,503,'Thymus serpyllum (Materina dka) - Nzka kobercov trvalka, obben v udovom lieitstve.'),(31,103,503,'Salvia officinalis (alvia lekrska) - Bylina so sivastmi listami, znma protizpalovmi inkami.'),(32,103,503,'Ocimum basilicum (Bazalka prav) - Jednoron kulinsrka bylinka, zklad talianskeho pesta.'),(33,103,503,'Origanum vulgare (Pamajorn obyajn / Oregano) - Divorastca trvalka, kov korenie na pizzu.'),(34,103,503,'Melissa officinalis (Medovka lekrska) - Bylina s citronovou vou, psob upokojujco na nervov systm.'),(35,104,504,'Abies alba (Jedla biela) - Vysok ihlinat strom s plochm ihlms a vzpriamenmi ikami.'),(36,104,504,'Larix decidua (Smrekovec opadav) - Jedin ihlinan, ktorho mkk ihlie na jese ltne a opadva.'),(37,104,504,'Pinus mugo (Borovica horsk / Kosodrevina) - Nzky ker rastci v horskch a subalpnskych polohch.'),(38,104,504,'Pinus nigra (Borovica ierna) - Odoln ihlinan s tmavou krou a dlhm tvrdm ihlm.'),(39,104,504,'Pinus cembra (Borovica limba / Limba) - Vzcny tatransk strom, dova sa veku stovrok rokov.'),(40,105,505,'Matricaria chamomilla (Rumanek kamilkov) - Svetoznma lieiv rastlina s upokojujcim ajovm vyuitm.'),(41,105,505,'Calendula officinalis (Nechtk lekrsky) - Oranovo kvitnca letnika, mas z nej regeneruje pokou.'),(42,105,505,'Arnica montana (Arnika horsk) - Chrnen horsk bylina s mimoriadnymi hojivmi inkami.'),(43,105,505,'Echinacea purpurea (Echinacea purpurov) - Trvalka s vekmi kvetmi, stimuluje imunitn systm.'),(44,105,505,'Cichorium intybus (akanka obyajn) - Modro kvitnca bylinka, jej kore sli na vrobu cigrie (nhrady kvy).'),(45,105,505,'Arctium lappa (Lopch v.) - Dvojron rastlina s obrovskmi listami a chytavmi bodliakmi.'),(46,106,506,'Triticum aestivum (Penica letn) - Najroznejia obilnina sveta, zkladn surovina pre mku.'),(47,106,506,'Hordeum vulgare (Jame siaty) - Vznamn ponohospodrska plodina, zklad pre slad a vrobu piva.'),(48,106,506,'Secale cereale (Ra siata) - Odoln obilnina, pouvan na peenie tmavho ranho chleba.'),(49,106,506,'Avena sativa (Ovos siaty) - Obilnina bohat na vkninu, spracovan najm na ovsen vloky.'),(50,106,506,'Zea mays (Kukurica siata) - Vysok mohutn trva pochdzajca zo Strednej Ameriky.'),(51,106,506,'Oryza sativa (Rya siata) - Polovodn kultrna trva, hlavn energetick zloka stravy v zii.'),(52,106,506,'Poa pratensis (Lipnica lna) - Ben trvca trva tvoriaca zklad kvalitnch parkovch trvnikov.'),(53,107,507,'Pisum sativum (Hrch siaty) - Strukovina s vysokm obsahom bielkovn pestovan v zhradch.'),(54,107,507,'Phaseolus vulgaris (Fazua zhradn) - Plodina s popnavou stonkou, konzumuje sa ako struk alebo zrno.'),(55,107,507,'Lens culinaris (oovka kuchynsk) - Star kultrna plodina, rchlo strviten strukovina.'),(56,107,507,'Glycine max (Soja faulov / Sja) - Priemyseln kov strukovina s extrmnym podielom protenov.'),(57,107,507,'Trifolium pratense (atelina lna) - Vznamn krmovino, obohacuje pdu o dusk vaka symbiotickm baktrim.'),(58,107,507,'Medicago sativa (Lucerna siata) - Hlboko koreniaca krmovina, mimoriadne odoln voi suchu.'),(59,107,507,'Arachis hypogaea (Podzemnica olejn) - Rastlina, ktorej plody (araidy) dozrievaj netradine pod zemou.'),(60,101,501,'Rosa rugosa (Rua vrskav) - Odoln okrasn ker s vemi jedlmi pkami a voavmi kvetmi.');
/*!40000 ALTER TABLE `plants` ENABLE KEYS */;
UNLOCK TABLES;
SET @@SESSION.SQL_LOG_BIN = @MYSQLDUMP_TEMP_LOG_BIN;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-07-14  1:19:05
