import lib, sha512

type Sha512M256* = ref object
    sha512: Sha512

proc values*(sha: Sha512M256): array[8, uint64] =
    sha.sha512.values

proc finish*(sha: Sha512M256) =
    sha.sha512.finish()

proc newSha512M256*(): Sha512M256 =
    result = Sha512M256(
        sha512: newSha512()
    )

    for i, v in [0x22312194FC2BF72C'u64, 0x9F555FA3C84C64C2'u64, 0x2393B86B6F53B151'u64, 0x963877195940EABD'u64, 
    0x96283EE2A88EFFE3'u64, 0xBE5E1E2553863992'u64, 0x2B0199FC2C85B8AA'u64, 0x0EB72DDC81C52CA2'u64]:
        result.sha512.values[i] = v

proc add*(sha: Sha512M256, s: string | openarray[byte]): Sha512M256 {.discardable.} =
    result = sha
    sha.sha512.add(s)

proc hexdigest*(sha: Sha512M256): string =
    toHex(64, 32)

template sha512M256hexdigest*(s: string): string =
    newSha512M256().add(s).hexdigest()