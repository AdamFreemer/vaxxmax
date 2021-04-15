SELECT
	address,
	city,
	state,
	zip,
	latitude,
	longitude,
	last_updated,
	when_available,
	'Rite Aid' as provider,
	'-' as vaccine_types
FROM locations
WHERE is_rite_aid = true AND availability = true
UNION ALL
SELECT
	address,
	city,
	state,
	zip,
	latitude,
	longitude,
	last_updated,
	when_available,
	'Walmart' as provider,
	vaccine_types as vaccine_types
FROM locations
WHERE is_walmart = true AND availability = true
UNION ALL
SELECT
	'-' as address,
	name,
	state,
	zip,
	latitude,
	longitude,
	last_updated,
	when_available,
	'CVS' as provider,
	'-' as vaccine_types
FROM cvs_cities
WHERE availability = true
UNION ALL
SELECT
	'-' as address,
	name,
	state,
	zip,
	latitude,
	longitude,
	last_updated,
	when_available,
	'Health Mart' as provider,
	'-' as vaccine_types
FROM health_mart_cities
WHERE availability = true
UNION ALL
SELECT
	'-' as address,
	name,
	state,
	zip,
	latitude,
	longitude,
	last_updated,
	when_available,
	'Walgreens' as provider,
	vaccine_types as vaccine_types
FROM walgreens_cities
WHERE availability = true