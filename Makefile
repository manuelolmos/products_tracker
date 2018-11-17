default:
	./rebar3 shell

deps:
	./rebar3 compile

db:
	~/cassandra/bin/cqlsh -f ./priv/dbs/ptracker.cql
