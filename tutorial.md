# ASP - A Tutorial

## The Basics

This chapter will cover the basics of understanding and writing ASP programs. You'll learn about the basic building blocks of a program, how to put them together, and what the results mean. First off, we'll look at a simple program and go through what it does.

Consider the program [cooking.asp](examples/cooking.asp):
```
{% include_relative examples/cooking.asp %}
```
ASP code is structured around **rules** - for example, `missing_ingredient(D, I) :- ingredient_for(I, D), not available(I).` is a rule.

### Rules - the bones of an ASP program

Rules always have the format `<HEAD> :- <BODY>.` and denote that `<HEAD>` is true if `<BODY>` is true. The end of a rule is marked with a dot: `.`, similar to how semicolons are used in other languages.
For example, the rule `vehicle(X) :- car(X).` expresses that, if `X` is a car, then `X` is also a vehicle. Rule bodies can refer to more than one propositions - consider the rule `motorcycle(X) :- vehicle(X), motorized(X), has_two_wheels(X).` which tells us that motorized vehicles with two wheels are motorcycles. Expressions of form `<predicate>(<args>)` are called **atoms**. They express pieces of information within the context of an ASP program. For a rule to _fire_, all atoms in its body must be true. If a rule fires, i.e. its body is true, also the rule head atom is true.

**Facts** are rules with an empty body. They express things that are _always true_, e.g. `wet(water)`.
