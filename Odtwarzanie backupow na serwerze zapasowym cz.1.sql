﻿--------------- ============ Kod zadania SQL Server Agenta

---Use master
---go 
---- drop TABLE #FilesCmdshell 
create TABLE #FilesCmdshell (  outputCmd NVARCHAR (500)) 
   
INSERT INTO #FilesCmdshell (outputCmd) 
EXEC master.sys.xp_cmdshell 'if not exist x:\*.* net use x: \\192.168.x.yyy\zasob /user:whatEver\user_zasob haslo';
----- musi być jakaś nazwa domenowa, dlatego jest "whatEver\"
DECLARE @backupy_kursor CURSOR 
declare @database_name as nvarchar(128)
declare @nazwa_bak as nvarchar(4000)
declare @nazwa_7z as nvarchar(4000)
declare @polecenie as nvarchar(4000)

set @backupy_kursor = cursor for select database_name,nazwa_bak,nazwa_7z from -------
megatron.testconfigPK.dbo.backupyAll 
where backup_finish_date>getdate()-1  and  database_name<>'sgrp2' and  database_name<>'master' and  database_name<>'model' and  database_name<>'msdb'   and  database_name<>'amlux'   and  database_name not like 'a%'  
------ OR database_name = 'ADINFO' ----- and  database_name<>'airpo'  and  database_name<>'alkom'  
order by backup_finish_date

declare @folder as nvarchar(10)
declare @czas0 as datetime
declare @czas1 as datetime
declare @czas2 as datetime
DECLARE @sqlRestore NVARCHAR(MAX)
set @folder= convert(nvarchar(7), getdate(), 120)

open @backupy_kursor
Fetch next from @backupy_kursor into @database_name,@nazwa_bak,@nazwa_7z

WHILE @@FETCH_STATUS=0
begin 
      set @czas0 = getdate()
      set @polecenie= '"D:\Program Files\7-Zip\7z.exe" e -phaslo x:\' + @folder + '\'+@nazwa_7z +' -oe:\backup\'
    INSERT INTO #FilesCmdshell (outputCmd) EXEC master.sys.xp_cmdshell @polecenie
---   select  * from #FilesCmdshell
      set @czas1 = getdate()
----- select @polecenie
---- ---- case
if @database_name='links'
begin
set @sqlRestore='RESTORE DATABASE [links] FROM  DISK = N''E:\Backup\'+@nazwa_bak+'''  WITH  FILE = 1,  
MOVE N''GPSLINKSDat.mdf'' TO N''D:\BAZY\GPSLINKSDat.mdf'',  MOVE N''GPSLINKSLog.ldf'' TO N''D:\BAZY\GPSLINKSLog.ldf'',      
NOUNLOAD,  REPLACE,  STATS = 10'
BEGIN TRY 
      EXEC(@sqlRestore) 
 END TRY  
 BEGIN CATCH 
      Insert into testpk.dbo.bledy select getdate(),@sqlRestore 
 END CATCH 
end
else 
    
    
if @database_name='sgrp2_gl30000'
begin
set @sqlRestore='RESTORE DATABASE [sgrp2_gl30000] FROM  DISK = N''E:\Backup\'+@nazwa_bak+'''  WITH  FILE = 1,  
MOVE N''sgrp2_gl30000'' TO N''D:\bazy\sgrp2_gl30000.mdf'',  MOVE N''sgrp2_gl30000_2'' TO N''D:\bazy\sgrp2_gl30000_2.ndf'',  
MOVE N''sgrp2_gl30000_log'' TO N''D:\bazy\sgrp2_gl30000_log.ldf'',  MOVE N''sgrp2_gl30000_log_2'' TO N''D:\bazy\sgrp2_gl30000_log_2.ldf'',  
NOUNLOAD,  REPLACE,  STATS = 10'
BEGIN TRY 
      EXEC(@sqlRestore) 
 END TRY  
 BEGIN CATCH 
      Insert into testpk.dbo.bledy select getdate(),@sqlRestore 
 END CATCH 
end
else 
if @database_name='MCG'
begin
set @sqlRestore='RESTORE DATABASE [MCG] FROM  DISK = N''E:\Backup\'+@nazwa_bak+'''  WITH  FILE = 1,  
MOVE N''GPSAOMSSDat.mdf'' TO N''D:\MCG.mdf'',  
MOVE N''GPSAOMSSLog.ldf'' TO N''D:\MCG_log.ldf'',  NOUNLOAD,  REPLACE,  STATS = 10'
BEGIN TRY 
      EXEC(@sqlRestore) 
 END TRY  
 BEGIN CATCH 
      Insert into testpk.dbo.bledy select getdate(),@sqlRestore 
 END CATCH 
end
else 

if @database_name='ALKOM'
begin
set @sqlRestore='RESTORE DATABASE [ALKOM] FROM  DISK = N''E:\Backup\'+@nazwa_bak+'''  WITH  FILE = 1,  
MOVE N''GPSCERBEDat.mdf'' TO N''D:\bazy\ALKOM.mdf'',  
MOVE N''GPSCERBELog.ldf'' TO N''D:\bazy\ALKOM_log.ldf'',  NOUNLOAD,  REPLACE,  STATS = 10'
BEGIN TRY 
      EXEC(@sqlRestore) 
 END TRY  
 BEGIN CATCH 
      Insert into testpk.dbo.bledy select getdate(),@sqlRestore 
 END CATCH 
