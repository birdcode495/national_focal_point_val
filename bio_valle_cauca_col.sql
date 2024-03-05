CREATE EXTENSION postgis;

SELECT species, genus, COUNT(DISTINCT id) AS gbif_rec FROM trochilidae_val
GROUP BY species, genus ORDER BY gbif_rec DESC;