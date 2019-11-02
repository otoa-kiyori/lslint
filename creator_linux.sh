curl -O https://bitbucket.org/api/2.0/repositories/Sei_Lisa/kwdb/src/default/outputs/builtins.txt
export BUILD_VERSION_NUMBER=${1:-TEST}
export DEBUG=""
make
mkdir -p binary/linux/
cp lslint binary/linux/
make clean