end
else 
if @database_name='CERBE'
begin
set @sqlRestore='RESTORE DATABASE [CERBE] FROM  DISK = N''E:\Backup\'+@nazwa_bak+'''  WITH  FILE = 1,  
MOVE N''GPSCERBEDat.mdf'' TO N''D:\bazy\GPSCERBEDat.mdf'',  
MOVE N''GPSCERBELog.ldf'' TO N''D:\bazy\GPSCERBELog.ldf'',  NOUNLOAD,  REPLACE,  STATS = 10'
BEGIN TRY 
 EXEC(@sqlRestore) 
 END TRY  
   BEGIN CATCH 
  Insert into testpk.dbo.bledy select getdate(),@sqlRestore 
 END CATCH 
end
else 
if @database_name='fakturowanie__'
begin
set @sqlRestore='RESTORE DATABASE [fakturowanie__] FROM  DISK = N''E:\Backup\'+@nazwa_bak+'''  WITH  FILE = 1,  
MOVE N''FAKTURY'' TO N''D:\bazy\FAKTURY.mdf'',  
MOVE N''FAKTURY_log'' TO N''D:\bazy\FAKTURY_log.ldf'',  NOUNLOAD,  REPLACE,  STATS = 10'
BEGIN TRY 
 EXEC(@sqlRestore) 
 END TRY  
   BEGIN CATCH 
  Insert into testpk.dbo.bledy select getdate(),@sqlRestore 
 END CATCH 
end
else 
if @database_name='konserwacja'
begin
set @sqlRestore='RESTORE DATABASE [konserwacja] FROM  DISK = N''E:\Backup\'+@nazwa_bak+'''  WITH  FILE = 1,  
MOVE N''konserwacja'' TO N''D:\konserwacja.mdf'',  
MOVE N''konserwacja_log'' TO N''D:\konserwacja_log.ldf'',  NOUNLOAD,  REPLACE,  STATS = 10'
BEGIN TRY 
 EXEC(@sqlRestore) 
 END TRY  
   BEGIN CATCH 
  Insert into testpk.dbo.bledy select getdate(),@sqlRestore 
 END CATCH 
end
else 
if @database_name='OCHRONA'
begin
set @sqlRestore='RESTORE DATABASE [OCHRONA] FROM  DISK = N''E:\Backup\'+@nazwa_bak+'''  WITH  FILE = 1,  
MOVE N''OCHRONA'' TO N''D:\bazy\OCHRONA.mdf'',  
MOVE N''OCHRONA_log'' TO N''D:\BAZY\OCHRONA_log.ldf'', 
MOVE N''OCHRONA_log_log'' TO N''D:\OCHRONA_log_log.ldf'',  NOUNLOAD,  REPLACE,  STATS = 10'
BEGIN TRY 
 EXEC(@sqlRestore) 
 END TRY  
   BEGIN CATCH 
  Insert into testpk.dbo.bledy select getdate(),@sqlRestore 
 END CATCH 
end
else 
if @database_name='SOLID'
begin
set @sqlRestore='RESTORE DATABASE [SOLID] FROM  DISK = N''E:\Backup\'+@nazwa_bak+'''  WITH  FILE = 1,  
MOVE N''GPSVLCANDat.mdf'' TO N''D:\GPSSOLIDDat.mdf'',  
MOVE N''GPSVLCANLog.ldf'' TO N''D:\GPSSOLIDLog.ldf'',  NOUNLOAD,  REPLACE,  STATS = 10'
BEGIN TRY 
 EXEC(@sqlRestore) 
 END TRY  
   BEGIN CATCH 
  Insert into testpk.dbo.bledy select getdate(),@sqlRestore 
 END CATCH 
end
else 
if @database_name='SZ47P'
begin
set @sqlRestore='RESTORE DATABASE [SZ47P] FROM  DISK = N''E:\Backup\'+@nazwa_bak+'''  WITH  FILE = 1,  
MOVE N''GPSKONWODat.mdf'' TO N''G:\BAZY\GPSSZ47PDat.mdf'',  
MOVE N''GPSKONWOLog.ldf'' TO N''G:\BAZY\GPSSZ47PLog.ldf'',  NOUNLOAD,  REPLACE,  STATS = 10'
BEGIN TRY 
 EXEC(@sqlRestore) 
 END TRY  
   BEGIN CATCH 
  Insert into testpk.dbo.bledy select getdate(),@sqlRestore 
 END CATCH 
end
else 
if @database_name='TRUCKER'
begin
set @sqlRestore='RESTORE DATABASE [TRUCKER] FROM  DISK = N''E:\Backup\'+@nazwa_bak+'''  WITH  FILE = 1,  
MOVE N''TRUCKER'' TO N''D:\bazy\TRUCKER.mdf'',  
MOVE N''TRUCKER_log'' TO N''D:\bazy\TRUCKER_log.ldf'',  NOUNLOAD,  REPLACE,  STATS = 10'
BEGIN TRY 
 EXEC(@sqlRestore) 
 END TRY  
  BEGIN CATCH 
  Insert into testpk.dbo.bledy select getdate(),@sqlRestore 
 END CATCH 
end
else 
if @database_name='ZSTSZ'
begin
set @sqlRestore='RESTORE DATABASE [ZSTSZ] FROM  DISK = N''E:\Backup\'+@nazwa_bak+'''  WITH  FILE = 1,  
MOVE N''GPSVLCANDat.mdf'' TO N''G:\GPSZSTSZDat.mdf'',  
MOVE N''GPSVLCANLog.ldf'' TO N''G:\GPSZSTSZLog.ldf'',  NOUNLOAD,  REPLACE,  STATS = 10'
BEGIN TRY 
 EXEC(@sqlRestore) 
 END TRY  
 BEGIN CATCH 
  Insert into testpk.dbo.bledy select getdate(),@sqlRestore 
 END CATCH 
