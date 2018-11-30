echo "1 should be displayed"
python -c "import rethinkdb as r;r.connect('$HOSTNAME',28015).repl();a=r.table('t').count().run(); print(a)"


