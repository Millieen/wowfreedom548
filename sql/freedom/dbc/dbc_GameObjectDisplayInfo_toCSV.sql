-- using WoWParser2_Build98 to convert this exported CSV to DBC
SELECT 'int','string','int','int','int','int','int','int','int','int','int','int','float','float','float','float','float','float','int','float','float'
UNION ALL
SELECT 
	a.id, 
	CONCAT('"', REPLACE(a.name, '\\n', '\\N'), '"'), -- REPLACE \n => \N function due to WoWParser2_Build98 bug
	a.i1, 
	a.i2, 
	a.i3,
	a.i4,
	a.i5,
	a.i6,
	a.i7,
	a.i8,
	a.i9,
	a.i10,
	a.f1,
	a.f2,
	a.f3,
	a.f4,
	a.f5,
	a.f6,
	a.i11,
	a.f7,
	a.f8
INTO OUTFILE 'D:\\WoW Freedom Development\\TOOLS\\wowfreedom548tools\\WoWParser2_Build98\\workspace\\GameObjectDisplayInfo.csv' -- replace wherever you want CSV extracted to
FIELDS TERMINATED BY ','
ESCAPED BY '' 
FROM dbc_gameobjectdisplayinfo a;