end
else 
if @database_name='SC294'
begin
set @sqlRestore='RESTORE DATABASE [SC294] FROM  DISK = N''E:\Backup\'+@nazwa_bak+'''  WITH  FILE = 1,  
MOVE N''GPSVLCANDat.mdf'' TO N''G:\BAZY\GPSSC294Dat.mdf'',  
MOVE N''GPSVLCANLog.ldf'' TO N''G:\BAZY\GPSSC294Log.ldf'',  NOUNLOAD,  REPLACE,  STATS = 10'
BEGIN TRY 
 EXEC(@sqlRestore) 
 END TRY  
 BEGIN CATCH 
  Insert into testpk.dbo.bledy select getdate(),@sqlRestore 
 END CATCH 
end
else 
if @database_name='SC295'
begin
set @sqlRestore='RESTORE DATABASE [SC295] FROM  DISK = N''E:\Backup\'+@nazwa_bak+'''  WITH  FILE = 1,  
MOVE N''GPSVLCANDat.mdf'' TO N''G:\BAZY\GPSSC295Dat.mdf'',  
MOVE N''GPSVLCANLog.ldf'' TO N''G:\BAZY\GPSSC295Log.ldf'',  NOUNLOAD,  REPLACE,  STATS = 10'
BEGIN TRY 
 EXEC(@sqlRestore) 
 END TRY  
 BEGIN CATCH 
  Insert into testpk.dbo.bledy select getdate(),@sqlRestore 
 END CATCH 
end
else 
if @database_name='SC296'
begin
set @sqlRestore='RESTORE DATABASE [SC296] FROM  DISK = N''E:\Backup\'+@nazwa_bak+'''  WITH  FILE = 1,  
MOVE N''GPSVLCANDat.mdf'' TO N''G:\BAZY\GPSSC296Dat.mdf'',  
MOVE N''GPSVLCANLog.ldf'' TO N''G:\BAZY\GPSSC296Log.ldf'',  NOUNLOAD,  REPLACE,  STATS = 10'
BEGIN TRY 
 EXEC(@sqlRestore) 
 END TRY  
 BEGIN CATCH 
  Insert into testpk.dbo.bledy select getdate(),@sqlRestore 
 END CATCH 
end
else 
if @database_name='SC297'
begin
set @sqlRestore='RESTORE DATABASE [SC297] FROM  DISK = N''E:\Backup\'+@nazwa_bak+'''  WITH  FILE = 1,  
MOVE N''GPSVLCANDat.mdf'' TO N''G:\BAZY\GPSSC297Dat.mdf'',  
MOVE N''GPSVLCANLog.ldf'' TO N''G:\BAZY\GPSSC297Log.ldf'',  NOUNLOAD,  REPLACE,  STATS = 10'
BEGIN TRY 
 EXEC(@sqlRestore) 
 END TRY  
 BEGIN CATCH 
  Insert into testpk.dbo.bledy select getdate(),@sqlRestore 
 END CATCH 
end
else 
if @database_name='SC298'
begin
set @sqlRestore='RESTORE DATABASE [SC298] FROM  DISK = N''E:\Backup\'+@nazwa_bak+'''  WITH  FILE = 1,  
MOVE N''GPSVLCANDat.mdf'' TO N''G:\BAZY\GPSSC298Dat.mdf'',  
MOVE N''GPSVLCANLog.ldf'' TO N''G:\BAZY\GPSSC298Log.ldf'',  NOUNLOAD,  REPLACE,  STATS = 10'
BEGIN TRY 
 EXEC(@sqlRestore) 
 END TRY  
 BEGIN CATCH 
  Insert into testpk.dbo.bledy select getdate(),@sqlRestore 
 END CATCH 
end
else 
if @database_name='SC299'
begin
set @sqlRestore='RESTORE DATABASE [SC299] FROM  DISK = N''E:\Backup\'+@nazwa_bak+'''  WITH  FILE = 1,  
MOVE N''GPSVLCANDat.mdf'' TO N''G:\BAZY\GPSSC299Dat.mdf'',  
MOVE N''GPSVLCANLog.ldf'' TO N''G:\BAZY\GPSSC299Log.ldf'',  NOUNLOAD,  REPLACE,  STATS = 10'
BEGIN TRY 
 EXEC(@sqlRestore) 
 END TRY  
 BEGIN CATCH 
  Insert into testpk.dbo.bledy select getdate(),@sqlRestore 
 END CATCH 
end
else 
if @database_name='SC300'
begin
set @sqlRestore='RESTORE DATABASE [SC300] FROM  DISK = N''E:\Backup\'+@nazwa_bak+'''  WITH  FILE = 1,  
MOVE N''GPSVLCANDat.mdf'' TO N''G:\BAZY\GPSSC300Dat.mdf'',  
MOVE N''GPSVLCANLog.ldf'' TO N''G:\BAZY\GPSSC300Log.ldf'',  NOUNLOAD,  REPLACE,  STATS = 10'
BEGIN TRY 
 EXEC(@sqlRestore) 
 END TRY  
 BEGIN CATCH 
  Insert into testpk.dbo.bledy select getdate(),@sqlRestore 
 END CATCH 
end
else 
if @database_name='SC301'
begin
set @sqlRestore='RESTORE DATABASE [SC301] FROM  DISK = N''E:\Backup\'+@nazwa_bak+'''  WITH  FILE = 1,  
MOVE N''GPSVLCANDat.mdf'' TO N''G:\BAZY\GPSSC301Dat.mdf'',  
MOVE N''GPSVLCANLog.ldf'' TO N''G:\BAZY\GPSSC301Log.ldf'',  NOUNLOAD,  REPLACE,  STATS = 10'
BEGIN TRY 
 EXEC(@sqlRestore) 
 END TRY  
 BEGIN CATCH 
  Insert into testpk.dbo.bledy select getdate(),@sqlRestore 
 END CATCH 
