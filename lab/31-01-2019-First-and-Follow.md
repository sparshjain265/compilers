# Computing First and follow

Given a grammar as input, write functions to compute the first and
follow sets for the symbols of the grammar.


## Representing Grammars.

The first task is to have a clean representation of grammars. Make use
of the [Atom][atom] type to represent symbols and tokens in your
grammar. [Atom][atom] should be though of as an efficient
representation of strings and is a good way to represent identifiers,
keywords and other stringy types inside the compiler. The right hand
side of a rule is just a list of [Atom.atom][atom]. With these in
mind, a grammar is a record that contains the following.


1. The sets `symbols` and `tokens` of atoms that denote the symbols
   and tokens respectively of the grammar.

2. A dictionary of key value pairs which corresponds to rules of the
   grammar.  The key's are atoms corresponding to each symbol of the
   grammar and the value is the set of productions associated with the
   grammar.


You can use the [AtomSet][atomset] structure for capturing set of
atoms. Also you can use the [AtomMap][atommap] structure to keep track
of the productions of the grammar. Here is a suggested representation
of the grammar.

```sml
type RHS = Atom.atom list  (* The RHS γ of a rule A -> γ *)

(*

We have the structures AtomSet and AtomMap to represent sets and maps
of Atoms. For any type t if we want sets and maps (dictionaries) we
need an ordering structure on the elements.  We would like to create
the set structure on RHS's. For this you first need to define a
structure of signature ORD_KEY for RHS.

*)

structure RHS_KEY : ORD_KEY = struct
	(* complete this *)
end
*)

(*

Use the above structure to create a set of rhs's

*)

structure RHSSet = RedBlackSetFn (RHS_KEY)

type Productions = RHSSet.set

(* The rules of the grammar are a dictionary whose keys are the symbol
   and the values are the Productions associated with the grammar.
*)

type Rules = Productions AtomMap.map


type Grammar    = { symbols : AtomSet.set, tokens : AtomSet.set, rules : Rules }

```

[atom]: <https://www.classes.cs.uchicago.edu/archive/2015/spring/22620-1/atom-sig.html>
[atomset]: <https://www.classes.cs.uchicago.edu/archive/2015/spring/22620-1/ord-set-sig.html#instances>
[atommap]: <https://www.classes.cs.uchicago.edu/archive/2015/spring/22620-1/ord-map-sig.html#instances>
