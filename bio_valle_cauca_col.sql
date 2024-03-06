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

-- Calculation of area of territorial entities in hectares

---- Creation of fields of area
ALTER TABLE sector_rural ADD COLUMN area_has double precision;
ALTER TABLE municipalities_val ADD COLUMN area_has double precision;

---- Calculation of area
UPDATE sector_rural SET area_has = ST_Area(geom) / 10000;
UPDATE municipalities_val SET area_has = ST_Area(geom) / 10000;


-- Indigenous communities in Valle del Cauca

---- Calculation of indigenous rural population by municipality and ethnicity

SELECT municipality, SUM(emberas) AS pob_embera, SUM(nasas) AS pob_nasa, SUM(wounann) AS pob_wounan,
SUM(pastoss) AS pob_pastos, SUM(yanaconas) AS pob_yanaconas, SUM(ingas) AS pob_ingas
FROM sector_rural 
GROUP BY municipality ORDER BY pob_embera, pob_nasa, pob_wounan, pob_pastos, pob_yanaconas, pob_ingas;


---- Calculation of hummingbird species richness by sector rural and ethnicity

SELECT setr_ccnct AS sector_rural_cod, municipality emberas, nasas, wounann, pastoss, yanaconas, ingas,
COUNT(DISTINCT species) AS hummingbird_richness
FROM sector_rural, trochilidae_val
WHERE ST_Intersects(sector_rural.geom, trochilidae_val.geom)
GROUP BY sector_rural_cod, municipality, emberas, nasas, wounann, pastoss, yanaconas, ingas 
ORDER BY hummingbird_richness DESC;


-- Kingdom: Plantae (Georreferenced GBIF records in Valle del Cauca)

SELECT scientific AS scientific_name, family, taxonrank, COUNT(DISTINCT id) AS GBIF_rec FROM plantae_valle
GROUP BY scientific_name, family, taxonrank ORDER BY GBIF_rec DESC;








