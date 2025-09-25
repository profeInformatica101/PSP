mkdir -p lab && cd lab
printf "foo\nbar\n"     > app.log
printf "nothing\n"      > sys.log
touch secret.log && chmod 000 secret.log   # provoca error de permisos al leer
seq 1 5               > nums.txt
printf "uno\ndos\ntres\n" > lines.txt
printf "beta\nalpha\nbeta\n" > words.txt
mkdir -p dir1 dir2
printf "a\n"   > dir1/a.txt
printf "a\nb\n" > dir2/a.txt

