libsha - SHA1 and SHA2 implementation
======

## Information
* SHA-1 (Secure Hash Algorithm 1) is a cryptographic hash function which takes an input and produces a 160-bit (20-byte) hash value. [Wiki](https://en.wikipedia.org/wiki/SHA-1)
* SHA-2 (Secure Hash Algorithm 2) is a set of cryptographic hash functions designed by the United States National Security Agency (NSA). [Wiki](https://en.wikipedia.org/wiki/SHA-1)

## Installation


### Nimble
```bash
nimble install https://github.com/forlan-ua/nim-libsha
```


### Repo
```
git clone https://github.com/forlan-ua/nim-libsha
cd nim-libsh
nimble install
```

You can use `nimble develop` instead of `nimble install`

### Tests

Clone the repo then:
```
nimble install nake
cd tests
nake
```

Look into [nakefile.nim](https://github.com/forlan-ua/nim-libsha/blob/master/tests/nakefile.nim) for more tests

## Algorithms

* SHA1: `libsha / sha1`
* SHA224: `libsha / sha224`
* SHA256: `libsha / sha256`
* SHA384: `libsha / sha384`
* SHA512: `libsha / sha512`
* SHA512/224: `libsha / sha512m224`
* SHA512/256: `libsha / sha512m256`

## Usage

```nim
import libsha / sha256

let sha = newSha256()
sha.add("The quick brown ")
sha.add("fox jumps over the lazy dog")
echo sha.hexdigest()
```

or:

```nim
import libsha / sha256

echo sha256hexdigest("The quick brown fox jumps over the lazy dog")
```