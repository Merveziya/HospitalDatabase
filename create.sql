IF DB_ID('Hastane_Otomasyon') IS NOT NULL

   BEGIN 
       ALTER DATABASE [Hastane_Otomasyon] SET SINGLE_USER WITH ROLLBACK IMMEDIATE 
	   USE master
	   DROP DATABASE Hastane_Otomasyon
	END
GO

CREATE DATABASE Hastane_Otomasyon

     
GO
 USE Hastane_Otomasyon
 CREATE TABLE TBLIL
(
   IL_ID CHAR(2) PRIMARY KEY,
   ISIM VARCHAR(20) NOT NULL
)
 GO
 CREATE TABLE TBLILCE 
 (
   ILCE_ID INT IDENTITY(1,1) PRIMARY KEY,
   ISIM VARCHAR(20) NOT NULL,
   IL_ID CHAR(2) FOREIGN KEY REFERENCES TBLIL(IL_ID) 
           ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,  
)  
GO 
CREATE TABLE TBLKANGRUBU
(
    KAN_ID INT IDENTITY(1,1) PRIMARY KEY,
    KAN_ISIM VARCHAR(10) NOT NULL,
)

GO 
CREATE TABLE TBLHASTA
(
   TC CHAR(11) CONSTRAINT CHKTC CHECK(TC LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]') NOT NULL PRIMARY KEY,
   ISIM VARCHAR(20) NOT NULL,
   SOYISIM VARCHAR(20) NOT NULL,
   TELNO VARCHAR(11)UNIQUE CONSTRAINT CHKTELNO CHECK(TELNO LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]') NOT NULL,
   KILO FLOAT,
   BOY FLOAT,
   CINSIYET BIT NOT NULL,
   DOGUM_TARIHI DATETIME,
   YAS AS DATEDIFF(yy,DOGUM_TARIHI,GETDATE()),
   KAN_ID INT FOREIGN KEY REFERENCES TBLKANGRUBU(KAN_ID) NOT NULL,
   IL_ID CHAR(2) FOREIGN KEY REFERENCES TBLIL(IL_ID) NOT NULL,  
   ILCE_ID INT FOREIGN KEY REFERENCES TBLILCE(ILCE_ID) NOT NULL,  
)
GO 
CREATE TABLE TBLALERJI
(
    ALERJIID INT IDENTITY(1,1) PRIMARY KEY,
	ALERJI_ISIM VARCHAR(30) NOT NULL,
)
GO
CREATE TABLE TBLHASTA_ALERJILERI
(
    HASTA_ALERJISIID INT IDENTITY(1,1) PRIMARY KEY,
	ALERJIID INT FOREIGN KEY REFERENCES TBLALERJI(ALERJIID) NOT NULL,
	TC CHAR(11) FOREIGN KEY REFERENCES TBLHASTA(TC) NOT NULL,
)
GO
CREATE TABLE TBLRANDEVU
(
    RANDEVU_ID INT IDENTITY(1,1) PRIMARY KEY,
	HASTA_GELIS_TARIHI DATE NOT NULL, 
	HASTA_GELIS_SAATI TIME NOT NULL,
	RANDEVU_TURU VARCHAR(30),
	TC CHAR(11) FOREIGN KEY REFERENCES TBLHASTA(TC) NOT NULL, 
)
GO 
CREATE TABLE TBLTAHLIL
(
   TAHLIL_ID INT IDENTITY(1,1) PRIMARY KEY,
   TAHLIL_ISIM VARCHAR(100) NOT NULL,
)
GO 
CREATE TABLE TBLTAHLIL_TUR
(
    TAHLIL_TUR_ID INT IDENTITY(1,1) PRIMARY KEY,
    TAHLIL_TUR_ISIM VARCHAR(100) NOT NULL,
	TAHLIL_FIYAT MONEY NOT NULL,
	MIN_DEGER FLOAT NOT NULL,
	MAX_DEGER FLOAT NOT NULL,
	TAHLIL_ID INT FOREIGN KEY REFERENCES TBLTAHLIL(TAHLIL_ID) NOT NULL,
)
GO 
CREATE TABLE TBLRANDEVUNUN_TAHLILI
(
   RANDEVU_TAHLILI_ID INT IDENTITY(1,1) PRIMARY KEY,
   RANDEVU_ID INT FOREIGN KEY REFERENCES TBLRANDEVU(RANDEVU_ID) NOT NULL,
   TAHLIL_ID INT FOREIGN KEY REFERENCES TBLTAHLIL(TAHLIL_ID) NOT NULL,
)
GO
CREATE TABLE TBLRANDEVUNUN_TAHLIL_CESIDI
(
   RANDEVU_TAHLIL_CESIDI_ID INT IDENTITY(1,1) PRIMARY KEY,
   SONUC VARCHAR(30) NOT NULL,
   RANDEVU_ID INT FOREIGN KEY REFERENCES TBLRANDEVU(RANDEVU_ID) NOT NULL,
   TAHLIL_TUR_ID  INT FOREIGN KEY REFERENCES TBLTAHLIL_TUR(TAHLIL_TUR_ID ) NOT NULL,
)
GO 
CREATE TABLE TBLRECETE
(
    RECETE_ID INT IDENTITY(1,1) PRIMARY KEY,
	SON_GECERLILIK_TARIH DATE NOT NULL,
	RECETE_KODU VARCHAR(10) UNIQUE NOT NULL,
	YAZILDIGI_TARIH DATE NOT NULL,
	RANDEVU_ID  INT FOREIGN KEY REFERENCES TBLRANDEVU(RANDEVU_ID ) NOT NULL,
)
GO 
CREATE TABLE TBLPERIYOT
(
  PERIYOT_ID INT IDENTITY(1,1) PRIMARY KEY,
  PERIYOT_ADI VARCHAR(15) NOT NULL,
)
GO 
CREATE TABLE TBLETKEN_MADDE
(
   ETKEN_MADDE_ID INT IDENTITY(1,1) PRIMARY KEY,
   ETKEN_MADDE_ISMI VARCHAR(20),
)
GO 
CREATE TABLE TBLILAC
(
   ILAC_ID INT IDENTITY(1,1) PRIMARY KEY,
   ILAC_ISMI VARCHAR(20) UNIQUE NOT NULL,
   ILAC_FORMU VARCHAR(15)NOT NULL,
   YAN_ETKILERI VARCHAR(100)NOT NULL,
   BARKOD_NO VARCHAR(10)UNIQUE NOT NULL,
   FIYAT MONEY NOT NULL,
   KULLANIM_YASI INT NOT NULL,
   ETKEN_MADDE_ID INT FOREIGN KEY REFERENCES TBLETKEN_MADDE(ETKEN_MADDE_ID) NOT NULL,
)
GO 
CREATE TABLE TBLRECETE_ILAC_PERIYOT
( 
   RECETE_ILAC_PERIYOT_ID INT IDENTITY(1,1) PRIMARY KEY,
   DOZ FLOAT NOT NULL,
   KULLANIM_SIKLIGI INT NOT NULL,
   RECETE_ID INT FOREIGN KEY REFERENCES TBLRECETE(RECETE_ID ) NOT NULL,
   ILAC_ID  INT FOREIGN KEY REFERENCES TBLILAC(ILAC_ID) NOT NULL,
   PERIYOT_ID  INT FOREIGN KEY REFERENCES TBLPERIYOT(PERIYOT_ID) NOT NULL,
)
GO
CREATE TABLE TBLTESHIS
(
   TESHIS_ID INT IDENTITY(1,1) PRIMARY KEY,
   TESHIS_ISMI VARCHAR(20) NOT NULL,
)
GO
CREATE TABLE TBLHASTANE 
(
   HASTANE_ID INT IDENTITY(1,1) PRIMARY KEY,
   HASTANE_ISIM VARCHAR(100) NOT NULL,
   HASTANE_TURU VARCHAR(100) NOT NULL,
   IL_ID CHAR(2) FOREIGN KEY REFERENCES TBLIL(IL_ID) NOT NULL,    
)
GO
CREATE TABLE TBLPOLIKLINIK
(
  POLIKLINIK_ID INT IDENTITY(1,1) PRIMARY KEY,
  POLIKLINIK_ISIM VARCHAR(100) NOT NULL,
)

