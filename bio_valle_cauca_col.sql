CREATE EXTENSION postgis;

SELECT species, family, COUNT(DISTINCT id) AS gbif_rec FROM trochilidae_val
GROUP BY species, family ORDER BY gbif_rec DESC;