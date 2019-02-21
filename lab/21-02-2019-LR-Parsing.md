# LR parsing.

In the class we have seen LR(0), SLR(1), LR(1) parsing table
construction. Define algorithms for computing the parsing automata.

## Representing Items

Recall the representation of a grammar from [a previous
assignment](31-01-2019-First-and-Follow.md). Define a datatype to
capture an LR(0) item. While the obvious way is to capture it as a
tuple of the lhs symbol (atom), the rhs (list of atoms), and an
integer index that captures the position of the "dot", you can try your
hand at the following interesting representation.

```

type Item = { lhs    : atom      (* the left hand side *)
            , before : atom list (* the symbols/tokens before the dot
	                              in the rhs in reverse order
							      *)
	        , after : atom list  (* The symbols/tokens after the dot *)
		    }


```

Thus the item `A -> aA . bB` would be represented as the item

```
val aItem = { lhs       = atom "A"
              before = List.map atom ["A", "a"]
              after  = List.map atom ["b", "B"]
            }
```

Note that the before is kept in reverse order. The advantage of this
method is that "moving the dot", when computing shift and gotos can be
done in one step.

## Representing states.

States can explicitly be represented as sets of items. But for this
one needs to provide a comparison function for items (which is not
difficult to do). You can use the same technique that is used in atoms
to make comparison of items and sets of items efficient.

Given below is a incomplete description which gives a integer proxy
for all elements of a given ord structure. You can see the analogy
with atoms which are proxies to strings.


```
signature PROXY = sig
   type proxy
   type actual

   val proxy  : actual -> proxy
   val actual : proxy -> actual
end

functor Proxy(structure A : ORD_KEY) : PROXY = struct
	type proxy = int
	type sofar = ref 0
	type proxyMap = ref (map from A.ord_key to int)
	type reverseMap = ref (map from int -> A.ord_key)

	val proxy :
	val actual : proxy -> A.ord_key

	. . .
end
```


[atom]: <https://www.classes.cs.uchicago.edu/archive/2015/spring/22620-1/atom-sig.html>
[atomset]: <https://www.classes.cs.uchicago.edu/archive/2015/spring/22620-1/ord-set-sig.html#instances>
[atommap]: <https://www.classes.cs.uchicago.edu/archive/2015/spring/22620-1/ord-map-sig.html#instances>
[left-recursion]: <https://en.wikipedia.org/wiki/Left_recursion>