GO 
CREATE TABLE TBLHASTANE_POLIKLINIGI
(
  HASTANE_POLIKLINIGI_ID INT IDENTITY(1,1) PRIMARY KEY,
  HASTANE_POLIKLINIGI_ISMI VARCHAR(100) NOT NULL,
  ODA_NO INT,
  KAT_NO INT,
  HASTANE_ID INT FOREIGN KEY REFERENCES TBLHASTANE(HASTANE_ID) NOT NULL,
  POLIKLINIK_ID  INT FOREIGN KEY REFERENCES TBLPOLIKLINIK(POLIKLINIK_ID ) NOT NULL,
  )
  GO
  CREATE TABLE TBLHASTANENIN_POLIKLINIGI
  (
     HASTANENIN_POLIKLINIGI_ID INT IDENTITY(1,1) PRIMARY KEY,
	 HASTANE_ID INT FOREIGN KEY REFERENCES TBLHASTANE(HASTANE_ID) NOT NULL,
     POLIKLINIK_ID  INT FOREIGN KEY REFERENCES TBLPOLIKLINIK(POLIKLINIK_ID ) NOT NULL,
  )

 GO
 CREATE TABLE TBLPERSONEL_TURU
 (   PERSONEL_TURU_ID INT IDENTITY(1,1) PRIMARY KEY,
   PERSONEL_TURU_ISIM VARCHAR(100) NOT NULL,
 )
