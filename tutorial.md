# ASP - A Tutorial

## The Basics

This chapter will cover the basics of understanding and writing ASP programs. You'll learn about the basic building blocks of a program, how to put them together, and what the results mean. Let's start with a small example dealing where we write a simple knowledge base that helps us decide what we can cook with a given set of stores.

Consider the program [cooking.asp](examples/cooking.asp):
```
{% include_relative examples/cooking.asp %}
```
ASP code is structured around **rules** - for example, `missing_ingredient(D, I) :- ingredient_for(I, D), not available(I).` is a rule.

### Rules - the bones of an ASP program

Rules always have the format `<HEAD> :- <BODY>.` and denote that `<HEAD>` is true if `<BODY>` is true. The end of a rule is marked with a dot: `.`, similar to how semicolons are used in other languages.
For example, the rule `vehicle(X) :- car(X).` expresses that, if `X` is a car, then `X` is also a vehicle. Rule bodies can refer to more than one propositions - consider the rule `motorcycle(X) :- vehicle(X), motorized(X), has_two_wheels(X).` which tells us that motorized vehicles with two wheels are motorcycles. Expressions of form `<predicate>(<args>)` are called **atoms**. Atoms can also be  **negated**, i.e. prefixed with `not` - in the context of a rule body, both atoms and negated atoms are called **literals**. We have an example of this in the cooking program, see the rule `can_cook(D) :- dish(D), not ingredients_missing_for(D).` which tells us that we can cook a dish if we don't miss any required ingredients.

**Facts** are rules with an empty body. They express things that are _always true_, e.g. `wet(water).`.


