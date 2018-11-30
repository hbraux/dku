# run python drivers (assuming it was  installed with pip)
python -c "import rethinkdb as r; r.connect('$HOSTNAME',28015).repl(); r.db('test').table_create('t').run(); print(r.table('t').insert({'abc':12345}).run())";


