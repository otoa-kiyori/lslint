curl -O https://raw.githubusercontent.com/Sei-Lisa/kwdb/master/outputs/builtins.txt
export BUILD_VERSION_NUMBER=${1:-$(cat .version)}
export DEBUG=${2:-""}
make
mkdir -p binary/osx/
cp lslint binary/osx/
make clean