end
else 
if @database_name='SC302'
begin
set @sqlRestore='RESTORE DATABASE [SC302] FROM  DISK = N''E:\Backup\'+@nazwa_bak+'''  WITH  FILE = 1,  
MOVE N''GPSVLCANDat.mdf'' TO N''G:\BAZY\GPSSC302Dat.mdf'',  
MOVE N''GPSVLCANLog.ldf'' TO N''G:\BAZY\GPSSC302Log.ldf'',  NOUNLOAD,  REPLACE,  STATS = 10'
BEGIN TRY 
 EXEC(@sqlRestore) 
 END TRY  
 BEGIN CATCH 
  Insert into testpk.dbo.bledy select getdate(),@sqlRestore 
 END CATCH 
end
else 
if @database_name='SC303'
begin
set @sqlRestore='RESTORE DATABASE [SC303] FROM  DISK = N''E:\Backup\'+@nazwa_bak+'''  WITH  FILE = 1,  
MOVE N''GPSVLCANDat.mdf'' TO N''G:\BAZY\GPSSC303Dat.mdf'',  
MOVE N''GPSVLCANLog.ldf'' TO N''G:\BAZY\GPSSC303Log.ldf'',  NOUNLOAD,  REPLACE,  STATS = 10'
BEGIN TRY 
 EXEC(@sqlRestore) 
 END TRY  
 BEGIN CATCH 
  Insert into testpk.dbo.bledy select getdate(),@sqlRestore 
 END CATCH 
end
else 
if @database_name='SC304'
begin
set @sqlRestore='RESTORE DATABASE [SC304] FROM  DISK = N''E:\Backup\'+@nazwa_bak+'''  WITH  FILE = 1,  
MOVE N''GPSVLCANDat.mdf'' TO N''G:\BAZY\GPSSC304Dat.mdf'',  
MOVE N''GPSVLCANLog.ldf'' TO N''G:\BAZY\GPSSC304Log.ldf'',  NOUNLOAD,  REPLACE,  STATS = 10'
BEGIN TRY 
 EXEC(@sqlRestore) 
 END TRY  
 BEGIN CATCH 
  Insert into testpk.dbo.bledy select getdate(),@sqlRestore 
 END CATCH 
end
else 
if @database_name='SC305'
begin
set @sqlRestore='RESTORE DATABASE [SC305] FROM  DISK = N''E:\Backup\'+@nazwa_bak+'''  WITH  FILE = 1,  
MOVE N''GPSVLCANDat.mdf'' TO N''G:\BAZY\GPSSC305Dat.mdf'',  
MOVE N''GPSVLCANLog.ldf'' TO N''G:\BAZY\GPSSC305Log.ldf'',  NOUNLOAD,  REPLACE,  STATS = 10'
BEGIN TRY 
 EXEC(@sqlRestore) 
 END TRY  
 BEGIN CATCH 
  Insert into testpk.dbo.bledy select getdate(),@sqlRestore 
 END CATCH 
end
else 
if @database_name='SC306'
begin
set @sqlRestore='RESTORE DATABASE [SC306] FROM  DISK = N''E:\Backup\'+@nazwa_bak+'''  WITH  FILE = 1,  
MOVE N''GPSVLCANDat.mdf'' TO N''G:\BAZY\GPSSC306Dat.mdf'',  
MOVE N''GPSVLCANLog.ldf'' TO N''G:\BAZY\GPSSC306Log.ldf'',  NOUNLOAD,  REPLACE,  STATS = 10'
BEGIN TRY 
 EXEC(@sqlRestore) 
 END TRY  
 BEGIN CATCH 
  Insert into testpk.dbo.bledy select getdate(),@sqlRestore 
 END CATCH 
end
else 
if @database_name='SC307'
begin
set @sqlRestore='RESTORE DATABASE [SC307] FROM  DISK = N''E:\Backup\'+@nazwa_bak+'''  WITH  FILE = 1,  
MOVE N''GPSVLCANDat.mdf'' TO N''G:\BAZY\GPSSC307Dat.mdf'',  
MOVE N''GPSVLCANLog.ldf'' TO N''G:\BAZY\GPSSC307Log.ldf'',  NOUNLOAD,  REPLACE,  STATS = 10'
BEGIN TRY 
 EXEC(@sqlRestore) 
 END TRY  
 BEGIN CATCH 
  Insert into testpk.dbo.bledy select getdate(),@sqlRestore 
 END CATCH 
end
else 
if @database_name='SC308'
begin
set @sqlRestore='RESTORE DATABASE [SC308] FROM  DISK = N''E:\Backup\'+@nazwa_bak+'''  WITH  FILE = 1,  
MOVE N''GPSVLCANDat.mdf'' TO N''G:\BAZY\GPSSC308Dat.mdf'',  
MOVE N''GPSVLCANLog.ldf'' TO N''G:\BAZY\GPSSC308Log.ldf'',  NOUNLOAD,  REPLACE,  STATS = 10'
BEGIN TRY 
 EXEC(@sqlRestore) 
 END TRY  
 BEGIN CATCH 
  Insert into testpk.dbo.bledy select getdate(),@sqlRestore 
 END CATCH 
