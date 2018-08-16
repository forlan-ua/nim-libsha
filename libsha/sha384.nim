import lib, sha512

type Sha384* = ref object
    sha512: Sha512

proc values*(sha: Sha384): array[8, uint64] =
    sha.sha512.values

proc finish*(sha: Sha384) =
    sha.sha512.finish()

proc newSha384*(): Sha384 =
    result = Sha384(
        sha512: newSha512()
    )
    for i, v in [0xcbbb9d5dc1059ed8'u64, 0x629a292a367cd507'u64, 0x9159015a3070dd17'u64, 0x152fecd8f70e5939'u64, 
    0x67332667ffc00b31'u64, 0x8eb44a8768581511'u64, 0xdb0c2e0d64f98fa7'u64, 0x47b5481dbefa4fa4'u64]:
        result.sha512.values[i] = v

proc add*(sha: Sha384, s: string | openarray[byte]): Sha384 {.discardable.} =
    result = sha
    sha.sha512.add(s)

proc hexdigest*(sha: Sha384): string =
    toHex(64, 48)

template sha384hexdigest*(s: string): string =
    newSha384().add(s).hexdigest()