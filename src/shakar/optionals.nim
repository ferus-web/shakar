## Syntactic sugar for `Option[T]` and `Result[T]`
import std/[options]
import pkg/[results]

func `*`*[T](opt: Option[T]): bool {.inline.} =
  ## This function returns `true` if `opt` contains a value
  ## and `false` otherwise.
  ##
  ## **See also**:
  ## - `proc ![T](Option[T]): bool`_ to check if an `Option[T]` is empty.
  runnableExamples:
    var x = some("Hallo Erde")
    assert *x

  isSome(opt)

func `!`*[T](opt: Option[T]): bool {.inline.} =
  ## This function returns `true` if `opt` is empty
  ## and `false` otherwise.
  ##
  ## **See also**:
  ## - `proc *[T](Option[T]): bool`_ to check if an `Option[T]` contains a value.
  runnableExamples:
    var x = none(string)
    assert !x

  isNone(opt)

template `&`*[T](opt: Option[T]): T =
  ## This template can be used to get the value inside of an `Option[T]`.
  ## It calls `get()` under the hood, so if the optional is empty,
  ## you'll get a similar error unless you check for this and abort beforehand.
  ##
  ## **See also**:
  ## - `proc *[T](Option[T]): bool`_ to check if an `Option[T]` contains a value.
  ## - `proc ![T](Option[T]): bool`_ to check if an `Option[T]` is empty.
  runnableExamples:
    var x = some("Hello world")
    assert &x == "Hello world"

    var y = none(int)
    assert &y == 1337 # This will fail as the optional is empty.

  (opt.get())

template `?=`*[T](opt: Option[T], store: untyped): bool =
  ## This template can be used to store the value of `opt` into an
  ## identifier of your choice. It returns `true` if the optional
  ## had a value, and `false` otherwise.
  ##
  ## **See also**:
  ## - `proc *[T](Option[T]): bool`_ to check if an `Option[T]` contains a value.
  ## - `proc ![T](Option[T]): bool`_ to check if an `Option[T]` is empty.
  ## - `template &[T](Option[T]): T`_ to extract the value from an optional directly.
  runnableExamples:
    var x = some("Namaste Prithvi")
    if x ?= greeting: # Store the unpacked value of `x` into `greeting` for this scope.
      echo greeting

    # You can no longer access `greeting` out here.

    var y = none(int)
    if y ?= num: # This won't be executed as `y` is an empty optional.
      echo num + 5

  let full = *opt
  var store: T
  if full:
    store = opt.get()

  full

template applyThis*[T](opt: var Option[T], body: untyped) =
  ## "Apply" or mutate the inner value of an optional.
  ## 
  ## **Note**: If the optional is empty, the "inner value" is essentially
  ## the default state for that optional's type.
  ## 
  ## **See also**:
  ## - `proc *[T](Option[T]): bool`_ to check if an `Option[T]` contains a value.
  ## - `proc ![T](Option[T]): bool`_ to check if an `Option[T]` is empty.
  ## - `template &[T](Option[T]): T`_ to extract the value from an optional directly.
  ## - `template ?=[T](Option[T], untyped): bool`_ for an operator that neatly lets you
  ##    extract values from an optional.
  runnableExamples:
    var name = some("John")
    name.applyThis:
      this &= " Doe"

    assert &name == "John Doe"

    var age = none(int)
    age.applyThis:
      this += 20

    assert &age == 20

  block:
    var this {.inject.} =
      if *opt:
        &opt
      else:
        default(T)

    body

    opt = some(this)

func `*`*[T, E](res: Result[T, E]): bool {.inline.} =
  ## This function returns `true` if `res` contains a value
  ## and `false` otherwise.
  ##
  ## **See also**:
  ## - `proc ![T, E](Result[T, E]): bool`_ to check if a `Result[T, E]` is empty.
  runnableExamples:
    var x = ok("Hallo Erde")
    assert *x

  isOk(res)

func `!`*[T, E](res: Result[T, E]): bool {.inline.} =
  ## This function returns `true` if `res` has an error
  ## and `false` otherwise.
  ##
  ## **See also**:
  ## - `proc *[T, E](Result[T, E]): bool`_ to check if a `Result[T, E]` contains a value.
  runnableExamples:
    var x = Result[void, string].err("Silly stupid error")
    assert !x

  isErr(res)

template `&`*[T, E](opt: Result[T, E]): T =
  ## This template can be used to get the value inside of a `Result[T, E]`.
  ## It calls `get()` under the hood, so if the result has an error,
  ## you'll get a similar error unless you check for this and abort beforehand.
  ##
  ## **See also**:
  ## - `proc *[T, E](Result[T, E]): bool`_ to check if a `Result[T, E]` contains a value.
  ## - `proc ![T, E](Result[T, E]): bool`_ to check if a `Result[T, E]` is empty.
  runnableExamples:
    var x = ok("Hello world")
    assert &x == "Hello world"

    var y = Result[int, string].err("Woops.")
    assert &y == 1337 # This will fail as the optional is empty.

  (opt.get())
