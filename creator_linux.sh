curl -O https://raw.githubusercontent.com/Sei-Lisa/kwdb/master/outputs/builtins.txt
#export VERSION_FILE=$(cat .version)
export BUILD_VERSION_NUMBER=${1:-$(cat .version)}
export DEBUG=${2:-""}
make
mkdir -p binary/linux/
cp lslint binary/linux/
make clean
