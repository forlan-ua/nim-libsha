import libsha, strutils

let message = "The quick brown fox jumps over the lazy dog"

let sha1Inst = newSha1().add(message)
echo "sha1: ", sha1Inst.hexdigest().insertSep(' ', 8)
assert(sha1Inst.hexdigest().toUpperAscii().insertSep(' ', 8) == "2FD4E1C6 7A2D28FC ED849EE1 BB76E739 1B93EB12")

let sha256Inst = newSha256().add(message)
echo "sha256: ", sha256Inst.hexdigest().insertSep(' ', 8)
assert(sha256Inst.hexdigest().toUpperAscii().insertSep(' ', 8) == "D7A8FBB3 07D78094 69CA9ABC B0082E4F 8D5651E4 6D3CDB76 2D02D0BF 37C9E592")

let sha256Inst2 = newSha256()
sha256Inst2.add(message[0 ..< 20])
sha256Inst2.add(message[20 ..< message.len])
assert(sha256Inst2.hexdigest().toUpperAscii().insertSep(' ', 8) == "D7A8FBB3 07D78094 69CA9ABC B0082E4F 8D5651E4 6D3CDB76 2D02D0BF 37C9E592")

assert(sha256hexdigest("The quick brown fox jumps over the lazy cog").toUpperAscii().insertSep(' ', 8) == "E4C4D8F3 BF76B692 DE791A17 3E053211 50F7A345 B46484FE 427F6ACC 7ECC81BE")

let sha224Inst = newSha224().add(message)
echo "sha224: ", sha224Inst.hexdigest().insertSep(' ', 8)
assert(sha224Inst.hexdigest().toUpperAscii().insertSep(' ', 8) == "730E109B D7A8A32B 1CB9D9A0 9AA2325D 2430587D DBC0C38B AD911525")

let sha512Inst = newSha512().add(message)
echo "sha512: ", sha512Inst.hexdigest().insertSep(' ', 8)
assert(sha512Inst.hexdigest().toUpperAscii().insertSep(' ', 8) == "07E547D9 586F6A73 F73FBAC0 435ED769 51218FB7 D0C8D788 A309D785 436BBB64 2E93A252 A954F239 12547D1E 8A3B5ED6 E1BFD709 7821233F A0538F3D B854FEE6")

let sha384Inst = newSha384().add(message)
echo "sha384: ", sha384Inst.hexdigest().insertSep(' ', 8)
assert(sha384Inst.hexdigest().toUpperAscii().insertSep(' ', 8) == "CA737F10 14A48F4C 0B6DD43C B177B0AF D9E51693 67544C49 4011E331 7DBF9A50 9CB1E5DC 1E85A941 BBEE3D7F 2AFBC9B1")

let sha512M224Inst = newSha512M224().add(message)
echo "sha512/224: ", sha512M224Inst.hexdigest().insertSep(' ', 8)
assert(sha512M224Inst.hexdigest().toUpperAscii().insertSep(' ', 8) == "944CD284 7FB54558 D4775DB0 485A5000 3111C8E5 DAA63FE7 22C6AA37")

let sha512M256Inst = newSha512M256().add(message)
echo "sha512/256: ", sha512M256Inst.hexdigest().insertSep(' ', 8)
assert(sha512M256Inst.hexdigest().toUpperAscii().insertSep(' ', 8) == "DD9D67B3 71519C33 9ED8DBD2 5AF90E97 6A1EEEFD 4AD3D889 005E532F C5BEF04D")