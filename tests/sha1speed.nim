import times, strutils
import libsha / sha1
import shaa1

let message = "The quick brown fox jumps over the lazy dog"

let sha1Inst = newSha1().add(message)
echo "sha1: ", sha1Inst.hexdigest().insertSep(' ', 8)
assert(sha1Inst.hexdigest().insertSep(' ', 8) == "2FD4E1C6 7A2D28FC ED849EE1 BB76E739 1B93EB12")

echo "Sha1 implementation vs onionhammer/sha1. Sum - total time, Avg - avarage time"

proc test() {.gcsafe.} =
    let message = "The quick brown fox jumps over the lazy dog"

    var sum1 = 0.0
    var sum2 = 0.0
    var avg1 = 0.0
    var avg2 = 0.0
    
    for i in 0 ..< 100:
        let s1 = epochTime()
        for i in 0 ..< 50000:
            discard shaa1.compute(message).toHex()
        let d1 = epochTime() - s1
        sum1 += d1
        if avg1 == 0.0:
            avg1 = d1
        else:
            avg1 = (avg1 + d1) / 2

        let s2 = epochTime()
        for i in 0 ..< 50000:
            discard sha1hexdigest(message)
        let d2 = epochTime() - s2
        sum2 += d2
        if avg2 == 0.0:
            avg2 = d2
        else:
            avg2 = (avg2 + d2) / 2

    echo "sum: ", (sum2 - sum1) / sum1 * 100, "%, avg: ", (avg2 - avg1) / avg1 * 100, "%"


for i in 0 ..< 10:
    test()