import libsha, strutils, sequtils

let message = "The quick brown fox jumps over the lazy dog"
let longMessage = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas sodales mollis efficitur. Fusce sed enim erat. Integer ut magna mi. Etiam sit amet vulputate tellus. Sed tincidunt imperdiet erat, sed tincidunt metus luctus at. Aliquam ligula elit, elementum dignissim fermentum at, pellentesque et urna. Phasellus turpis felis, gravida in dolor vel, iaculis efficitur turpis. Etiam et feugiat leo. Proin leo ante, semper ut vestibulum in, condimentum in enim. Morbi at porta tellus. Etiam in nisi arcu. Pellentesque a finibus est. Aenean scelerisque semper mollis. Curabitur eget tortor nibh. Donec suscipit tellus at ornare euismod. Nulla hendrerit orci quis risus hendrerit congue. Proin diam orci, dapibus sed mauris a, fringilla blandit diam. Nunc dapibus nisi nisl, eget pharetra turpis bibendum in. Mauris ut nisi tempor, maximus risus ut, ullamcorper libero. Proin id accumsan est. Integer ultrices felis eget purus pellentesque molestie. Suspendisse laoreet euismod viverra. Sed vitae arcu eleifend, finibus mauris tristique, facilisis nulla. Donec luctus massa accumsan rhoncus condimentum. Duis eu orci molestie, iaculis sapien non, mattis lectus. Interdum et malesuada fames ac ante ipsum primis in faucibus. Aliquam a vestibulum lacus. Fusce urna tortor, cursus sed ipsum vitae, lobortis condimentum odio. Vestibulum at eros eros. Donec aliquam pulvinar aliquet. Suspendisse ultricies, mauris at elementum cursus, mi felis mattis lacus, pretium egestas eros purus vel elit. Quisque molestie purus elementum, sollicitudin ex id, aliquam leo. Aenean eros est, consequat mattis faucibus ut, egestas vitae eros. Cras tincidunt quam eget eros sagittis consectetur. Sed varius sem varius venenatis ullamcorper. Morbi cursus congue augue, et iaculis purus iaculis a. Quisque sed sapien rutrum, rhoncus ligula sit amet, elementum ante. Phasellus suscipit vestibulum risus, a dictum lorem ultricies vel. Donec a neque ac enim tincidunt cursus in cursus ligula. Donec sodales leo quis elit ullamcorper semper eu sit amet massa. Maecenas eu ante nec turpis pulvinar malesuada ac sit amet libero. Vestibulum hendrerit, nulla ut congue rutrum, quam elit placerat lectus, eu laoreet eros nunc at magna. Fusce sit amet gravida felis. Pellentesque iaculis eros ac quam pharetra ultricies. Mauris vestibulum imperdiet urna et bibendum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer vulputate libero egestas quam sollicitudin, nec fringilla erat volutpat. Suspendisse fermentum nulla sodales euismod rutrum. Phasellus accumsan eros ac tincidunt lobortis. Integer mattis interdum nibh, eu volutpat dui feugiat ac. Maecenas non fringilla erat, a posuere sapien. Aenean et faucibus purus. Donec fermentum justo sollicitudin ipsum tincidunt venenatis. Etiam fermentum ipsum quis est dapibus, quis ultrices sapien eleifend. Fusce iaculis mi finibus leo facilisis, eu tincidunt sem venenatis. Proin nec urna est. Praesent nec efficitur enim, vel pellentesque nisi. Interdum et malesuada fames ac ante ipsum primis in faucibus. Maecenas suscipit vestibulum leo, id luctus risus posuere eu. In nec ipsum a urna molestie sagittis at a massa. Pellentesque finibus, orci at tincidunt tincidunt, odio leo porttitor erat, ac accumsan libero erat a justo. Nullam vitae nisi ac purus fermentum dictum in commodo urna. Ut tristique nisi leo, et efficitur leo consectetur a. Praesent ac augue gravida est vestibulum ultrices pretium eu lorem. Nullam fringilla justo est, ut euismod lorem ultricies ut. Integer molestie augue eu finibus fringilla."
var longTextSeq = longMessage.split().map(proc(x: string): string = x & " ")
longTextSeq[longTextSeq.high] = longTextSeq[longTextSeq.high].strip()

let sha1Inst = newSha1().add(message)
echo "sha1: ", sha1Inst.hexdigest().insertSep(' ', 8)
assert(sha1Inst.hexdigest().insertSep(' ', 8) == "2FD4E1C6 7A2D28FC ED849EE1 BB76E739 1B93EB12")
assert(sha1hexdigest(message) == sha1Inst.hexdigest())
assert(sha1hexdigest(longMessage).toLowerAscii() == "a54d0cf64e948e846015b46848017ed8b2f0d1cc")

