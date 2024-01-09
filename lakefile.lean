import Lake
open Lake DSL

package «lean4-metaprogramming-book» where
  srcDir := "lean"

lean_lib «lean4-metaprogramming-book» where
  roots := #[`cover, `extra, `main, `solutions]
  globs := #[Glob.one `cover, Glob.submodules `extra, Glob.submodules `main, Glob.submodules `solutions]

require mdgen from git
  "https://github.com/Seasawher/mdgen" @ "fdb5627700a414db65d6905973b06dac64932865"

def runCmd (cmd : String) (args : Array String) : ScriptM Bool := do
  let out ← IO.Process.output {
    cmd := cmd
    args := args
  }
  let hasError := out.exitCode != 0
  if hasError then
    IO.eprint out.stderr
  return hasError

script build do
  if ← runCmd "lake exe mdgen" #["lean", "md"] then return 1
  return 0
