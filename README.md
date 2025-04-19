# shakar
Shakar (/ˈʃək.kəɾ/) is a library that contains a bunch of syntactic sugar for the Nim programming language. \
This package exists because a lot of these utilities apparently do not match Nim's safety guarantees (albeit it shouldn't really matter if you're paying attention).
[See this PR](https://github.com/nim-lang/Nim/pull/23261)

Shakkar means "sugar" in Hindi. :^)

This library also aims to remove all the "sugar" files in all of the different Ferus projects and unify them under a single, easy-to-modify library.

# basic usage
## optional types
```nim
import std/options
import pkg/shakar

var nam = some("John")
assert *nam    ## `*` is used to check if the optional has a value

var age = none(uint8)
assert !age    ## `!` is used to check if the optional is empty

nam.applyThis:
  ## `applyThis` gives you a mutable `this` which is either
  ## the value of the optional if it has one, or the default
  ## value of that type (`default(T)`)
  this &= " Doe"

age.applyThis:
  assert this == 0 ## default initialized value since the optional is empty
  this = 28

## Store `nam` into the `name` value. This operator returns true if the optional wasn't empty.
if nam ?= name:
  echo "Name: " & name

if age ?= ayu:
  echo "Age: " & $ayu
```
