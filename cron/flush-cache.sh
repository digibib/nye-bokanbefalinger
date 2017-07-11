#!/bin/sh
echo "Flusing redis cache:"
echo "FLUSHALL" | nc redis 6379
echo "Done."

echo "Visiting pages to repopulate cache:"
for url in "" "anbefalinger" "se-lister" "lag-lister" "sok"
do
	curl --write-out "bokanbefalinger-app:8801/$url: %{http_code}\n" --silent --output /dev/null bokanbefalinger-app:8801/$url
done
