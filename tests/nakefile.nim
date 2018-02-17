import os, nake
createDir("build")

task "default", "Run basic tests":
    direShell nimExe, "c", "--run", "--out:build/basic", "basic.nim"

task "sha1speed", "Run sha1 speed test vs onionhammer/sha":
    direShell nimExe, "c", "--run", "--out:build/sha1speed", "sha1speed.nim"