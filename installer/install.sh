mkdir '.buildcannon-installer' &&
cd '.buildcannon-installer' &&
curl https://raw.githubusercontent.com/andersonlucasg3/buildcannon/1.2.4-swift4.2/installer/main.swift >> main.swift &&
swiftc ./main.swift -o installer && 
./installer && 
cd buildcannon &&
cd .build &&
cd release &&
cp buildcannon /usr/local/bin &&
cd ../../../../ &&
rm -rf '.buildcannon-installer';
