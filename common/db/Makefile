DB_FILE:=mauvecorp_vpn_client.db
CSV_FILES:= $(filter-out $(CONFIG_ITEMS_FILE), $(wildcard *.csv))

.PHONY: all db

all: db

db: $(DB_FILE)


$(DB_FILE): $(CSV_FILES)
	./createdb.sh $(DB_FILE)

clean:
	rm -f $(DB_FILE)

