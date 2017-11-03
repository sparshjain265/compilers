---
title: The type inference problem
header-includes:
    - \usepackage{amssymb}
	- \usepackage{amsmath}
    - \usepackage[mathletters]{ucs}
	- '\newcommand{\fun}[2]{\ensuremath{\mathbf{fun}\ #1 \Rightarrow #2}}'

---

# The type inference problem.

Languages like ML and Haskell infer the type of the expressions from
the context. We give a quick overview of this algorithm. The type
inference problem is given an expression with no type annotations, we
want to infer the type of the expression. If given the expression $e =
fun x => x$, the type `int -> int` is a valid type for it and so is
`char -> char`. The ML compiler is smart enough to infer that this
expression the polymorphic type `'a -> 'a`. In other words, the
inference algorithm should infer the *most general possible type*.

## The Language

Instead of working with the entire ML language we take the following
toy programming language given by the abstract syntax.

```
expr = variables like x y z
     | true
     | false
	 | f e
	 | fun x => e
```


For type inference algorithm, we need formulate a system of
polymorphic types. Clearly our language has `Bool` as a type. We also
need type variables to capture polymorphic types. In ML when we say
that an expression has type `'a -> 'b -> 'a` what we mean is that `'a`
and `'b` can take any possible types. In our setting, we would like to
make it more precise and quantify. We do this by having two kinds of
types, _mono-types_ (usually denoted by $\tau$ with appropriate
suffixes) and _type schemes_. These are given by the abstract syntax.


$$
\tau = \textit{type variables like } \alpha, \beta ... \ |\  \mathbf{Bool} \ | \ \tau_1 \to \tau_2 \ (\mathrm{monotypes})
$$
$$
\sigma = \tau \ | \  \forall \alpha . \sigma' (\textrm{type schemes})
$$

The important thing is that all quantification is at the outer most
layer. As mentioned in the setting of a language like ML, when we say
that an expression has a type `'a -> 'b` there is an implicit
$\forall$-quantification over all the type variables in the type.
