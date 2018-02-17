import lib

const BIT = 64

const SHA512_CONST = [
    0x428a2f98d728ae22'u64, 0x7137449123ef65cd'u64, 0xb5c0fbcfec4d3b2f'u64, 0xe9b5dba58189dbbc'u64, 0x3956c25bf348b538'u64, 
    0x59f111f1b605d019'u64, 0x923f82a4af194f9b'u64, 0xab1c5ed5da6d8118'u64, 0xd807aa98a3030242'u64, 0x12835b0145706fbe'u64, 
    0x243185be4ee4b28c'u64, 0x550c7dc3d5ffb4e2'u64, 0x72be5d74f27b896f'u64, 0x80deb1fe3b1696b1'u64, 0x9bdc06a725c71235'u64, 
    0xc19bf174cf692694'u64, 0xe49b69c19ef14ad2'u64, 0xefbe4786384f25e3'u64, 0x0fc19dc68b8cd5b5'u64, 0x240ca1cc77ac9c65'u64, 
    0x2de92c6f592b0275'u64, 0x4a7484aa6ea6e483'u64, 0x5cb0a9dcbd41fbd4'u64, 0x76f988da831153b5'u64, 0x983e5152ee66dfab'u64, 
    0xa831c66d2db43210'u64, 0xb00327c898fb213f'u64, 0xbf597fc7beef0ee4'u64, 0xc6e00bf33da88fc2'u64, 0xd5a79147930aa725'u64, 
    0x06ca6351e003826f'u64, 0x142929670a0e6e70'u64, 0x27b70a8546d22ffc'u64, 0x2e1b21385c26c926'u64, 0x4d2c6dfc5ac42aed'u64, 
    0x53380d139d95b3df'u64, 0x650a73548baf63de'u64, 0x766a0abb3c77b2a8'u64, 0x81c2c92e47edaee6'u64, 0x92722c851482353b'u64, 
    0xa2bfe8a14cf10364'u64, 0xa81a664bbc423001'u64, 0xc24b8b70d0f89791'u64, 0xc76c51a30654be30'u64, 0xd192e819d6ef5218'u64, 
    0xd69906245565a910'u64, 0xf40e35855771202a'u64, 0x106aa07032bbd1b8'u64, 0x19a4c116b8d2d0c8'u64, 0x1e376c085141ab53'u64, 
    0x2748774cdf8eeb99'u64, 0x34b0bcb5e19b48a8'u64, 0x391c0cb3c5c95a63'u64, 0x4ed8aa4ae3418acb'u64, 0x5b9cca4f7763e373'u64, 
    0x682e6ff3d6b2b8a3'u64, 0x748f82ee5defb2fc'u64, 0x78a5636f43172f60'u64, 0x84c87814a1f0ab72'u64, 0x8cc702081a6439ec'u64, 
    0x90befffa23631e28'u64, 0xa4506cebde82bde9'u64, 0xbef9a3f7b2c67915'u64, 0xc67178f2e372532b'u64, 0xca273eceea26619c'u64, 
    0xd186b8c721c0c207'u64, 0xeada7dd6cde0eb1e'u64, 0xf57d4f7fee6ed178'u64, 0x06f067aa72176fba'u64, 0x0a637dc5a2c898a6'u64, 
    0x113f9804bef90dae'u64, 0x1b710b35131c471b'u64, 0x28db77f523047d84'u64, 0x32caab7b40c72493'u64, 0x3c9ebe0a15c9bebc'u64, 
    0x431d67c49c100d4c'u64, 0x4cc5d4becb3e42b6'u64, 0x597f299cfc657e2a'u64, 0x5fcb6fab3ad6faec'u64, 0x6c44198c4a475817'u64
]

type Sha512* = ref object
    values*: array[8, uint64]
    len1: uint64
    len2: uint64
    tail: array[80, uint64]
    finished: bool

proc newSha512*(): Sha512 =
    Sha512(
        values: [
            0x6a09e667f3bcc908'u64, 0xbb67ae8584caa73b'u64, 0x3c6ef372fe94f82b'u64, 0xa54ff53a5f1d36f1'u64, 
            0x510e527fade682d1'u64, 0x9b05688c2b3e6c1f'u64, 0x1f83d9abfb41bd6b'u64, 0x5be0cd19137e2179'u64
        ]
    )

proc calculate(sha: Sha512) =
    var w = sha.tail

    var i = 16
    while i < 80:
        let s0 = rotr(w[i-15], 1) xor rotr(w[i-15], 8) xor (w[i-15] shr 7)
        let s1 = rotr(w[i-2], 19) xor rotr(w[i-2], 61) xor (w[i-2] shr 6)
        w[i] = w[i-16] + s0 + w[i-7] + s1
        i.inc

    var h = sha.values
    i = 0
    
    while i < 80:
        let S0 = rotr(h[0], 28) xor rotr(h[0], 34) xor rotr(h[0], 39)
        let ch = (h[0] and h[1]) xor (h[0] and h[2]) xor (h[1] and h[2])
        let tmp2 = S0 + ch
        let S1 = rotr(h[4], 14) xor rotr(h[4], 18) xor rotr(h[4], 41)
        let maj = (h[4] and h[5]) xor ((not h[4]) and h[6])
        let tmp1 = h[7] + S1 + maj + SHA512_CONST[i] + w[i]

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

proc add*(sha: Sha512, s: string | openarray[byte]): Sha512 {.discardable.} =
    assert(sha.finished == false, "SHA2 has been already finished")
    addImpl

proc finish*(sha: Sha512) =
    finishImpl

proc hexdigest*(sha: Sha512): string =
    toHex(64, 64)

template sha512hexdigest*(s: string): string =
    newSha512().add(s).hexdigest()