end
else 
if @database_name='SC309'
begin
set @sqlRestore='RESTORE DATABASE [SC309] FROM  DISK = N''E:\Backup\'+@nazwa_bak+'''  WITH  FILE = 1,  
MOVE N''GPSVLCANDat.mdf'' TO N''G:\BAZY\GPSSC309Dat.mdf'',  
MOVE N''GPSVLCANLog.ldf'' TO N''G:\BAZY\GPSSC309Log.ldf'',  NOUNLOAD,  REPLACE,  STATS = 10'
BEGIN TRY 
 EXEC(@sqlRestore) 
 END TRY  
 BEGIN CATCH 
  Insert into testpk.dbo.bledy select getdate(),@sqlRestore 
 END CATCH 
end
else 
if @database_name='SC310'
begin
set @sqlRestore='RESTORE DATABASE [SC310] FROM  DISK = N''E:\Backup\'+@nazwa_bak+'''  WITH  FILE = 1,  
MOVE N''GPSVLCANDat.mdf'' TO N''G:\BAZY\GPSSC310Dat.mdf'',  
MOVE N''GPSVLCANLog.ldf'' TO N''G:\BAZY\GPSSC310Log.ldf'',  NOUNLOAD,  REPLACE,  STATS = 10'
BEGIN TRY 
 EXEC(@sqlRestore) 
 END TRY  
 BEGIN CATCH 
  Insert into testpk.dbo.bledy select getdate(),@sqlRestore 
 END CATCH 
end
else 
if @database_name='SC311'
begin
set @sqlRestore='RESTORE DATABASE [SC311] FROM  DISK = N''E:\Backup\'+@nazwa_bak+'''  WITH  FILE = 1,  
MOVE N''GPSVLCANDat.mdf'' TO N''G:\BAZY\GPSSC311Dat.mdf'',  
MOVE N''GPSVLCANLog.ldf'' TO N''G:\BAZY\GPSSC311Log.ldf'',  NOUNLOAD,  REPLACE,  STATS = 10'
BEGIN TRY 
 EXEC(@sqlRestore) 
 END TRY  
 BEGIN CATCH 
  Insert into testpk.dbo.bledy select getdate(),@sqlRestore 
 END CATCH 
end
else 
if @database_name='SC312'
begin
set @sqlRestore='RESTORE DATABASE [SC312] FROM  DISK = N''E:\Backup\'+@nazwa_bak+'''  WITH  FILE = 1,  
MOVE N''GPSVLCANDat.mdf'' TO N''G:\BAZY\GPSSC312Dat.mdf'',  
MOVE N''GPSVLCANLog.ldf'' TO N''G:\BAZY\GPSSC312Log.ldf'',  NOUNLOAD,  REPLACE,  STATS = 10'
BEGIN TRY 
 EXEC(@sqlRestore) 
 END TRY  
 BEGIN CATCH 
  Insert into testpk.dbo.bledy select getdate(),@sqlRestore 
 END CATCH 
end
else 
if @database_name='SC314'
begin
set @sqlRestore='RESTORE DATABASE [SC314] FROM  DISK = N''E:\Backup\'+@nazwa_bak+'''  WITH  FILE = 1,  
MOVE N''GPSVLCANDat.mdf'' TO N''G:\BAZY\GPSSC314Dat.mdf'',  
MOVE N''GPSVLCANLog.ldf'' TO N''G:\BAZY\GPSSC314Log.ldf'',  NOUNLOAD,  REPLACE,  STATS = 10'
BEGIN TRY 
 EXEC(@sqlRestore) 
 END TRY  
 BEGIN CATCH 
  Insert into testpk.dbo.bledy select getdate(),@sqlRestore 
 END CATCH 
end
else 
if @database_name='SC315'
begin
set @sqlRestore='RESTORE DATABASE [SC315] FROM  DISK = N''E:\Backup\'+@nazwa_bak+'''  WITH  FILE = 1,  
MOVE N''GPSVLCANDat.mdf'' TO N''G:\BAZY\GPSSC315Dat.mdf'',  
MOVE N''GPSVLCANLog.ldf'' TO N''G:\BAZY\GPSSC315Log.ldf'',  NOUNLOAD,  REPLACE,  STATS = 10'
BEGIN TRY 
 EXEC(@sqlRestore) 
 END TRY  
 BEGIN CATCH 
  Insert into testpk.dbo.bledy select getdate(),@sqlRestore 
 END CATCH 
end
else 
if @database_name='SC316'
begin
set @sqlRestore='RESTORE DATABASE [SC316] FROM  DISK = N''E:\Backup\'+@nazwa_bak+'''  WITH  FILE = 1,  
MOVE N''GPSVLCANDat.mdf'' TO N''G:\BAZY\GPSSC316Dat.mdf'',  
MOVE N''GPSVLCANLog.ldf'' TO N''G:\BAZY\GPSSC316Log.ldf'',  NOUNLOAD,  REPLACE,  STATS = 10'
BEGIN TRY 
 EXEC(@sqlRestore) 
 END TRY  
 BEGIN CATCH 
  Insert into testpk.dbo.bledy select getdate(),@sqlRestore 
 END CATCH 
end
else 
if @database_name='SC317'
begin
set @sqlRestore='RESTORE DATABASE [SC317] FROM  DISK = N''E:\Backup\'+@nazwa_bak+'''  WITH  FILE = 1,  
MOVE N''GPSVLCANDat.mdf'' TO N''G:\BAZY\GPSSC317Dat.mdf'',  
MOVE N''GPSVLCANLog.ldf'' TO N''G:\BAZY\GPSSC317Log.ldf'',  NOUNLOAD,  REPLACE,  STATS = 10'
BEGIN TRY 
 EXEC(@sqlRestore) 
 END TRY  
 BEGIN CATCH 
  Insert into testpk.dbo.bledy select getdate(),@sqlRestore 
 END CATCH 
