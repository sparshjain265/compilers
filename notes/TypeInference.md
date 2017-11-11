# The type inference problem.

Languages like ML and Haskell infer the type of the expressions from
the context. We give a quick overview of this algorithm. The type
inference problem is the following: given an expression with no type
annotations, we want to infer the type of the expression from the way
the different variables are used. If given the expression `e = fun x
=> x`, the type `int -> int` is a valid type for it and so is `char ->
char`. The ML compiler is smart enough to infer that this expression
the polymorphic type `'a -> 'a`. In other words, the inference
algorithm should infer the *most general possible type*.

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
types, _mono-types_ (usually denoted by `τ` with appropriate
suffixes) and _type schemes_. These are given by the abstract syntax.

```
τ := α,β...   (type variables)
   | bool     (basic types of the language)
   | τ₁ -> τ₂ (function types)

σ := τ        (any mono-type)
   | ∀ α . σ'

```

The important thing is that all quantification is at the outer most
layer. For example the type `(∀α α) -> (∀ β . β)` is *not* a valid
type scheme. In the above language of mono-types and type schemes, the
type of the id function in ML `'a -> 'a` is actually the type scheme
`∀α (α -> α)` where as the type `α -> α` should be read as the
mono-type of a function form some fixed (but yet to be decided
monotype `α`) to the same type `α`.

## Type inference rules.


To decide whether the judgement `e : σ` we need to know what are the
types of the *free variables* in `e`. A type context `Γ` is list of
assumptions on variables, i.e. it is a list of assumptions of the kind
`x₁ : σ₁, x₂ : σ₂` etc. We use `Γ ⊢ e : σ` to denote that under the
context `Γ`, `e` can be derived the type `σ`. The rules of inference
is defined as a set of preconditions together with a conclusion.

1. The variable rule __VAR__

        ---------------------
        Γ ∪ {x : τ} |- x : τ

   This should be interpreted as: we can derive `x : τ` given that it
   is already in the assumptions. We do not need any pre-condition for
   it.

2. The application rule __APP__

        Γ ⊢ f : τ₁ -> τ₂
        Γ ⊢ e : τ₁
        ---------------------
        Γ ⊢ f e : τ₂

   This should be read as: If we already manage to prove that `f` has
   type `τ₁ -> τ₂` and `e` has type `τ₁` then we can conclude that `f
   e` has type `τ₂`

3. The abstraction rule __ABS__.

        Γ ∪ { x : τ₁} ⊢ e : τ₂
		----------------------
		Γ ⊢ (fun x => e) : τ₁ -> τ₂

    This should be read as: If under the *additional assumption* `x :
	τ₁` we can prove `e` has type `τ₂`, then we can conclude with
	*just the assumptions* `Γ` that `fun x => e` has type `τ₁ -> τ₂`

The above rules are for mono-types. We need to include additional
rules for generalisation and specialisation.

4. The generalisation rule __GEN__

        Γ ⊢ e : σ
		α is not free in Γ
		------------------------
		Γ ⊢ e : ∀ α . σ

	That the variable `α` should not be free in any of the types that
    occur in the context Γ is crucial requirement.

5. The specialisation rule __SPEC__

        Γ ⊢ e : ∀α . σ
		τ is any mono-type
		------------------------
		Γ ⊢ e : σ[α/τ]

There should also be a rule for each constants of your language.

__Exercise:__
:  What is the inference rule for the constant `true`.


A *type derivation* is a list of judgements of the kind `Γ ⊢ e : σ`
where each statement is either a variable rule or is derived from a
previous rule using one of the above inference rules. Here is the
example for the identity function `fun x => x`.

```
1. x : α ⊢ x : α               (By VAR)
2. ⊢ fun x => x : α -> α       (By ABS on 1)
3. ⊢ fun x => x : ∀α . α -> α  (By GEN on 2)
```

We say that the expression `e` has type `σ` under the assumptions `Γ`
if there is a *type derivation* whose last statement is the judgement
`Γ ⊢ e : σ`. It is possible that some expression `e` is not well
typed, in which case it is impossible to find any *type derivation*
whose conclusion is `Γ ⊢ e : σ` for any `σ`. In such cases we say that
`e` is *not typeable*.

__Type Inference algorithm:__
:  Given as input a type assumption `Γ` and an expression `e` either
   (1) Compute a type scheme `σ` such that `Γ |- e : σ` is derivable or
   (2) prints error if `e` is not typeable.

## Most general type.

It is desirable that the inference algorithm should compute the most
general type which means that we should be able to compare types in
terms of their generality. For the type scheme `σ = ∀α₁∀α₂... τ`, the
type `τ' = τ[α₁/τ₁][α₂/τ₂]...` is a specialisation. What is important
is that if `β₁,β₂...` are type variable that are not free in `τ` then
even `σ' = ∀β₁∀β₂...τ'` is also a specialisation. In other words any
type scheme `σ'` obtained from `σ = ∀α₁∀α₂... τ` by the following two
step process.

