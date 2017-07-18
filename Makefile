.PHONY: clear_graphs copy_data import update

define clear_graph
	docker exec -i virtuoso bash -c "cd /data && echo -e \"log_enable(3,1);\nSPARQL DROP SILENT GRAPH <$(1)>;\ncheckpoint;\" | isql"
endef

define import_graph
	docker exec -i virtuoso bash -c "cd /data && echo -e \"DELETE FROM DB.DBA.load_list;\nld_dir('/data', '$(1)', '$(2)');\nrdf_loader_run();\ncheckpoint;\" | isql"
endef

clear_graphs:
	$(call clear_graph,http://data.deichman.no/reviews)
	$(call clear_graph,http://data.deichman.no/sources)
	$(call clear_graph,http://data.deichman.no/books)
	$(call clear_graph,lsext)

FILES=reviews.ttl.gz sources.ttl.gz books.ttl.gz ds.nt.gz resources.ttl
copy_data:
	for file in $(FILES); do docker cp ./data/$$file virtuoso:/data/; done

import: copy_data clear_graphs
	$(call import_graph,reviews.ttl.gz,http://data.deichman.no/reviews)
	$(call import_graph,sources.ttl.gz,http://data.deichman.no/sources)
	$(call import_graph,books.ttl.gz,http://data.deichman.no/books)
	$(call import_graph,ds.nt.gz,lsext)

update:
	wget -O data/ds.nt.gz http://static.deichman.no/fusekidump.nt.gz
	/usr/bin/docker cp ./data/ds.nt.gz virtuoso:/data/
	$(call clear_graph,lsext)
	$(call import_graph,ds.nt.gz,lsext)
	$(call import_graph,resources.ttl,lsext)
