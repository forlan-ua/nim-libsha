import lib

const BIT = 32
const SHA1_DEFAULTS = [
    0x67452301'u32, 0xEFCDAB89'u32, 0x98BADCFE'u32, 0x10325476'u32, 0xC3D2E1F0'u32
]

type Sha1* = ref object
    values*: array[5, uint32]
    len1: uint32
    len2: uint32
    tail: array[80, uint32]
    finished: bool

proc newSha1*(): Sha1 =
    Sha1(values: SHA1_DEFAULTS)

template calculateImpl =
    var tmp: uint32

    var i = 16
    while i < 80:
        w[i] = rotl(w[i-3] xor w[i-8] xor w[i-14] xor w[i-16], 1)
        i.inc
    
    template calc =
        h[4] = h[3]
        h[3] = h[2]
        h[2] = rotl(h[1], 30)
        h[1] = h[0]
        h[0] = tmp

    i = 0
    while i < 20:
        tmp = rotl(h[0], 5) + h[4] + w[i] +
            ((h[1] and h[2]) or ((not h[1]) and h[3])) + 0x5a827999'u32
        calc
        i.inc

    while i < 40:
        tmp = rotl(h[0], 5) + h[4] + w[i] +
            (h[1] xor h[2] xor h[3]) + 0x6ed9eba1'u32
        calc
        i.inc

    while i < 60:
        tmp = rotl(h[0], 5) + h[4] + w[i] +
            ((h[1] and h[2]) or (h[1] and h[3]) or (h[2] and h[3])) + 0x8f1bbcdc'u32
        calc
        i.inc

    while i < 80:
        tmp = rotl(h[0], 5) + h[4] + w[i] +
            (h[1] xor h[2] xor h[3]) + 0xca62c1d6'u32
        calc
        i.inc

proc calculate(sha: Sha1) =
    var w = sha.tail
    var h = sha.values

    calculateImpl
    
    sha.values = h

proc add*(sha: Sha1, s: string | openarray[byte]): Sha1 {.discardable.} =
    assert(sha.finished == false, "SHA1 has been already finished")
    addImpl

proc finish*(sha: Sha1) =
    finishImpl

proc hexdigest*(sha: Sha1): string =
    sha.finish()
    let h = sha.values
    toHex(32, 20)

proc sha1hexdigest*(s: string): string =
    var h = SHA1_DEFAULTS
    var w: array[80, uint32]

    inlineImpl
    
    w[15] = s.len.uint32
    calculateImpl

    toHex(32, 20)