let sha1LongInst = newSha1()
for i in longTextSeq:
    sha1LongInst.add(i)
assert(sha1LongInst.hexdigest() == sha1hexdigest(longMessage))

let sha256Inst = newSha256().add(message)
echo "sha256: ", sha256Inst.hexdigest().insertSep(' ', 8)
assert(sha256Inst.hexdigest().insertSep(' ', 8) == "D7A8FBB3 07D78094 69CA9ABC B0082E4F 8D5651E4 6D3CDB76 2D02D0BF 37C9E592")
assert(sha256hexdigest(message) == sha256Inst.hexdigest())
assert(sha256hexdigest(longMessage).toLowerAscii() == "6e475395edb34694d5d76d864587ea06559b6eea41886b1012b8ae2a769abc6a")

let sha256LongInst = newSha256()
for i in longTextSeq:
    sha256LongInst.add(i)
assert(sha256LongInst.hexdigest() == sha256hexdigest(longMessage))

let sha256Inst2 = newSha256()
sha256Inst2.add(message[0 ..< 20])
sha256Inst2.add(message[20 ..< message.len])
assert(sha256Inst2.hexdigest().insertSep(' ', 8) == "D7A8FBB3 07D78094 69CA9ABC B0082E4F 8D5651E4 6D3CDB76 2D02D0BF 37C9E592")

assert(sha256hexdigest("The quick brown fox jumps over the lazy cog").insertSep(' ', 8) == "E4C4D8F3 BF76B692 DE791A17 3E053211 50F7A345 B46484FE 427F6ACC 7ECC81BE")

let sha224Inst = newSha224().add(message)
echo "sha224: ", sha224Inst.hexdigest().insertSep(' ', 8)
assert(sha224Inst.hexdigest().insertSep(' ', 8) == "730E109B D7A8A32B 1CB9D9A0 9AA2325D 2430587D DBC0C38B AD911525")
assert(sha224hexdigest(message) == sha224Inst.hexdigest())

let sha512Inst = newSha512().add(message)
echo "sha512: ", sha512Inst.hexdigest().insertSep(' ', 8)
assert(sha512Inst.hexdigest().insertSep(' ', 8) == "07E547D9 586F6A73 F73FBAC0 435ED769 51218FB7 D0C8D788 A309D785 436BBB64 2E93A252 A954F239 12547D1E 8A3B5ED6 E1BFD709 7821233F A0538F3D B854FEE6")
assert(sha512hexdigest(message) == sha512Inst.hexdigest())
assert(sha512hexdigest(longMessage).toLowerAscii() == "79ed99a1dc96ef408d56a933383ca57c1c9145033f764389034f3346b837eccedb6b2879d4e8162aa4d8872229da4ee97bed5845c1b261938790d4c7ee0a634a")

let sha512LongInst = newSha256()
for i in longTextSeq:
    sha512LongInst.add(i)
assert(sha512LongInst.hexdigest() == sha512hexdigest(longMessage))

let sha384Inst = newSha384().add(message)
echo "sha384: ", sha384Inst.hexdigest().insertSep(' ', 8)
assert(sha384Inst.hexdigest().insertSep(' ', 8) == "CA737F10 14A48F4C 0B6DD43C B177B0AF D9E51693 67544C49 4011E331 7DBF9A50 9CB1E5DC 1E85A941 BBEE3D7F 2AFBC9B1")
assert(sha384hexdigest(message) == sha384Inst.hexdigest())
assert(sha384hexdigest(longMessage).toLowerAscii() == "aec27ceac16984d80ffb7febc93d0553e10bc5078af3c04cf182672bd56ae924558635f045fd80c7ed92d40edab71583")

let sha512M224Inst = newSha512M224().add(message)
echo "sha512/224: ", sha512M224Inst.hexdigest().insertSep(' ', 8)
assert(sha512M224Inst.hexdigest().insertSep(' ', 8) == "944CD284 7FB54558 D4775DB0 485A5000 3111C8E5 DAA63FE7 22C6AA37")
assert(sha512M224hexdigest(message) == sha512M224Inst.hexdigest())

let sha512M256Inst = newSha512M256().add(message)
echo "sha512/256: ", sha512M256Inst.hexdigest().insertSep(' ', 8)
assert(sha512M256Inst.hexdigest().insertSep(' ', 8) == "DD9D67B3 71519C33 9ED8DBD2 5AF90E97 6A1EEEFD 4AD3D889 005E532F C5BEF04D")
assert(sha512M256hexdigest(message) == sha512M256Inst.hexdigest())