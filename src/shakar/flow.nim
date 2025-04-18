template unreachable*() =
  ## Use this template to annotate unreachable branches.
  runnableExamples:
    import std/random

    let x = rand(0 .. 1)
    case x
    of 0:
      echo "zero"
    of 1:
      echo "one"
    else:
      unreachable
      # This will never execute. If it does, it'll crash the program since you never accounted for it.

  assert(false, "Unreachable")
