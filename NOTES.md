

## OpenSSL 3.0

For Ruby 3.2.2, it is necessary to setup cmake to link to openssl@3 libs provided by HomeBrew.

### Patching from 1.1 to 3

sed -i '' -e 's/openssl@1.1/openssl@3/g' lib/tebako/packager/patch_literals.rb
sed -i '' -e 's/openssl@1.1/openssl@3/g' tools/cmake-scripts/macos-environment.cmake

### Patching from 3 to 1.1

sed -i '' -e 's/openssl@3/openssl@1.1/g' lib/tebako/packager/patch_literals.rb
sed -i '' -e 's/openssl@3/openssl@1.1/g' tools/cmake-scripts/macos-environment.cmake