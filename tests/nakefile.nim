import os, nake
createDir("build")

task "default", "Run basic tests":
    direShell nimExe, "c", "--run", "--out:build/basic", "basic.nim"

task "sha1speed", "Run sha1 speed test vs onionhammer/sha":
    direShell nimExe, "c", "--run", "--out:build/sha1speed", "sha1speed.nim"

task "sha256speed", "Run sha1 speed test vs jangko/nimSHA2":
    direShell nimExe, "c", "--run", "--out:build/sha256speed", "sha256speed.nim"

task "sha512speed", "Run sha1 speed test vs jangko/nimSHA2":
    direShell nimExe, "c", "--run", "--out:build/sha512speed", "sha512speed.nim"