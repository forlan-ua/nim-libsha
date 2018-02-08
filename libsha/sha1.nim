import lib

const SHA1_CONST = [
    0x5a827999'u32, 0x6ed9eba1'u32, 0x8f1bbcdc'u32, 0xca62c1d6'u32
]

type Sha1* = ref object
    values*: array[5, uint32]
    len: uint64
    tail: array[64, byte]
    finished: bool

proc newSha1*(): Sha1 =
    Sha1(
        values: [
            0x67452301'u32, 0xEFCDAB89'u32, 0x98BADCFE'u32, 0x10325476'u32,
            0xC3D2E1F0'u32
        ]
    )

proc calculate(sha: Sha1) =
    var w: array[80, uint32]
    for i in 0 ..< 16:
        let k = i * 4
        w[i] = (sha.tail[k].uint32 shl 24) or (sha.tail[k + 1].uint32 shl 16) or (sha.tail[k + 2].uint32 shl 8) or sha.tail[k + 3].uint32

    for i in 16 ..< 80:
        w[i] = rotl(w[i-3] xor w[i-8] xor w[i-14] xor w[i-16], 1)

    var h = sha.values
    var f: uint32
    var k: uint32

    for i in 0 ..< 80: 
        case i:
            of 0 .. 19:
                f = (h[1] and h[2]) or ((not h[1]) and h[3])
                k = SHA1_CONST[0]
            of 20 .. 39:
                f = h[1] xor h[2] xor h[3]
                k = SHA1_CONST[1]
            of 40 .. 59:
                f = (h[1] and h[2]) or (h[1] and h[3]) or (h[2] and h[3]) 
                k = SHA1_CONST[2]
            else:
                f = h[1] xor h[2] xor h[3]
                k = SHA1_CONST[3]

        let tmp = rotl(h[0], 5) + f + h[4] + k + w[i]
        h[4] = h[3]
        h[3] = h[2]
        h[2] = rotl(h[1], 30)
        h[1] = h[0]
        h[0] = tmp

    for i in 0 .. h.high:
        sha.values[i] += h[i]

proc add*(sha: Sha1, s: string | openarray[byte]): Sha1 =
    assert(sha.finished == false, "SHA1 has been already finished")
    result = sha

    add32

proc finish*(sha: Sha1) =
    finish32

proc hexdigest*(sha: Sha1): string =
    sha.finish()
    result = newString(40)
    
    for i in 0 ..< 5:
        toHex32

template sha1hexdigest*(s: string): string =
    newSha1().add(s).hexdigest()