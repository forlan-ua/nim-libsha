import lib

const BIT = 32

const SHA256_CONST = [
   0x428A2F98'u32, 0x71374491'u32, 0xB5C0FBCF'u32, 0xE9B5DBA5'u32, 0x3956C25B'u32, 0x59F111F1'u32, 0x923F82A4'u32, 0xAB1C5ED5'u32,
   0xD807AA98'u32, 0x12835B01'u32, 0x243185BE'u32, 0x550C7DC3'u32, 0x72BE5D74'u32, 0x80DEB1FE'u32, 0x9BDC06A7'u32, 0xC19BF174'u32,
   0xE49B69C1'u32, 0xEFBE4786'u32, 0x0FC19DC6'u32, 0x240CA1CC'u32, 0x2DE92C6F'u32, 0x4A7484AA'u32, 0x5CB0A9DC'u32, 0x76F988DA'u32,
   0x983E5152'u32, 0xA831C66D'u32, 0xB00327C8'u32, 0xBF597FC7'u32, 0xC6E00BF3'u32, 0xD5A79147'u32, 0x06CA6351'u32, 0x14292967'u32,
   0x27B70A85'u32, 0x2E1B2138'u32, 0x4D2C6DFC'u32, 0x53380D13'u32, 0x650A7354'u32, 0x766A0ABB'u32, 0x81C2C92E'u32, 0x92722C85'u32,
   0xA2BFE8A1'u32, 0xA81A664B'u32, 0xC24B8B70'u32, 0xC76C51A3'u32, 0xD192E819'u32, 0xD6990624'u32, 0xF40E3585'u32, 0x106AA070'u32,
   0x19A4C116'u32, 0x1E376C08'u32, 0x2748774C'u32, 0x34B0BCB5'u32, 0x391C0CB3'u32, 0x4ED8AA4A'u32, 0x5B9CCA4F'u32, 0x682E6FF3'u32,
   0x748F82EE'u32, 0x78A5636F'u32, 0x84C87814'u32, 0x8CC70208'u32, 0x90BEFFFA'u32, 0xA4506CEB'u32, 0xBEF9A3F7'u32, 0xC67178F2'u32
]

type Sha256* = ref object
    values*: array[8, uint32]
    len1: uint32
    len2: uint32
    tail: array[64, uint32]
    finished: bool

proc newSha256*(): Sha256 =
    Sha256(
        values: [
            0x6a09e667'u32, 0xbb67ae85'u32, 0x3c6ef372'u32, 0xa54ff53a'u32,
            0x510e527f'u32, 0x9b05688c'u32, 0x1f83d9ab'u32, 0x5be0cd19'u32
        ]
    )

proc calculate(sha: Sha256) =
    var w = sha.tail

    var i = 16
    while i < 64:
        let s0 = rotr(w[i-15], 7) xor rotr(w[i-15], 18) xor (w[i-15] shr 3)
        let s1 = rotr(w[i-2], 17) xor rotr(w[i-2], 19) xor (w[i-2] shr 10)
        w[i] = w[i-16] + s0 + w[i-7] + s1
        i.inc
    
    var h = sha.values
    i = 0

    while i < 64:
        let S0 = rotr(h[0], 2) xor rotr(h[0], 13) xor rotr(h[0], 22)
        let ch = (h[0] and h[1]) xor (h[0] and h[2]) xor (h[1] and h[2])
        let tmp2 = S0 + ch
        let S1 = rotr(h[4], 6) xor rotr(h[4], 11) xor rotr(h[4], 25)
        let maj = (h[4] and h[5]) xor ((not h[4]) and h[6])
        let tmp1 = h[7] + S1 + maj + SHA256_CONST[i] + w[i]

        h[7] = h[6]
        h[6] = h[5]
        h[5] = h[4]
        h[4] = h[3] + tmp1
        h[3] = h[2]
        h[2] = h[1]
        h[1] = h[0]
        h[0] = tmp1 + tmp2

        i.inc

    calcValues(8)

proc add*(sha: Sha256, s: string | openarray[byte]): Sha256 {.discardable.} =
    assert(sha.finished == false, "SHA2 has been already finished")
    addImpl

proc finish*(sha: Sha256) =
    finishImpl

proc hexdigest*(sha: Sha256): string =
    toHex(32, 32)

template sha256hexdigest*(s: string): string =
    newSha256().add(s).hexdigest()