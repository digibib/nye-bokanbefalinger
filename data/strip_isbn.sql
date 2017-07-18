SPARQL
PREFIX :      <http://data.deichman.no/ontology#>
WITH <lsext>
DELETE { ?p :isbn ?isbn }
INSERT { ?p :isbn ?core_isbn }
WHERE {
  ?p a :Publication ; :isbn ?isbn
  BIND(REPLACE(?isbn, "[^0-9Xx]+", "") AS ?core_isbn)
}
;