end
else 
if @database_name='SC318'
begin
set @sqlRestore='RESTORE DATABASE [SC318] FROM  DISK = N''E:\Backup\'+@nazwa_bak+'''  WITH  FILE = 1,  
MOVE N''GPSVLCANDat.mdf'' TO N''G:\BAZY\GPSSC318Dat.mdf'',  
MOVE N''GPSVLCANLog.ldf'' TO N''G:\BAZY\GPSSC318Log.ldf'',  NOUNLOAD,  REPLACE,  STATS = 10'
BEGIN TRY 
 EXEC(@sqlRestore) 
 END TRY  
 BEGIN CATCH 
  Insert into testpk.dbo.bledy select getdate(),@sqlRestore 
 END CATCH 
end
else 
if @database_name='SC319'
begin
set @sqlRestore='RESTORE DATABASE [SC319] FROM  DISK = N''E:\Backup\'+@nazwa_bak+'''  WITH  FILE = 1,  
MOVE N''GPSVLCANDat.mdf'' TO N''G:\BAZY\GPSSC319Dat.mdf'',  
MOVE N''GPSVLCANLog.ldf'' TO N''G:\BAZY\GPSSC319Log.ldf'',  NOUNLOAD,  REPLACE,  STATS = 10'
BEGIN TRY 
 EXEC(@sqlRestore) 
 END TRY  
 BEGIN CATCH 
  Insert into testpk.dbo.bledy select getdate(),@sqlRestore 
 END CATCH 
end
else 
if @database_name='SC320'
begin
set @sqlRestore='RESTORE DATABASE [SC320] FROM  DISK = N''E:\Backup\'+@nazwa_bak+'''  WITH  FILE = 1,  
MOVE N''GPSVLCANDat.mdf'' TO N''G:\BAZY\GPSSC320Dat.mdf'',  
MOVE N''GPSVLCANLog.ldf'' TO N''G:\BAZY\GPSSC320Log.ldf'',  NOUNLOAD,  REPLACE,  STATS = 10'
BEGIN TRY 
 EXEC(@sqlRestore) 
 END TRY  
 BEGIN CATCH 
  Insert into testpk.dbo.bledy select getdate(),@sqlRestore 
 END CATCH 
end
else 
if @database_name='SC321'
begin
set @sqlRestore='RESTORE DATABASE [SC321] FROM  DISK = N''E:\Backup\'+@nazwa_bak+'''  WITH  FILE = 1,  
MOVE N''GPSVLCANDat.mdf'' TO N''G:\BAZY\GPSSC321Dat.mdf'',  
MOVE N''GPSVLCANLog.ldf'' TO N''G:\BAZY\GPSSC321Log.ldf'',  NOUNLOAD,  REPLACE,  STATS = 10'
BEGIN TRY 
 EXEC(@sqlRestore) 
 END TRY  
 BEGIN CATCH 
  Insert into testpk.dbo.bledy select getdate(),@sqlRestore 
 END CATCH 
end
else 
if @database_name='SC322'
begin
set @sqlRestore='RESTORE DATABASE [SC322] FROM  DISK = N''E:\Backup\'+@nazwa_bak+'''  WITH  FILE = 1,  
MOVE N''GPSVLCANDat.mdf'' TO N''G:\BAZY\GPSSC322Dat.mdf'',  
MOVE N''GPSVLCANLog.ldf'' TO N''G:\BAZY\GPSSC322Log.ldf'',  NOUNLOAD,  REPLACE,  STATS = 10'
BEGIN TRY 
 EXEC(@sqlRestore) 
 END TRY  
 BEGIN CATCH 
  Insert into testpk.dbo.bledy select getdate(),@sqlRestore 
 END CATCH 
end
else 
if @database_name='SC323'
begin
set @sqlRestore='RESTORE DATABASE [SC323] FROM  DISK = N''E:\Backup\'+@nazwa_bak+'''  WITH  FILE = 1,  
MOVE N''GPSVLCANDat.mdf'' TO N''G:\BAZY\GPSSC323Dat.mdf'',  
MOVE N''GPSVLCANLog.ldf'' TO N''G:\BAZY\GPSSC323Log.ldf'',  NOUNLOAD,  REPLACE,  STATS = 10'
BEGIN TRY 
 EXEC(@sqlRestore) 
 END TRY  
 BEGIN CATCH 
  Insert into testpk.dbo.bledy select getdate(),@sqlRestore 
 END CATCH 
end
else 
if @database_name='SC324'
begin
set @sqlRestore='RESTORE DATABASE [SC324] FROM  DISK = N''E:\Backup\'+@nazwa_bak+'''  WITH  FILE = 1,  
MOVE N''GPSVLCANDat.mdf'' TO N''G:\BAZY\GPSSC324Dat.mdf'',  
MOVE N''GPSVLCANLog.ldf'' TO N''G:\BAZY\GPSSC324Log.ldf'',  NOUNLOAD,  REPLACE,  STATS = 10'
BEGIN TRY 
 EXEC(@sqlRestore) 
 END TRY  
 BEGIN CATCH 
  Insert into testpk.dbo.bledy select getdate(),@sqlRestore 
 END CATCH 
end
else 
if @database_name='SC325'
begin
set @sqlRestore='RESTORE DATABASE [SC325] FROM  DISK = N''E:\Backup\'+@nazwa_bak+'''  WITH  FILE = 1,  
MOVE N''GPSVLCANDat.mdf'' TO N''G:\BAZY\GPSSC325Dat.mdf'',  
MOVE N''GPSVLCANLog.ldf'' TO N''G:\BAZY\GPSSC325Log.ldf'',  NOUNLOAD,  REPLACE,  STATS = 10'
BEGIN TRY 
 EXEC(@sqlRestore) 
 END TRY  
 BEGIN CATCH 
  Insert into testpk.dbo.bledy select getdate(),@sqlRestore 
 END CATCH 
