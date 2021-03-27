# A language to make it easy to write S.O.L.I.D, Observable code

What do we want to make easy?
- Writing quality code
    - Dependency inversion
    - Testing and writing clean code
    - Decoupling Domain and Infrastructure
    - Identifying and isolating side effects and coupling
- Easy to understand, write and debug
    - Observability
    - IO
    - Execution contexts

How do we avoid adoption problems
- Easy to use
- Familiar patterns

What experience do we want to provide?
- Elegant but lightweight syntax like MoonScript, CoffeeScript, Nim, Python and Haskell
- Simple and fast tooling and debugging
- Complied and interpreted

Features that make it easier to write solid clean code
- Pattern matching
- Return early
- Unified function call syntax
- Algebraic Data Types

Some extra nice bits for familiarity:
- Standard imperative control flow
- Api inspired by dart and haskell

## Summary
Boring obvious choices:
- Package Management: Standard projectfile + lockfile toml
- Error management: Similar to Rust/Haskell/Kotlin Result/Either type
- Null: No null, similar to Rust/Haskell/Kotlin Optional/Maybe type
- Ad hoc polymorphism: Similar to Rust traits and Haskell typeclasses
- Function definition: optional & named arguments, types inline, no overloading.
- Function application: UFCS like nim, reason and D. Named arguments like nim/python.
- Standard Library: Dart + Haskell + ???
- Types: boolean/integer/float/string/list/dict/record/varient
- Targets: Compile to JS, Compile to C

Bold but common choices:
- Mutibility: No mutable values but emulate though processes like in erlang
- Control flow: Recursive functions, switch statements, if statements
- Syntax: Python like whitespace, colon is always type.

Innnovation
- Modules: Similar to OCaml but DI container like features
- Async: Similar to Erlang but with outboxes as well as inboxes
