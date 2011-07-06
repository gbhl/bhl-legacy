use citebank;
SELECT COUNT(*) FROM node AS n JOIN biblio AS b ON (n.nid = b.nid) WHERE TYPE = 'biblio' AND b.biblio_url LIKE '%.pdf'

Number of biblio entries for not .pdf type links:
SELECT COUNT(*) FROM node AS n JOIN biblio AS b ON (n.nid = b.nid) WHERE TYPE = 'biblio' AND b.biblio_url NOT LIKE '%.pdf'

Number of biblio entries:
SELECT COUNT(*) FROM node AS n JOIN biblio AS b ON (n.nid = b.nid) WHERE TYPE = 'biblio'

Number of Users:
SELECT COUNT(*) FROM users

Counts for various sources:
SELECT COUNT(*) FROM node AS n JOIN biblio AS b ON (n.nid = b.nid) WHERE TYPE = 'biblio' AND b.biblio_url LIKE '%handle.net%'

SELECT COUNT(*) FROM node AS n JOIN biblio AS b ON (n.nid = b.nid) WHERE TYPE = 'biblio' AND b.biblio_url LIKE '%biodiversity%'

SELECT COUNT(*) FROM node AS n JOIN biblio AS b ON (n.nid = b.nid) WHERE TYPE = 'biblio' AND b.biblio_url LIKE '%pensof%'

SELECT COUNT(*) FROM node AS n JOIN biblio AS b ON (n.nid = b.nid) WHERE TYPE = 'biblio' AND b.biblio_url LIKE '%zookey%'

SELECT COUNT(*) FROM node AS n JOIN biblio AS b ON (n.nid = b.nid) WHERE TYPE = 'biblio' AND b.biblio_url LIKE '%scielo%'

List of nids, and biblio urls:
SELECT n.nid, b.biblio_url FROM node AS n JOIN biblio AS b ON (n.nid = b.nid) WHERE TYPE = 'biblio' AND b.biblio_url NOT LIKE '%.pdf'

