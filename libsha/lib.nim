import macros

template rotr*(x: uint32, y: int): uint32 =
    ((x shr y) or (x shl (32 - y)))

template rotl*(x: uint32, y: int): uint32 =
    ((x shl y) or (x shr (32 - y)))

template rotr*(x: uint64, y: int): uint64 =
    ((x shr y) or (x shl (64 - y)))

template toByte*(x: SomeInteger): byte =
    (x and 0b11111111).byte

const DIGEST* = "0123456789abcdef"
template toHexTpl*(i, k, sh: int) =
    result[i] = DIGEST[(sha.values[k] shr sh).int and 0xF]

proc toHexImpl(x: NimNode, y: NimNode): NimNode =
    let len = newIntLitNode(y.intVal * 2)
    let b = x.intVal.int div 4
    let res = nnkStmtList.newTree()

    res.add(
        nnkCall.newTree(
            nnkDotExpr.newTree(
                ident("sha"),
                ident("finish")
            )
        ),
        nnkAsgn.newTree(
            ident("result"),
            nnkCall.newTree(
                ident("newString"),
                len
            )
        )
    )

    for ind in 0 ..< len.intVal:
        res.add(
            nnkCall.newTree(
                ident("toHexTpl"),
                newIntLitNode(ind),
                newIntLitNode(ind div b),
                newIntLitNode(x.intVal - 4 - (ind mod b) * 4)
            )
        )

    result = res

macro toHex*(x: untyped, y: untyped): untyped =
    result = toHexImpl(x, y)

template finishImpl* =
    if sha.finished:
        return
    sha.finished = true

    const m = BIT * 16

    let tailBit = (sha.len1 mod m).int
    var tailCur = tailBit div BIT
    var tailPos = tailBit mod BIT
    
    sha.tail[tailCur] = (sha.tail[tailCur] shl 1) or 0b1
    tailPos.inc
    sha.tail[tailCur] = sha.tail[tailCur] shl (BIT - tailPos)
    tailCur.inc

    if tailBit >= (m - (BIT * 2)):
        while tailCur < 16:
            sha.tail[tailCur] = 0
            tailCur.inc
        sha.calculate()
        tailCur = 0

    while tailCur < 14:
        sha.tail[tailCur] = 0
        tailCur.inc

    sha.tail[14] = sha.len2
    sha.tail[15] = sha.len1
    
    sha.calculate()

template addImpl* =
    result = sha

    let tailBit = (sha.len1 mod (BIT.uint32 * 16)).int
    var tailCur = tailBit div BIT
    var tailPos = tailBit mod BIT

    var i = 0
    while i < s.len:
        sha.tail[tailCur] = (sha.tail[tailCur] shl 8) or s[i].byte
        tailPos += 8
        if tailPos == BIT:
            tailPos = 0
            tailCur.inc
            if tailCur == 16:
                tailCur = 0
                sha.calculate()
        sha.len1.inc(8)
        if sha.len1 == 0:
            sha.len2.inc
        i.inc

template hToValues*(i: int) =
    sha.values[i] += h[i]

proc calcValuesImpl(x: NimNode): NimNode =
    var res = nnkStmtList.newTree()
    for i in 0 ..< x.intVal:
        res.add(
            nnkCall.newTree(
                ident("hToValues"),
                newIntLitNode(i)
            )
        )
    result = res

macro calcValues*(x: untyped): untyped =
    result = calcValuesImpl(x)