template rotr*(x: uint32, y: int): uint32 =
    ((x shr y) or (x shl (32 - y)))

template rotl*(x: uint32, y: int): uint32 =
    ((x shl y) or (x shr (32 - y)))

template rotr*(x: uint64, y: int): uint64 =
    ((x shr y) or (x shl (64 - y)))

template toByte*(x: SomeInteger): byte =
    (x and 0b11111111).byte

const DIGEST = "0123456789ABCDEF"
template toHex32* =
    let k = i * 8
    result[k] = DIGEST[(sha.values[i].int shr 28) and 0xF]
    result[k + 1] = DIGEST[(sha.values[i].int shr 24) and 0xF]
    result[k + 2] = DIGEST[(sha.values[i].int shr 20) and 0xF]
    result[k + 3] = DIGEST[(sha.values[i].int shr 16) and 0xF]
    result[k + 4] = DIGEST[(sha.values[i].int shr 12) and 0xF]
    result[k + 5] = DIGEST[(sha.values[i].int shr 8) and 0xF]
    result[k + 6] = DIGEST[(sha.values[i].int shr 4) and 0xF]
    result[k + 7] = DIGEST[(sha.values[i].int) and 0xF]

template toHex64* =
    let k = i * 16
    result[k] = DIGEST[(sha.values[i].int shr 60) and 0xF]
    result[k + 1] = DIGEST[(sha.values[i].int shr 56) and 0xF]
    result[k + 2] = DIGEST[(sha.values[i].int shr 52) and 0xF]
    result[k + 3] = DIGEST[(sha.values[i].int shr 48) and 0xF]
    result[k + 4] = DIGEST[(sha.values[i].int shr 44) and 0xF]
    result[k + 5] = DIGEST[(sha.values[i].int shr 40) and 0xF]
    result[k + 6] = DIGEST[(sha.values[i].int shr 36) and 0xF]
    result[k + 7] = DIGEST[(sha.values[i].int shr 32) and 0xF]
    result[k + 8] = DIGEST[(sha.values[i].int shr 28) and 0xF]
    result[k + 9] = DIGEST[(sha.values[i].int shr 24) and 0xF]
    result[k + 10] = DIGEST[(sha.values[i].int shr 20) and 0xF]
    result[k + 11] = DIGEST[(sha.values[i].int shr 16) and 0xF]
    result[k + 12] = DIGEST[(sha.values[i].int shr 12) and 0xF]
    result[k + 13] = DIGEST[(sha.values[i].int shr 8) and 0xF]
    result[k + 14] = DIGEST[(sha.values[i].int shr 4) and 0xF]
    result[k + 15] = DIGEST[(sha.values[i].int) and 0xF]

template finish32* =
    if sha.finished:
        return
    sha.finished = true

    let tailEndBit = sha.len mod 512
    var tailEnd = tailEndBit div 8
    
    sha.tail[tailEnd] = 0b10000000
    tailEnd.inc

    if tailEndBit >= (512 - 64).uint64:
        for i in tailEnd ..< 64:
            sha.tail[i] = 0b0
        sha.calculate()
        tailEnd = 0

    for i in tailEnd ..< (64 - 8):
        sha.tail[i] = 0b0
    tailEnd = 64 - 8

    for i in 0 ..< 8:
        sha.tail[tailEnd] = (sha.len shr ((7 - i) * 8)).toByte()
        tailEnd.inc

    sha.calculate()

template add32* =
    var tailEnd = (sha.len mod 512) div 8
    if tailEnd + s.len.uint64 < 64:
        for i in 0 ..< s.len:
            sha.tail[tailEnd + i.uint64] = s[i].byte
        sha.len += s.len.uint64 * 8
        return

    for i in 0 ..< s.len:
        sha.tail[tailEnd] = s[i].byte
        tailEnd = (tailEnd + 1) mod 64
        if tailEnd == 0:
            sha.calculate()
    sha.len += s.len.uint64 * 8