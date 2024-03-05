CREATE EXTENSION postgis;

SELECT species, genus, COUNT(DISTINCT id) AS gbif_rec FROM trochilidae_val
GROUP BY species, genus ORDER BY gbif_rec DESC;

SELECT mpio_cnmbr AS municipality, COUNT(DISTINCT species) AS richness_humming
FROM municipalities_val, trochilidae_val 
WHERE ST_Intersects(municipalities_val.geom, trochilidae_val.geom)
GROUP BY municipality ORDER BY richness_humming DESC;

