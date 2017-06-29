.PHONY: clear_graphs copy_data import

define clear_graph
	sudo docker exec -it virtuoso bash -c 'echo -e "log_enable(2);\nSPARQL CLEAR GRAPH <$(1)>;checkpoint;"'
endef

define import_graph
	$(TIMEIT) sudo docker exec -it virtuoso bash -c "cd /data && echo -e \"ld_dir('/data', '$(1)', '$(2)');\nrdf_loader_run();\ncheckpoint;\" | isql"
endef

TIMEIT=/usr/bin/time -f"\nimport graph took: %es"

clear_graphs:
	$(call clear_graph,http://data.deichman.no/reviews)
	$(call clear_graph,http://data.deichman.no/sources)
	$(call clear_graph,http://data.deichman.no/books)
	$(call clear_graph,lsext)

FILES=reviews.ttl.gz sources.ttl.gz books.ttl.gz ds.nt.gz
copy_data:
	for file in $(FILES); do sudo docker cp ./data/$$file virtuoso:/data/; done

import: copy_data clear_graphs
	$(call import_graph,reviews.ttl.gz,http://data.deichman.no/reviews)
	$(call import_graph,sources.ttl.gz,http://data.deichman.no/sources)
	$(call import_graph,books.ttl.gz,http://data.deichman.no/books)
	$(call import_graph,ds.nt.gz,lsext)
