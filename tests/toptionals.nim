import std/[unittest, options]
import shakar

suite "optionals":
  var a = some "hello wor"
  var b = none(int)
  var c = none(string)

  test "empty/full checks":
    check *a
    check !b

  test "get values":
    check &a == "hello wor"

  test "apply to full option":
    a.applyThis:
      this &= "ld"

    check &a == "hello world"

  test "apply to empty option":
    b.applyThis:
      this += 1337

    check &b == 1337

  test "store to identifier":
    if a ?= x:
      check x == "hello world"
    else:
      fail

    if b ?= y:
      check y == 1337
    else:
      fail

    if c ?= z:
      fail
    else:
      check !c
