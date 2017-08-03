(* The reverse polish machine

The execution of the machine is simple. It has a stack and as long as
it sees values, it pushes them. Once it sees an operator it pops the
appropriate number of elements from the stack, applies the operator,
and pushes the result.



*)
structure Machine =
struct

(* The instructions of the machine *)

datatype Inst    = Exec of Ast.BinOp | Push of int | ClearStack | PrintTop | PrintStack
type     Program = Inst list

fun instToString (Exec oper) = Ast.binOpToString oper
  | instToString (Push x   ) = Int.toString x
  | instToString ClearStack  = "c"
  | instToString PrintTop    = "p"
  | instToString PrintStack  = "s"

val programToString = String.concatWith " " o List.map instToString


(* Run the stack machine *)
type     Stack   = int list
val flushit = TextIO.flushOut TextIO.stdOut

fun stackUnderflow stack = (print "error: stack underflow" ; OS.Process.exit (OS.Process.failure); stack)
fun printstack stack = let val conts = String.concatWith ", " (List.map Int.toString stack)
		       in print ("[" ^ conts ^ "]\n"); flushit
		       end

fun printtop (x::xs) = (print (Int.toString x ^ "\n"); flushit)
  | printtop _       = (print "error: empty stack\n"; flushit)




fun step (Push x)     stack           = x :: stack
  | step PrintStack   stack           = (printstack stack; stack)
  | step PrintTop     stack           = (printtop stack; stack)
  | step ClearStack   _               = []
  | step (Exec oper) (a :: b :: rest) = Ast.binOpDenote oper a b :: rest
  | step _           stack            = stackUnderflow stack

val run = List.foldl (fn (inst,stack) => step inst stack) []

fun runWithLexer lexer = let fun loop stack = case lexer () of
						  NONE      => ()
					       |  SOME inst => loop (step inst stack)
			 in loop []
			 end
end
