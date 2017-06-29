.PHONY: clear_graphs import
clear_graphs:
	sudo docker exec -it virtuoso bash -c 'echo -e "log_enable(3,1);\nSPARQL CLEAR GRAPH <http://data.deichman.no/reviews>;"'
	sudo docker exec -it virtuoso bash -c 'echo -e "log_enable(3,1);\nSPARQL CLEAR GRAPH <http://data.deichman.no/sources>;"'
	sudo docker exec -it virtuoso bash -c 'echo -e "log_enable(3,1);\nSPARQL CLEAR GRAPH <http://data.deichman.no/books>;"'
	sudo docker exec -it virtuoso bash -c 'echo -e "log_enable(3,1);\nSPARQL CLEAR GRAPH <lsext>;"'

copy_data:
	sudo docker cp ./data/books.ttl.gz virtuoso:/data/
	sudo docker cp ./data/ds.nt.gz virtuoso:/data/
	sudo docker cp ./data/reviews.ttl.gz virtuoso:/data/
	sudo docker cp ./data/sources.ttl.gz virtuoso:/data/

import: copy_data clear_graphs
	sudo docker exec -it virtuoso bash -c "cd /data && echo -e \"ld_dir('/data', 'reviews.ttl.gz', 'http://data.deichman.no/reviews');\nrdf_loader_run();\" | isql"
	sudo docker exec -it virtuoso bash -c "cd /data && echo -e \"ld_dir('/data', 'books.ttl.gz', 'http://data.deichman.no/sources');\nrdf_loader_run();\" | isql"
	sudo docker exec -it virtuoso bash -c "cd /data && echo -e \"ld_dir('/data', 'reviews.ttl.gz', 'http://data.deichman.no/books');\nrdf_loader_run();\" | isql"
	sudo docker exec -it virtuoso bash -c "cd /data && echo -e \"ld_dir('/data', 'ds.nt.gz', 'lsext');\nrdf_loader_run();\" | isql"