end
else 
if @database_name='SC326'
begin
set @sqlRestore='RESTORE DATABASE [SC326] FROM  DISK = N''E:\Backup\'+@nazwa_bak+'''  WITH  FILE = 1,  
MOVE N''GPSVLCANDat.mdf'' TO N''G:\BAZY\GPSSC326Dat.mdf'',  
MOVE N''GPSVLCANLog.ldf'' TO N''G:\BAZY\GPSSC326Log.ldf'',  NOUNLOAD,  REPLACE,  STATS = 10'
BEGIN TRY 
 EXEC(@sqlRestore) 
 END TRY  
 BEGIN CATCH 
  Insert into testpk.dbo.bledy select getdate(),@sqlRestore 
 END CATCH 
end
else 
if @database_name='SC327'
begin
set @sqlRestore='RESTORE DATABASE [SC327] FROM  DISK = N''E:\Backup\'+@nazwa_bak+'''  WITH  FILE = 1,  
MOVE N''GPSVLCANDat.mdf'' TO N''G:\BAZY\GPSSC327Dat.mdf'',  
MOVE N''GPSVLCANLog.ldf'' TO N''G:\BAZY\GPSSC327Log.ldf'',  NOUNLOAD,  REPLACE,  STATS = 10'
BEGIN TRY 
 EXEC(@sqlRestore) 
 END TRY  
 BEGIN CATCH 
  Insert into testpk.dbo.bledy select getdate(),@sqlRestore 
 END CATCH 
end
else 
if @database_name='SC328'
begin
set @sqlRestore='RESTORE DATABASE [SC328] FROM  DISK = N''E:\Backup\'+@nazwa_bak+'''  WITH  FILE = 1,  
MOVE N''GPSVLCANDat.mdf'' TO N''G:\BAZY\GPSSC328Dat.mdf'',  
MOVE N''GPSVLCANLog.ldf'' TO N''G:\BAZY\GPSSC328Log.ldf'',  NOUNLOAD,  REPLACE,  STATS = 10'
BEGIN TRY 
 EXEC(@sqlRestore) 
 END TRY  
 BEGIN CATCH 
  Insert into testpk.dbo.bledy select getdate(),@sqlRestore 
 END CATCH 
end
else 
if @database_name='sz212'
begin
set @sqlRestore='RESTORE DATABASE [sz212] FROM  DISK = N''E:\Backup\'+@nazwa_bak+'''  WITH  FILE = 1,  
MOVE N''GPSVLCANDat.mdf'' TO N''C:\BAZY\GPSsz212Dat.mdf'',  
MOVE N''GPSVLCANLog.ldf'' TO N''C:\BAZY\GPSsz212Log.ldf'',  NOUNLOAD,  REPLACE,  STATS = 10'
BEGIN TRY 
 EXEC(@sqlRestore) 
 END TRY  
 BEGIN CATCH 
  Insert into testpk.dbo.bledy select getdate(),@sqlRestore 
 END CATCH 
end
else 
if @database_name='SZ228'
begin
set @sqlRestore='RESTORE DATABASE [SZ228] FROM  DISK = N''E:\Backup\'+@nazwa_bak+'''  WITH  FILE = 1,  
MOVE N''GPSVLCANDat.mdf'' TO N''C:\BAZY\GPSSZ228Dat.mdf'',  
MOVE N''GPSVLCANLog.ldf'' TO N''C:\BAZY\GPSSZ228Log.ldf'',  NOUNLOAD,  REPLACE,  STATS = 10'
BEGIN TRY 
 EXEC(@sqlRestore) 
 END TRY  
 BEGIN CATCH 
  Insert into testpk.dbo.bledy select getdate(),@sqlRestore 
 END CATCH 
end
else 
if @database_name='SZ229'
begin
set @sqlRestore='RESTORE DATABASE [SZ229] FROM  DISK = N''E:\Backup\'+@nazwa_bak+'''  WITH  FILE = 1,  
MOVE N''GPSVLCANDat.mdf'' TO N''C:\BAZY\GPSSZ229Dat.mdf'',  
MOVE N''GPSVLCANLog.ldf'' TO N''C:\BAZY\GPSSZ229Log.ldf'',  NOUNLOAD,  REPLACE,  STATS = 10'
BEGIN TRY 
 EXEC(@sqlRestore) 
 END TRY  
 BEGIN CATCH 
  Insert into testpk.dbo.bledy select getdate(),@sqlRestore 
 END CATCH 
end
else 
if @database_name='SZ337'
begin
set @sqlRestore='RESTORE DATABASE [SZ337] FROM  DISK = N''E:\Backup\'+@nazwa_bak+'''  WITH  FILE = 1,  
MOVE N''GPSVLCANDat.mdf'' TO N''C:\BAZY\GPSSZ337Dat.mdf'',  
MOVE N''GPSVLCANLog.ldf'' TO N''C:\BAZY\GPSSZ337Log.ldf'',  NOUNLOAD,  REPLACE,  STATS = 10'
BEGIN TRY 
 EXEC(@sqlRestore) 
 END TRY  
 BEGIN CATCH 
  Insert into testpk.dbo.bledy select getdate(),@sqlRestore 
 END CATCH 
