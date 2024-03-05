-- Creation of the postgis extension in the National 
-- Focal Point Valle del Cauca database

CREATE EXTENSION postgis;

-- Creation of the table of hummingbird species sighted in Valle del Cauca, 
-- according to the information published by the GBIF

SELECT species, genus, COUNT(DISTINCT id) AS gbif_rec FROM trochilidae_val
GROUP BY species, genus ORDER BY gbif_rec DESC;

-- Creation of the hummingbird species richness table by municipality 
-- of Valle del Cauca

SELECT mpio_cnmbr AS municipality, COUNT(DISTINCT species) AS richness_humming
FROM municipalities_val, trochilidae_val 
WHERE ST_Intersects(municipalities_val.geom, trochilidae_val.geom)
GROUP BY municipality ORDER BY richness_humming DESC;

-- Geographic segmentation of DANE rural sectors by municipality

---- Creation of the municipality field in the rural sectors layer

ALTER TABLE sector_rural ADD COLUMN municipality varchar(50);

---- Geographic segmentation

UPDATE sector_rural SET municipality = municipalities_val.mpio_cnmbr
FROM municipalities_val 
WHERE ST_Intersects(sector_rural.geom, municipalities_val.geom);