GO
CREATE TABLE TBLBRANS
(
   BRANS_ID INT IDENTITY(1,1) PRIMARY KEY,
   BRANS_ISIM VARCHAR(100) NOT NULL,
)
GO
CREATE TABLE TBLUNVAN
(
   UNVAN_ID INT IDENTITY(1,1) PRIMARY KEY,
   UNVAN_ISIM VARCHAR(100) NOT NULL,
)
GO 
CREATE TABLE TBLPERSONEL
(
   PERSONEL_ID INT IDENTITY(1,1) PRIMARY KEY,
   TC CHAR(11) UNIQUE CONSTRAINT CHKTC2 CHECK(TC LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')NOT NULL,
   ISIM VARCHAR(20) NOT NULL,
   SOYISIM VARCHAR(20) NOT NULL,
   TELNO VARCHAR(11) UNIQUE CONSTRAINT CHKTELNO2 CHECK(TELNO LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')NOT NULL,
   CINSIYET BIT NOT NULL,
   İSE_BASLANGIC_TARIHI DATE NOT NULL,
   DOGUM_TARIHI DATE NOT NULL,
   IL_ID CHAR(2) FOREIGN KEY REFERENCES TBLIL(IL_ID) NOT NULL,  
   ILCE_ID INT FOREIGN KEY REFERENCES TBLILCE(ILCE_ID) NOT NULL,  
   HASTANE_ID INT FOREIGN KEY REFERENCES TBLHASTANE(HASTANE_ID) NOT NULL,  
   PERSONEL_TURU_ID INT FOREIGN KEY REFERENCES TBLPERSONEL_TURU(PERSONEL_TURU_ID) NOT NULL,
   UNVAN_ID INT FOREIGN KEY REFERENCES TBLUNVAN(UNVAN_ID) NOT NULL,
   BRANS_ID INT FOREIGN KEY REFERENCES TBLBRANS(BRANS_ID) NOT NULL,
)
GO
CREATE TABLE TBLAMELIYAT
(
   AMELIYAT_ID INT IDENTITY(1,1) PRIMARY KEY,
   AMELIYAT_ISMI VARCHAR(20),
   AMELIYAT_TARIHI DATE,
   AMELIYAT_SAATI TIME,
   TC CHAR(11) FOREIGN KEY REFERENCES TBLHASTA(TC) NOT NULL,
   PERSONEL_ID INT FOREIGN KEY REFERENCES TBLPERSONEL(PERSONEL_ID) NOT NULL,
)
GO 
CREATE TABLE TBLRANDEVU_TESHISI
(
   RANDEVU_TESHISI_ID INT IDENTITY(1,1) PRIMARY KEY,
   RANDEVU_TESHISI_ISMI VARCHAR(100),
   RANDEVU_ID INT FOREIGN KEY REFERENCES TBLRANDEVU(RANDEVU_ID) NOT NULL,
   TESHIS_ID INT FOREIGN KEY REFERENCES  TBLTESHIS(TESHIS_ID) NOT NULL,
   AMELIYAT_ID INT FOREIGN KEY REFERENCES TBLAMELIYAT(AMELIYAT_ID),
   HASTANE_ISIM_ID INT FOREIGN KEY REFERENCES TBLHASTANE(HASTANE_ID) NOT NULL,
)
GO 
CREATE TABLE TBLCALISMA_TAKVIMI
(
   CALISMA_TAKVIMI_ID INT IDENTITY(1,1) PRIMARY KEY,
   CALISMA_TAKVIMI_TARIHI DATE NOT NULL,
   CALISMA_TAKVIMI_SAATI TIME NOT NULL,
   RANDEVU_ID INT FOREIGN KEY REFERENCES TBLRANDEVU(RANDEVU_ID) NOT NULL,
   PERSONEL_ID INT FOREIGN KEY REFERENCES TBLPERSONEL(PERSONEL_ID) NOT NULL,
   HASTANE_POLIKLINIGI_ID INT FOREIGN KEY REFERENCES TBLHASTANE_POLIKLINIGI(HASTANE_POLIKLINIGI_ID) NOT NULL,
)
INSERT INTO TBLIL VALUES
('01','Adana'),('02','Adıyaman'),('03','Afyonkarahisar'),('04','Ağrı'),('05','Amasya'),('06','Ankara'),('07','Antalya'),('08','Artvin'),('09','Aydın'),('10','Balıkesir'),
('11','Bilecik'),('12','Bingöl'),('13','Bitlis'),('14','Bolu'),('15','Burdur'),('16','Bursa'),('17','Çanakkale'),('18','Çankırı'),('19','Çorum'),('20','Denizli'),
('21','Diyarbakır'),('22','Edirne'),('23','Elazığ'),('24','Erzincan'),('25','Erzurum'),('26','Eskişehir'),('27','Gaziantep'),('28','Giresun'),('29','Gümüşhane'),
('30','Hakkâri'),('31','Hatay'),('32','Isparta'),('33','Mersin'),('34','İstanbul'),('35','İzmir'),('36','Kars'),('37','Kastamonu'),('38','Kayseri'),('39','Kırklareli'),
('40','Kırşehir'),('41','Kocaeli'),('42','Konya'),('43','Kütahya'),('44','Malatya'),('45','Manisa'),('46','Kahramanmaraş'),('47','Mardin'),('48','Muğla'),('49','Muş'),
('50','Nevşehir'),('51','Niğde'),('52','Ordu'),('53','Rize'),('54','Sakarya'),('55','Samsun'),('56','Siirt'),('57','Sinop'),('58','Sivas'),('59','Tekirdağ'),('60','Tokat'),
('61','Trabzon'),('62','Tunceli'),('63','Şanlıurfa'),('64','Uşak'),('65','Van'),('66','Yozgat'),('67','Zonguldak'),('68','Aksaray'),('69','Bayburt'),('70','Karaman'),('71','Kırıkkale'),('72','Batman'),('73','Şırnak'),
('74','Bartın'),('75','Ardahan'),('76','Iğdır'),('77','Yalova'),('78','Karabük'),('79','Kilis'),('80','Osmaniye'),('81','Düzce');

INSERT INTO TBLILCE (ISIM, IL_ID)
VALUES 
('Akyurt', '06'),
('Altındağ', '06'),
('Ayaş', '06'),
('Bala', '06'),
('Beypazarı', '06'),
('Çamlıdere', '06'),
('Çankaya', '06'),
('Çubuk', '06'),
('Elmadağ', '06'),
('Konak', '35'),
('Bornova', '35'),
('Urla', '35'),
('Menemen', '35'),
('Çeşme', '35'),
('Bayraklı', '35'),
('Bodrum', '48'),
('Marmaris', '48'),
('Fethiye', '48'),
('Milas', '48'),
('Köyceğiz', '48'),
('Akkuş', '52'),
('Merkez', '52'),
('Aybastı', '52'),
('Fatsa', '52'),
('Gölköy', '52'),
('Guzelyurt', '68'),
('Gulagac', '68'),
('Sultanhanı', '68'),
('Sarıyahsı', '68'),
('Merkez', '77'),
('Altınova', '77'),
('Armutlu', '77'),
('Çınarcık', '77'),
('Çiftlikköy', '77'),
('Termal', '77');

INSERT INTO TBLKANGRUBU (KAN_ISIM)
VALUES ('A Rh+'),('B Rh+'),('AB Rh+'),('O Rh+'),('A Rh-'),('B Rh-'),('AB Rh-'),('O Rh-');


INSERT INTO TBLHASTA (TC, ISIM, SOYISIM, TELNO, KILO, BOY, CINSIYET, DOGUM_TARIHI, KAN_ID, IL_ID, ILCE_ID) 
VALUES 
('12345678901', 'Pınar', 'Akpınar', '05343167213', 54, 158, 1, '1973-04-21', 1, '68', 1),
('12345678902', 'Ahmet', 'Yılmaz', '05551234567', 70, 175, 0, '1990-05-10', 1, '77', 1),
('12345678903', 'Kayra', 'Sönmez', '05435837327', 50, 165, 1, '2000-06-09', 4, '77', 4),
('12345678904', 'Elif', 'Polat', '05371237467', 50, 160, 1, '1998-04-03', 2, '06', 3),
('12345678905', 'Ahmet', 'Çelik', '05558901235', 80, 180,0, '1997-09-20', 1, '77', 4),
('12345678906', 'Ali', 'Aydın', '05558901234', 70, 175, 0, '1994-04-30', 3, '48', 2),
('12345678907', 'Ayşenur', 'Öztürk','05557890123', 55, 165, 1, '2000-07-25', 4, '77', 4),
('12345678908', 'Zeynep', 'Demir', '05432219224', 60, 165, 1, '1985-09-12', 3, '77', 2),
('12345678909', 'Mehmet', 'Kaya', '05347896541', 90, 185, 0, '1982-03-05', 2, '77', 6),
('12345678910', 'Gizem', 'Aydın', '05561234567', 55, 160, 1, '1995-08-17', 4, '35', 9),
('12345678911', 'Can', 'Yıldız', '05431234567', 75, 178, 0, '1993-11-28', 1, '77', 19),
('12345678912', 'Selin', 'Arslan', '05553216548', 62, 170, 1, '1999-02-10', 2, '48', 17),
('12345678913', 'Emre', 'Korkmaz', '05358741236', 80, 182, 0, '1990-07-07', 3, '77', 23),
('12345678914', 'Seda', 'Erdem', '05442317890', 58, 163, 1, '1996-06-15', 1, '77', 22),
('12345678915', 'Berk', 'Koç', '05347856234', 70, 175, 0, '1994-09-03', 4, '68', 26),
('12345678916', 'Ece', 'Toprak', '05558904321', 65, 168, 1, '1997-03-25', 2, '77', 27),
('12345678917', 'Mert', 'Çelik', '05348765432', 85, 180, 0, '1988-12-18', 3, '77', 31);

INSERT INTO TBLALERJI (ALERJI_ISIM) VALUES
('Yiyecek Alerjisi'),
('Pollen Alerjisi'),
('Hayvan Alerjisi'),
('İlaç Alerjisi'),
('Toz Alerjisi'),
('Latex Alerjisi'),
('Arı Sokması Alerjisi'),
('Kozmetik Alerjisi'),
('Mantar Alerjisi'),
('Güneş Alerjisi'),
('Soğuk Alerjisi'),
('Su Alerjisi'),
('Metaller Alerjisi'),
('Parfüm Alerjisi'),
('Kabarık Alerjisi'),
('Lateks Alerjisi'),
('Pamuk Alerjisi'),
('Yün Alerjisi'),
('Deri Alerjisi'),
('Ev Tozu Alerjisi');

INSERT INTO TBLHASTA_ALERJILERI (ALERJIID, TC)
VALUES
(1, '12345678901'),
(8, '12345678901'),
(3, '12345678902'),
(2, '12345678903'),
(4, '12345678904'),
(3, '12345678905'),
(11, '12345678906'),
(4, '12345678907'),
(7, '12345678908'),
(3, '12345678909'),
(5, '12345678910'),
(4, '12345678911'),
(2, '12345678912'),
(10, '12345678913'),
(3, '12345678914'),
(4, '12345678915'),
(6, '12345678916'),
(2, '12345678917');


INSERT INTO TBLRANDEVU (HASTA_GELIS_TARIHI, HASTA_GELIS_SAATI, RANDEVU_TURU, TC)
VALUES
('2022-01-07', '10:15:00', 'Muayene', '12345678908'),
('2022-05-28', '09:30:00', 'Kontrol', '12345678908'),
('2022-06-02', '11:45:00', 'Muayene', '12345678909'),
('2022-06-07', '10:15:00', 'Muayene', '12345678910'),
('2022-06-12', '15:45:00', 'Muayene', '12345678911'),
('2022-06-15', '10:00:00', 'Muayene', '12345678912'),
('2022-06-17', '11:30:00', 'Kontrol', '12345678909'),
('2022-06-25', '12:30:00', 'Kontrol', '12345678912'),
('2022-07-01', '11:45:00', 'Muayene', '12345678914'),
('2022-07-07', '10:30:00', 'Muayene', '12345678916'),
('2022-09-02', '11:45:00', 'Muayene', '12345678910'),

('2022-05-28', '09:30:00', 'Kontrol', '12345678901'),
('2022-05-30', '14:00:00', 'Muayene', '12345678902'),
('2022-05-30', '14:00:00', 'Muayene', '12345678903'),
('2022-06-02', '11:45:00', 'Muayene', '12345678904'),
('2022-06-05', '16:30:00', 'Kontrol', '12345678905'),
('2022-06-05', '16:30:00', 'Kontrol', '12345678906'),
('2022-06-10', '13:30:00', 'Kontrol', '12345678907'),


('2023-05-28', '09:30:00', 'Kontrol', '12345678901'),
('2023-05-30', '14:00:00', 'Muayene', '12345678902'),
('2023-05-30', '14:00:00', 'Muayene', '12345678903'),
('2023-06-02', '11:45:00', 'Muayene', '12345678904'),
('2023-06-05', '16:30:00', 'Kontrol', '12345678905'),
('2023-06-05', '16:30:00', 'Kontrol', '12345678906'),
('2023-06-10', '13:30:00', 'Kontrol', '12345678907'),

('2023-05-28', '09:00:00', 'Kontrol', '12345678908'),
('2023-07-30', '14:30:00', 'Muayene', '12345678916'),
('2023-08-30', '14:30:00', 'Muayene', '12345678911'),
('2023-09-02', '11:55:00', 'Muayene', '12345678912'),
('2023-10-05', '16:40:00', 'Kontrol', '12345678913'),
('2023-11-05', '16:40:00', 'Kontrol', '12345678914'),
('2023-08-10', '13:50:00', 'Kontrol', '12345678908'),
('2023-02-28', '09:00:00', 'Kontrol', '12345678910'),
('2023-03-30', '14:30:00', 'Muayene', '12345678909'),
('2023-10-30', '14:30:00', 'Muayene', '12345678911'),
('2023-12-02', '11:55:00', 'Muayene', '12345678912'),
('2023-06-05', '16:40:00', 'Kontrol', '12345678913'),
('2023-05-05', '16:40:00', 'Kontrol', '12345678914'),
('2023-04-10', '13:50:00', 'Kontrol', '12345678917');






INSERT INTO TBLTAHLIL (TAHLIL_ISIM) VALUES
('Kan Sayımı'),
('Biyokimya Paneli'),
('Hormon Profili'),
('İdrar Tahlili'),
('Gaita Tahlili'),
('Kan Grubu Testi'),
('Koagülasyon Testi'),
('Kan Uyumu Testi'),
('Kanser Antijenleri'),
('Hepatit Testleri'),
('Kalp Enzimleri'),
('Tiroid Fonksiyon Testleri'),
('Kolesterol Testi'),
('Glikoz Tolerans Testi'),
('Covid-19 PCR Testi'),
('Kemik Yoğunluğu Ölçümü'),
('Allerji Testleri'),
('Pap Smear Testi'),
('PSA Testi'),
('EKG (Elektrokardiogram)'),
('Tiroit Antikorları Testi'),
('B12 Vitamini Testi'),
('Troponin Testi'),
('Glikoz Testi'),
('Üre Testi'),
('Lipid Profili'),
('ALT (Alanin Aminotransferaz) Testi'),
('AST (Aspartat Aminotransferaz) Testi'),
('Ferritin Testi'),
('Kreatinin Testi'),
('Ürik Asit Testi'),
('TSH (Tiroid Uyarıcı Hormon) Testi'),
('VDRL Testi'),
('Hemoglobin A1c (HbA1c) Testi'),
('Rutin İdrar Testi'),
('Trombosit Sayımı'),
('Protein Testi'),
('Kalsiyum Testi');

INSERT INTO TBLTAHLIL_TUR (TAHLIL_TUR_ISIM, TAHLIL_FIYAT, MIN_DEGER, MAX_DEGER, TAHLIL_ID) VALUES
('Kan Sayımı - Tam Kan Sayımı', 150.00, 4, 10.00, 1),
('Biyokimya Paneli - Glukoz', 80, 70, 100.00, 2),
('Biyokimya Paneli - Kolesterol', 120, 0, 200, 2),
('Biyokimya Paneli - Karaciğer Enzimleri', 180.00, 0.0, 50.0, 2),
('Hormon Profili - TSH', 100.00, 0.4, 4.0, 3),
('Hormon Profili - T3', 120.00, 80.0, 200.0, 3),
('Hormon Profili - T4', 110.00, 4.5, 12.0, 3),
('İdrar Tahlili - pH', 50.00, 4.6, 8.0, 4),
('İdrar Tahlili - Yoğunluk', 70.00, 1.001, 1.030, 4),
('Koagülasyon Testi - PT', 130.00, 11.0, 14.0, 7),
('Koagülasyon Testi - APTT', 140.00, 25.0, 40.0, 7),
('Koagülasyon Testi - INR', 120.00, 0.8, 1.2, 7),
('Kanser Antijenleri - PSA', 150.00, 0.0, 4.0, 9),
('Kanser Antijenleri - CA 125', 160.00, 0.0, 35.0, 9),
('Kalp Enzimleri - CK', 100.00, 30.0, 200.0, 11),
('Kalp Enzimleri - CK-MB', 110.00, 0.0, 24.0, 11),
('Kalp Enzimleri - Troponin I', 120.00, 0.0, 0.1, 11),
('Tiroid Fonksiyon Testleri - TSH', 100.00, 0.4, 4.0, 12),
('Tiroid Fonksiyon Testleri - T3', 120.00, 80.0, 200.0, 12),
('Tiroid Fonksiyon Testleri - T4', 110.00, 4.5, 12.0, 12),
('Kolesterol Testi - Total Kolesterol', 80.00, 0.0, 200.0, 13),
('Kolesterol Testi - HDL', 90.00, 40.0, 60.0, 13),
('Kolesterol Testi - LDL', 100.00, 0.0, 130.0, 13);


INSERT INTO TBLRANDEVUNUN_TAHLILI (RANDEVU_ID, TAHLIL_ID)
VALUES (1, 1),(2, 3),(3, 2),(4, 1),(5, 4),(1, 1),(2, 3),(3, 2),(4, 1),(5, 4),(6, 2),
(7, 3),(8, 4),(9, 1),(10, 2),(11, 3),(12, 4),(13, 1),(14, 2),(15, 3),(16, 4),(17, 1);


INSERT INTO TBLRANDEVUNUN_TAHLIL_CESIDI (SONUC, RANDEVU_ID, TAHLIL_TUR_ID)
VALUES 
('Normal', 1, 1),
('Yüksek', 2, 3),
('Negatif', 3, 2),
('Pozitif', 4, 1),
('Normal', 5, 4),
('Yüksek', 2, 3),
('Negatif', 3, 2),
('Pozitif', 4, 1),
('Normal', 5, 4),
('Negatif', 6, 2),
('Yüksek', 7, 3),
('Pozitif', 8, 4),
('Normal', 9, 1),
('Negatif', 10, 2),
('Yüksek', 11, 3),
('Pozitif', 12, 4),
('Normal', 13, 1),
('Yüksek', 14, 2),
('Negatif', 15, 3),
('Pozitif', 16, 4),
('Normal', 17, 1);

INSERT INTO TBLRECETE (SON_GECERLILIK_TARIH, RECETE_KODU, YAZILDIGI_TARIH, RANDEVU_ID)
VALUES 
('2023-06-01', 'RC123', '2023-05-30', 1),
('2023-06-05', 'RC456', '2023-06-03', 2),
('2023-06-10', 'RC789', '2023-06-08', 3),
('2023-06-15', 'RC012', '2023-06-12', 4),
('2023-06-20', 'RC345', '2023-06-18', 5),
('2023-06-25', 'RC678', '2023-06-22', 6),
('2023-06-30', 'RC981', '2023-06-28', 7),
('2023-07-05', 'RC234', '2023-07-02', 8),
('2023-07-10', 'RC567', '2023-07-08', 9),
('2023-07-15', 'RC890', '2023-07-12', 10),
('2023-07-20', 'RC124', '2023-07-18', 11),
('2023-07-25', 'RC459', '2023-07-22', 12),
('2023-07-30', 'RC719', '2023-07-28', 13),
('2023-08-05', 'RC912', '2023-08-02', 14),
('2023-08-10', 'RC305', '2023-08-08', 15),
('2023-08-15', 'RC143', '2023-08-12', 16),
('2023-08-20', 'RC901', '2023-08-18', 17);


INSERT INTO TBLPERIYOT (PERIYOT_ADI)
VALUES ('Günlük'),
       ('Haftalık'),
       ('Aylık'),
       ('Yıllık');

INSERT INTO TBLETKEN_MADDE (ETKEN_MADDE_ISMI)
VALUES 
('Parasetamol'),
('İbuprofen'),
('Aspirin'),
('Lisinopril'),
('Metformin'),
('Asetaminofen'),
('Naproksen'),
('Diklofenak'),
('Amlodipin'),
('Atorvastatin'),
('Simvastatin'),
('Omeprazol'),
('Pantoprazol'),
('Amoksisilin'),
('Azitromisin'),
('Levofloksasin'),
('Metoprolol'),
('Losartan'),
('Sertralin'),
('Escitalopram'),
('Gabapentin'),
('Pregabalin'),
('Metoklopramid'),
('Ranitidin'),
('Ketoprofen'),
('Propranolol'),
('Furosemid'),
('Metronidazol'),
('Prednizon'),
('Levothyroxine'),
('Methotrexate'),
('Duloksetin');


INSERT INTO TBLILAC (ILAC_ISMI, ILAC_FORMU, YAN_ETKILERI, BARKOD_NO, FIYAT, KULLANIM_YASI, ETKEN_MADDE_ID)
VALUES
('Parol', 'Tablet', 'Baş ağrısı, mide bulantısı', '1234567890', 12.99, 12, 1),
('İbuprofen', 'Kapsül', 'Mide rahatsızlığı, karın ağrısı', '9876543210', 19.99, 18, 2),
('Aspirin', 'Tablet', 'Mide yanması, mide kanaması', '5678901234', 9.99, 16, 3),
('Lisinopril', 'Tablet', 'Baş dönmesi, öksürük', '8901234567', 14.99, 20, 5),
('Kodein', 'Tablet', 'Öksürük kesici, ağrı kesici', '3456789012', 8.99, 10, 6),
('Ranitidin', 'Tablet', 'Hazımsızlık, mide ekşimesi', '9012345678', 11.99, 14, 7),
('Amoksisilin', 'Tablet', 'Enfeksiyonlar, bronşit', '4567890123', 17.99, 8, 8),
('Metformin', 'Tablet', 'Diyabet, kilo kaybı', '7890123456', 13.99, 24, 9),
('Parasetamol', 'Tablet', 'Ateş düşürücü, ağrı kesici', '0123456789', 7.99, 22, 10),
('Diazepam', 'Tablet', 'Anksiyete, uyku bozuklukları', '2468135790', 16.99, 15, 11),
('Omeprazol', 'Kapsül', 'Gastrit, mide ülseri', '1357902468', 10.99, 20, 12),
('Levotiroksin', 'Tablet', 'Hipotiroidizm, tiroid tedavisi', '8024681357', 18.99, 30, 8),
('Simvastatin', 'Tablet', 'Kolesterol kontrolü, kalp hastalıkları', '3679246801', 15.99, 28, 8),
('Fenilefrin', 'Damlası', 'Burun tıkanıklığı, alerjik rinit', '4681357920', 6.99, 10, 9),
('Prednizon', 'Tablet', 'Romatoid artrit, astım', '5792046813', 9.99, 16, 9),
('Cetirizin', 'Tablet', 'Alerjik reaksiyonlar, kaşıntı', '6801397924', 7.99, 20, 5),
('Metoprolol', 'Tablet', 'Yüksek tansiyon, kalp ritmi bozukluğu', '7914690235', 11.99, 24, 9),
('Atorvastatin', 'Tablet', 'Kolesterol kontrolü, koroner arter hastalığı', '9023519146', 14.99, 28, 6),
('Dekstrometorfan', 'Şurup', 'Öksürük kesici, boğaz ağrısı', '0135792468', 8.99, 12, 8),
('Metronidazol', 'Tablet', 'Enfeksiyonlar, diş enfeksiyonu', '1357924780', 12.99, 16, 5),
('Escitalopram', 'Tablet', 'Depresyon, anksiyete bozukluğu', '2468135785', 16.99, 30, 9),
('Diklofenak', 'Jel', 'Romatizmal ağrılar, kas zorlanmaları', '3579246801', 9.99, 20, 13),
('Salbutamol', 'İnhaler', 'Astım, solunum problemleri', '4681957920', 14.99, 14, 10),
('Furosemid', 'Tablet', 'Yüksek tansiyon, ödem', '6801357924', 11.99, 20, 3),
('Esomeprazol', 'Kapsül', 'Mide yanması, ülser', '7914680235', 15.99, 14, 11),
('Sildenafil', 'Tablet', 'Erektil disfonksiyon, cinsel performans', '9023579146', 18.99, 10, 7),
('Paroksetin', 'Tablet', 'Obsesif kompulsif bozukluk, panik bozukluk', '0175792468', 13.99, 30, 11),
('Losartan', 'Tablet', 'Yüksek tansiyon, böbrek hastalığı', '1357924680', 16.99, 18, 14);

INSERT INTO TBLRECETE_ILAC_PERIYOT (DOZ, KULLANIM_SIKLIGI, RECETE_ID, ILAC_ID, PERIYOT_ID)
VALUES
   (1.5, 3, 1, 1, 2),
   (2.0, 2, 2, 3, 1),
   (0.5, 1, 4, 2, 3),
   (1.0, 4, 4, 4, 2),
   (0.75, 2, 5, 5, 4),
   (1.5, 3, 5, 1, 2),
   (2.0, 2, 5, 6, 1),
   (0.5, 1, 8, 2, 3),
   (1.0, 4, 4, 4, 2),
   (0.75, 2, 5, 3, 4),
   (1.25, 3, 6, 6, 3),
   (1.5, 2, 7, 7, 1),
   (0.75, 1, 8, 8, 3),
   (1.0, 4, 9, 9, 2),
   (2.0, 2, 10, 10, 1),
   (1.5, 3, 11, 11, 2),
   (0.5, 1, 12, 12, 3),
   (1.25, 2, 13, 13, 4),
   (0.75, 4, 14, 14, 4),
   (1.5, 2, 15, 15, 1),
   (1.0, 1, 16, 16, 2),
   (0.5, 3, 17, 17, 3);

INSERT INTO TBLTESHIS (TESHIS_ISMI)
VALUES
('Grip'),
('Yüksek Tansiyon'),
('Şeker Hastalığı'),
('Astım'),
('Depresyon'),
('Bronşit'),
('Hipertansiyon'),
('Diyabet'),
('Obezite'),
('Böbrek Taşı'),
('Gastrit'),
('Akut Sinüzit'),
('Anksiyete Bozukluğu'),
('Depresyan'),
('Vertigo'),
('Alzheimer');

INSERT INTO TBLHASTANE (HASTANE_ISIM,HASTANE_TURU,IL_ID) VALUES
('Yalova Devlet Hastanesi','Devlet','77'),
('Üniversite Hastanesi','Üniversite', '77'),
('Eğitim Araştırma Hastanesi','Devlet','68'),                                                                                                       
('Eğitim Araştırma Hastanesi','Devlet','35');

INSERT INTO TBLPOLIKLINIK (POLIKLINIK_ISIM)
VALUES
('Genel Cerrahi'),
('Dahiliye'),
('Ortopedi'),
('Üroloji'),
('Nöroloji'),
('Kulak Burun Boğaz'),
('Dermatoloji'),
('Kadın Hastalıkları ve Doğum'),
('Çocuk Sağlığı ve Hastalıkları'),
('Göz Hastalıkları');

INSERT INTO TBLHASTANE_POLIKLINIGI (HASTANE_POLIKLINIGI_ISMI, ODA_NO, KAT_NO, HASTANE_ID, POLIKLINIK_ID)
VALUES
('Genel Cerrahi', 101, 1, 1, 1),
('Dahiliye', 201, 2, 2, 2),
('Ortopedi', 301, 3, 3, 3),
('Üroloji', 102, 1, 4, 4),
('Nöroloji', 202, 2, 4, 5),
('Kulak Burun Boğaz', 302, 3, 2, 6),
('Dermatoloji', 103, 1, 1, 7),
('Kadın Hastalıkları ve Doğum', 203, 2, 1, 8),
('Çocuk Sağlığı ve Hastalıkları', 303, 3, 1, 9),
('Göz Hastalıkları', 104, 1, 1, 10);

INSERT INTO TBLHASTANENIN_POLIKLINIGI (HASTANE_ID, POLIKLINIK_ID)
VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4);

INSERT INTO TBLPERSONEL_TURU (PERSONEL_TURU_ISIM)
VALUES
('Doktor'),
('Hemşire'),
('Laboratuvar Teknisyeni'),
('Teknik Personel'),
('Radyolog'),
('Fizyoterapist'),
('Eczacı'),
('Diş Hekimi'),
('Psikolog');

INSERT INTO TBLBRANS (BRANS_ISIM)
VALUES
('Genel Cerrahi'),
('Dahiliye'),
('Kadın Hastalıkları ve Doğum'),
('Ortopedi'),
('Göz Hastalıkları'),
('Kulak Burun Boğaz'),
('Çocuk Sağlığı ve Hastalıkları'),
('Nöroloji'),
('Kardiyoloji');

INSERT INTO TBLUNVAN (UNVAN_ISIM)
VALUES
('Uzman Doktor'),
('Başhekim'),
('Profesör'),
('Doçent'),
('Pratisyen Doktor'),
('Yardımcı Doçent'),
('Hemşire'),
('Eczacı'),
('Teknisyen'),
('Laboratuvar Teknisyeni'),
('Radyolog'),
('Fizyoterapist'),
('Psikolog');

INSERT INTO TBLPERSONEL (TC, ISIM, SOYISIM, TELNO, CINSIYET, İSE_BASLANGIC_TARIHI, DOGUM_TARIHI, IL_ID, ILCE_ID, HASTANE_ID, PERSONEL_TURU_ID, UNVAN_ID, BRANS_ID)
VALUES
('22345678901', 'Ahmet', 'Yılmaz', '05551234568', 0, '2020-01-01', '1990-05-10', '06', '1', 4, 1, 1, 1),
('22345678902', 'Ayşe', 'Kaya', '05341234575', 1, '2018-02-15', '1995-08-20', '77', '2', 2, 2, 5, 3),
('22345678903', 'Mehmet', 'Demir', '05432234667', 0, '2019-05-01', '1992-11-05', '77', '4', 3, 3, 3, 2),
('22345678904', 'Fatma', 'Yıldız', '05551224567', 1, '2022-03-10', '1988-07-12', '77', '5', 1, 4, 6, 4),
('22345678905', 'Ali', 'Öztürk', '05341237567', 0, '2021-06-20', '1996-04-03', '34', '3', 3, 1, 2, 5);

INSERT INTO TBLAMELIYAT (AMELIYAT_ISMI, AMELIYAT_TARIHI, AMELIYAT_SAATI, TC, PERSONEL_ID)
VALUES ('Ameliyat 1', '2023-05-28', '13:30:00', '12345678901', 1),
       ('Ameliyat 2', '2023-06-02', '09:00:00', '12345678902', 2),
       ('Ameliyat 3', '2023-06-05', '14:45:00', '12345678903', 3);

INSERT INTO TBLRANDEVU_TESHISI (RANDEVU_TESHISI_ISMI, RANDEVU_ID, TESHIS_ID, AMELIYAT_ID,HASTANE_ISIM_ID)
VALUES
('Teşhis-1', 1, 3, NULL,1),
('Teşhis-2', 2, 2, NULL,1),
('Teşhis-3', 3, 2, NULL,1),
('Teşhis-4', 4, 1, 1,1),
('Teşhis-5', 5, 2, NULL,1),
('Teşhis-6', 6, 3, NULL,1),
('Teşhis-7', 7, 3, NULL,1),
('Teşhis-8', 8, 3, 1,1),
('Teşhis-9', 9, 3, NULL,1),
('Teşhis-10', 10, 2, NULL,1),
('Teşhis-11', 11, 1, NULL,1),

('Teşhis-12', 12, 5, 1,1), 
('Teşhis-13', 13, 5, NULL,1),
('Teşhis-14', 14, 7, NULL,1),
('Teşhis-15', 15, 3, NULL,1),
('Teşhis-16', 16, 5, 1,1),
('Teşhis-17', 17, 6, NULL,1),
('Teşhis-18', 18, 8, NULL,1),

('Teşhis-19', 19, 10, NULL,1),
('Teşhis-20', 20, 6, 1,1),
('Teşhis-21', 21, 7, NULL,1),
('Teşhis-22', 22, 8, NULL,1),
('Teşhis-23', 23, 5, NULL,1),
('Teşhis-24', 24, 8, 1,1),
('Teşhis-25', 25, 9, 1,1),

('Teşhis-26', 26, 7, NULL,1),
('Teşhis-27', 27, 6, 1,1),
('Teşhis-28', 28, 7, NULL,1),
('Teşhis-29', 29, 8, NULL,1),
('Teşhis-30', 30, 8, NULL,1),
('Teşhis-31', 31, 8, 1,1),
('Teşhis-32', 32, 9, 1,1),
('Teşhis-33', 33, 10, NULL,1),
('Teşhis-34', 34, 9, 1,1),
('Teşhis-35', 35, 9, NULL,1),
('Teşhis-36', 36, 8, NULL,1),
('Teşhis-37', 37, 9, NULL,1),
('Teşhis-38', 38, 8, 1,2),
('Teşhis-39', 39, 9, 1,1);




INSERT INTO TBLCALISMA_TAKVIMI (CALISMA_TAKVIMI_TARIHI, CALISMA_TAKVIMI_SAATI, RANDEVU_ID, PERSONEL_ID, HASTANE_POLIKLINIGI_ID)
VALUES ('2023-05-28', '08:30:00', 1, 1, 1),
       ('2023-06-02', '14:00:00', 2, 2, 2),
       ('2023-06-05', '10:45:00', 3, 3, 3);

--Geçen yıl için en çok teşhis konulan ilk üç hastalığı almak için:
SELECT TOP 3 TESHIS_ISMI, COUNT(*) AS SAYI
FROM TBLRANDEVU_TESHISI
JOIN TBLTESHIS ON TBLRANDEVU_TESHISI.TESHIS_ID = TBLTESHIS.TESHIS_ID
JOIN TBLRANDEVU ON TBLRANDEVU_TESHISI.RANDEVU_ID = TBLRANDEVU.RANDEVU_ID
WHERE YEAR(TBLRANDEVU.HASTA_GELIS_TARIHI) = YEAR(GETDATE()) - 1
GROUP BY TESHIS_ISMI
ORDER BY SAYI DESC;

--Geçen yıl geçirilmeyen hastalıklara göre bu yıl şimdiye kadar geçirilen hastalıkları ve sayılarını almak için:
SELECT TESHIS_ISMI, COUNT(*) AS SAYI
FROM TBLRANDEVU_TESHISI
JOIN TBLTESHIS ON TBLRANDEVU_TESHISI.TESHIS_ID = TBLTESHIS.TESHIS_ID
JOIN TBLRANDEVU ON TBLRANDEVU_TESHISI.RANDEVU_ID = TBLRANDEVU.RANDEVU_ID
WHERE YEAR(TBLRANDEVU.HASTA_GELIS_TARIHI) = YEAR(GETDATE())
  AND TBLTESHIS.TESHIS_ID NOT IN (
      SELECT TESHIS_ID
      FROM TBLRANDEVU_TESHISI
      JOIN TBLRANDEVU ON TBLRANDEVU_TESHISI.RANDEVU_ID = TBLRANDEVU.RANDEVU_ID
      WHERE YEAR(TBLRANDEVU.HASTA_GELIS_TARIHI) = YEAR(GETDATE()) - 1
  )
GROUP BY TESHIS_ISMI
ORDER BY SAYI DESC;


--Yalova ilinde bu yıl şimdiye kadar geçirilen hastalıkları ve sayılarını almak için:
SELECT TESHIS_ISMI, COUNT(*) AS SAYI
FROM TBLRANDEVU_TESHISI
JOIN TBLTESHIS ON TBLRANDEVU_TESHISI.TESHIS_ID = TBLTESHIS.TESHIS_ID
JOIN TBLRANDEVU ON TBLRANDEVU_TESHISI.RANDEVU_ID = TBLRANDEVU.RANDEVU_ID
JOIN TBLHASTA ON TBLRANDEVU.TC = TBLHASTA.TC
JOIN TBLILCE ON TBLHASTA.ILCE_ID = TBLILCE.ILCE_ID
JOIN TBLIL ON TBLILCE.IL_ID = TBLIL.IL_ID
WHERE TBLIL.ISIM = 'Yalova'
  AND YEAR(TBLRANDEVU.HASTA_GELIS_TARIHI) = YEAR(GETDATE())
GROUP BY TESHIS_ISMI
ORDER BY SAYI DESC;