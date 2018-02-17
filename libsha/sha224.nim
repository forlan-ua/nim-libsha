import lib, sha256

const BIT = 32

type Sha224 = ref object
    sha256: Sha256

proc values*(sha: Sha224): array[8, uint32] =
    sha.sha256.values

proc finish*(sha: Sha224) =
    sha.sha256.finish()

proc newSha224*(): Sha224 =
    result = Sha224(
        sha256: newSha256()
    )
    for i, v in [0xc1059ed8'u32, 0x367cd507'u32, 0x3070dd17'u32, 0xf70e5939'u32, 0xffc00b31'u32, 0x68581511'u32, 0x64f98fa7'u32, 0xbefa4fa4'u32]:
        result.sha256.values[i] = v

proc add*(sha: Sha224, s: string | openarray[byte]): Sha224 {.discardable.} =
    result = sha
    sha.sha256.add(s)

proc hexdigest*(sha: Sha224): string =
    toHex(32, 28)

template sha224hexdigest*(s: string): string =
    newSha224().add(s).hexdigest()