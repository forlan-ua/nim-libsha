import lib, sha512

type Sha512M224* = ref object
    sha512: Sha512

proc values*(sha: Sha512M224): array[8, uint64] =
    sha.sha512.values

proc finish*(sha: Sha512M224) =
    sha.sha512.finish()

proc newSha512M224*(): Sha512M224 =
    result = Sha512M224(
        sha512: newSha512()
    )
    for i, v in [0x8C3D37C819544DA2'u64, 0x73E1996689DCD4D6'u64, 0x1DFAB7AE32FF9C82'u64, 0x679DD514582F9FCF'u64, 
    0x0F6D2B697BD44DA8'u64, 0x77E36F7304C48942'u64, 0x3F9D85A86A1D36C8'u64, 0x1112E6AD91D692A1'u64]:
        result.sha512.values[i] = v

proc add*(sha: Sha512M224, s: string | openarray[byte]): Sha512M224 {.discardable.} =
    result = sha
    sha.sha512.add(s)

proc hexdigest*(sha: Sha512M224): string =
    toHex(64, 28)

template sha512M224hexdigest*(s: string): string =
    newSha512M224().add(s).hexdigest()