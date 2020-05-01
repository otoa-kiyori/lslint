curl -O https://raw.githubusercontent.com/Sei-Lisa/kwdb/master/outputs/builtins.txt
export BUILD_VERSION_NUMBER=${1:-TEST}
export DEBUG=""
make
mkdir -p binary/linux/
cp lslint binary/linux/
make clean