1. Perform the substitutes `[α₁/τ₁][α₂/τ₂]...` in `τ` to obtain `τ'`.

2. Quantify over the variables `β₁,β₂...` which are not in the
   original type `τ`.

In such a case we denote that `σ' ≤ σ`

__Exercise:__
:   Show that if `σ' ≤ σ` then `Γ ⊢ e : σ` implies that `Γ |- e : σ'`.
    Hint: By appropriate change of bound variables in `σ` and `σ'` we
    can ensure that they are distinct and not occurring in `Γ`. It is
    then a question of generalisation and specialisation.


## Unification

The inference algorithm makes use of type variables and in the process
generates constraints that says `τ₁ ≡ τ₁', τ₂ ≡ τ₂' ...`. A solution
to such a set of constraints is a *list* of substitutions `𝒮 = α₁/t₁,
α₂/t₂ ...` such that it:

1. Should have the *telescoping* property, i.e.  the variables of `tᵢ`
   should only be from the set `αᵢ₊₁ …`.

2. Should makes the types `τⱼ[𝒮]` and `τⱼ'[𝒮]` identical, i.e. the
substitution should *unify* `τⱼ` with `τⱼ'` for all `j`*simultaneously*.

We call such a telescoping substitutions a *unifier*. The *unifier* is
not merely a set but a list because the telescoping property depends
on the order of the elements.


The telescoping property of the substitution ensures that there is no
circularity as the following exercise points out.

__Exercise:__
:   Let `𝒮` be a telescope and let `τ` be any type then the result
`τ[𝒮]` of the substitution of `𝒮` in `τ` *does not* contain any type
variable `α` such that `α/t` is an entry in  `𝒮`.

We can define a notion of generality on unifier as by making use of
the pre-ordering defined as follows `τ ≤ τ'` if there is a
telescoping substitution `𝒮` such that `τ'[𝒮] = τ`.

__Unification Problem__
: Given types `τ₁` and `τ₂` compute the *most general unifier* for
them.


For solving this problem we need to look at the following generalisation

__Generalised unification__
: Given the list of constraints `τ₁ ≡ τ₁', τ₂ ≡ τ₂' ...` together with
a telescope `𝒮`, compute a telescope `𝒯` such that `τⱼ[𝒮][𝒯]` and
`τⱼ'[𝒮][𝒯]`, i.e. unify simultaneously under the already fixed
constraints `𝒮`.

The essence of the unification algorithm is the following

1. Unifying a variable `α` with a variable `τ` is essentially the
   substitution α/τ. However, if `α` occurs in `τ` and `τ` is not `α`
   itself then this is a failure.

2. Unifying `τ₁ -> τ₁'` with `τ₂ -> τ₂'` is essentially unifying
   `τ₁ ≡ τ₂` and `τ₁' ≡ τ₂'` simultaneously.

3. Unifying a basic type with `τ` is possible only when `τ` itself is
   the basic type.

The above rules have to be suitably tweaked when the unification is to
be done under an already computed substitution `𝒮`.

__Exercise:__
:  Write an ML program for unification of types. First write the function to
   unify two types under a substitution, i.e.

          val unify     : (Type * Type) -> Substitution -> Substitution.
	      val unifyList : (Type * Type) list -> Substitution -> Substitution.

   You can express unifyList as a fold by making use of unify.


## The type inference algorithm.

Let `Γ` be a context and `τ` be a mono-type. The closure of
`closure(Γ,τ)` of `τ` with respect to the context `Γ` is that type
scheme `σ` obtained by quantifying over all variables of `τ` that are
not free in `Γ`. The type inference algorithm will only attempt to
compute a `τ` whose closure will give us the desired general type.

Just like we required a generalised version of the unification
algorithm, we need the following generalised version of type inference.

__Input:__
:   A context `Γ`, an expression `e` and a starting substitution `𝒮`.

__Output:__
:   Either
    1. Error if `e` is not typeable under the context `Γ` or
    2. A type `τ` and an output substitution `𝒯`, such that
	`closure(Γ,τ[𝒯])` is the most general type `σ` such that `Γ[𝒮] ⊢ e :
	σ`.

The essence of the type inference algorithm is the following

1. If `e` is a variable `x` then it better be the case that `Γ` has a
   type assumption `x : σ`. In this case instantiate all the quatified
   variables of `σ` with fresh variables (i.e. variables that are
   not used any where else) to get a mono-type `τ` and return it. The
   returned substitution is the same as the input one.

2. If `e` is `f u` then we infer the types of `f` and `u` to get `τ₁`
   and `τ₂` respectively. We now need to generate fresh variables `α`
   and `β` and simultaneously unify `α -> β ≡ τ₁` and `α ≡ τ₂`. This
   gives the new substitution `𝒮`.

3. If `e` is `fun x => e'`. Exercise.

# References

[Principal type-schemes for functional programs][principal], Luis
Damas and Robin Milner.

[principal]: <http://web.cs.wpi.edu/~cs4536/c12/milner-damas_principal_types.pdf>
