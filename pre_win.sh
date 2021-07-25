# run this on mingw before running creator_win*.sh

curl -O https://raw.githubusercontent.com/Sei-Lisa/kwdb/master/outputs/builtins.txt

echo "const char *builtins_txt[] = {" > builtins_txt.cc
sed -e '/^\/\//d; s/"/\\\"/g; s/^/"/; s/$/",/' builtins.txt >> builtins_txt.cc || { rm -f builtins_txt.cc ; false ; }
echo "(char*)0 };" >> builtins_txt.cc
