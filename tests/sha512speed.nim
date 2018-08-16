import times, strutils
import libsha / sha512
import nimSHA2

let message = "The quick brown fox jumps over the lazy dog"

let sha512Inst = newSha512().add(message)
assert(sha512Inst.hexdigest().insertSep(' ', 8) == "07E547D9 586F6A73 F73FBAC0 435ED769 51218FB7 D0C8D788 A309D785 436BBB64 2E93A252 A954F239 12547D1E 8A3B5ED6 E1BFD709 7821233F A0538F3D B854FEE6")

echo " "
echo "Sha512 implementation vs jangko/nimSHA2. Sum - total time, Avg - avarage time"
echo "10 tests, 100 probs, 10000 calculations"
echo " "

proc test() {.gcsafe.} =
    let message = "The quick brown fox jumps over the lazy dog"

    var sum1 = 0.0
    var sum2 = 0.0
    var avg1 = 0.0
    var avg2 = 0.0
    
    for i in 0 ..< 100:
        let s1 = epochTime()
        for i in 0 ..< 10000:
            discard computeSHA512(message).toHex()
        let d1 = epochTime() - s1
        sum1 += d1
        if avg1 == 0.0:
            avg1 = d1
        else:
            avg1 = (avg1 + d1) / 2

        let s2 = epochTime()
        for i in 0 ..< 10000:
            discard sha512hexdigest(message)
        let d2 = epochTime() - s2
        sum2 += d2
        if avg2 == 0.0:
            avg2 = d2
        else:
            avg2 = (avg2 + d2) / 2

    echo "jangko/nimSHA2:    sum: ", sum1, ", avg: ", avg1
    echo "forlan-ua/lib-sha: sum: ", sum2, ", avg: ", avg2
    echo "sum: ", (sum2 - sum1) / sum2 * 100, "%, avg: ", (avg2 - avg1) / avg2 * 100, "%"
    echo " "


for i in 0 ..< 10:
    test()