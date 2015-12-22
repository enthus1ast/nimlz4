import lz4
import clz4frame
import unittest
import osproc

suite "NimLZ4 tests":
  
  setup:
    when defined(windows):
      discard execCmdEx("fsutil file createnew input.file 50000000")
    else:
      discard execCmdEx("dd if=/dev/urandom of=input.file bs=1M count=50")
      
      var input = readFile("input.file")

  tearDown:
    discard execCmdEx("rm input.file")

  test "LZ4 fast compression and decompression is correct":
    var compressed = compress(input,level=2)
    var uncompressed = uncompress(compressed)
    check(uncompressed==input)

  test "LZ4 compression and decompression of frames is correct":
    var prefs = newLZ4F_preferences()
    var compressed = compress_frame(input,prefs)
    var decompressed = uncompress_frame(compressed)
    check(input == decompressed)