end
else 
if @database_name='SZ340'
begin
set @sqlRestore='RESTORE DATABASE [SZ340] FROM  DISK = N''E:\Backup\'+@nazwa_bak+'''  WITH  FILE = 1,  
MOVE N''GPSVLCANDat.mdf'' TO N''C:\BAZY\GPSSZ340Dat.mdf'',  
MOVE N''GPSVLCANLog.ldf'' TO N''C:\BAZY\GPSSZ340Log.ldf'',  NOUNLOAD,  REPLACE,  STATS = 10'
BEGIN TRY 
 EXEC(@sqlRestore) 
 END TRY  
 BEGIN CATCH 
  Insert into testpk.dbo.bledy select getdate(),@sqlRestore 
 END CATCH 
end
else 
if @database_name='SZ341'
begin
set @sqlRestore='RESTORE DATABASE [SZ341] FROM  DISK = N''E:\Backup\'+@nazwa_bak+'''  WITH  FILE = 1,  
MOVE N''GPSVLCANDat.mdf'' TO N''C:\BAZY\GPSSZ341Dat.mdf'',  
MOVE N''GPSVLCANLog.ldf'' TO N''C:\BAZY\GPSSZ341Log.ldf'',  NOUNLOAD,  REPLACE,  STATS = 10'
BEGIN TRY 
 EXEC(@sqlRestore) 
 END TRY  
 BEGIN CATCH 
  Insert into testpk.dbo.bledy select getdate(),@sqlRestore 
 END CATCH 
end
else 
if @database_name='SZ347'
begin
set @sqlRestore='RESTORE DATABASE [SZ347] FROM  DISK = N''E:\Backup\'+@nazwa_bak+'''  WITH  FILE = 1,  
MOVE N''GPSVLCANDat.mdf'' TO N''C:\BAZY\GPSSZ347Dat.mdf'',  
MOVE N''GPSVLCANLog.ldf'' TO N''C:\BAZY\GPSSZ347Log.ldf'',  NOUNLOAD,  REPLACE,  STATS = 10'
BEGIN TRY 
 EXEC(@sqlRestore) 
 END TRY  
 BEGIN CATCH 
  Insert into testpk.dbo.bledy select getdate(),@sqlRestore 
 END CATCH 
end
else 
if @database_name='SZ348'
begin
set @sqlRestore='RESTORE DATABASE [SZ348] FROM  DISK = N''E:\Backup\'+@nazwa_bak+'''  WITH  FILE = 1,  
MOVE N''GPSVLCANDat.mdf'' TO N''C:\BAZY\GPSSZ348Dat.mdf'',  
MOVE N''GPSVLCANLog.ldf'' TO N''C:\BAZY\GPSSZ348Log.ldf'',  NOUNLOAD,  REPLACE,  STATS = 10'
BEGIN TRY 
 EXEC(@sqlRestore) 
 END TRY  
 BEGIN CATCH 
  Insert into testpk.dbo.bledy select getdate(),@sqlRestore 
 END CATCH 
end
else 
if @database_name='VLZKA'
begin
set @sqlRestore='RESTORE DATABASE [VLZKA] FROM  DISK = N''E:\Backup\'+@nazwa_bak+'''  WITH  FILE = 1,  
MOVE N''GPSVLCANDat.mdf'' TO N''C:\BAZY\GPSVLZKADat.mdf'',  
MOVE N''GPSVLCANLog.ldf'' TO N''C:\BAZY\GPSVLZKALog.ldf'',  NOUNLOAD,  REPLACE,  STATS = 10'
BEGIN TRY 
 EXEC(@sqlRestore) 
 END TRY  
 BEGIN CATCH 
  Insert into testpk.dbo.bledy select getdate(),@sqlRestore 
 END CATCH 
end
if @database_name='raporty'
begin
set @sqlRestore='RESTORE DATABASE [raporty] FROM  DISK = N''E:\backup\'+@nazwa_bak+'''  WITH  FILE = 1,  
MOVE N''raporty_mdf_q'' TO N''D:\raporty_mdf_q.ndf'',  
MOVE N''raporty_log_q'' TO N''D:\bazy\raporty_log_q.ldf'',  
MOVE N''raporty_ldf_q'' TO N''D:\raporty_ldf_q.ldf'',  NOUNLOAD,  REPLACE,  STATS = 10'
BEGIN TRY 
 EXEC(@sqlRestore) 
 END TRY  
 BEGIN CATCH 
  Insert into testpk.dbo.bledy select getdate(),@sqlRestore 
 END CATCH 
end


else 
begin

set @sqlRestore='ALTER DATABASE ' +  @database_name  +' SET RESTRICTED_USER  WITH ROLLBACK IMMEDIATE;'
EXEC(@sqlRestore) 

set @sqlRestore='Restore DATABASE '+ @database_name 
set @sqlRestore=@sqlRestore+ ' FROM  DISK = N''E:\Backup\'+@nazwa_bak+''' WITH  FILE = 1,  NOUNLOAD,  REPLACE,  STATS = 10'

BEGIN TRY 
 EXEC(@sqlRestore) 
 END TRY  
 BEGIN CATCH 
  Insert into testpk.dbo.bledy select getdate(),@sqlRestore 
set @sqlRestore='ALTER DATABASE '+  @database_name  + ' SET MULTI_USER;'
EXEC(@sqlRestore) 
 END CATCH 
set @sqlRestore=''
end


set @sqlRestore='ALTER DATABASE '+  @database_name  + ' SET MULTI_USER;'
EXEC(@sqlRestore) 
insert into testpk.dbo.przywracanie select @database_name,@czas1,getdate(),@nazwa_bak,@nazwa_7z, @czas0, @czas1 
      
---- break
Fetch next from @backupy_kursor into @database_name,@nazwa_bak,@nazwa_7z
end  ---- pętla WHILE

close @backupy_kursor
deallocate @backupy_kursor

