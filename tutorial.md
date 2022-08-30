# ASP - A Tutorial

## The Basics

This chapter will cover the basics of understanding and writing ASP programs. You'll learn about the basic building blocks of a program, how to put them together, and what the results mean. Let's start with a small example dealing where we write a simple knowledge base that helps us decide what we can cook with a given set of stores.

Consider the program [cooking.asp](examples/cooking.asp):
```
{% include_relative examples/cooking.asp %}
```

ASP programs can be read as specifications of how solutions to a problem have to look. Rather than giving a step-by-step procedure (i.e. an algorithm) that solves a given problem, ASP programs only specify conditions that hold for solutions. In our cooking example, one such condition wold be that a dish can only be cooked when we do not miss any ingredients. In order to get from the declarative problem specification represented by a program to an actual solution - a so-called **answer set**, programs are evaluated by **ASP solvers**, i.e. interpreters for the ASP language.
The solver call to calculate the (only) answer set for the cooking example is given below (`-sep "\n"` is only used for formatting and can be omitted).
```
$ alpha-solver -sep "\n" -i cooking.asp 
Answer set 1:
{ available(bread)
available(cheese)
available(ham)
available(mushrooms)
available(pizza_dough)
can_cook(sandwich)
dish(pizza)
dish(sandwich)
ingredient_for(bread, sandwich)
ingredient_for(cheese, pizza)
ingredient_for(cheese, sandwich)
ingredient_for(ham, sandwich)
ingredient_for(mushrooms, pizza)
ingredient_for(olives, pizza)
ingredient_for(pizza_dough, pizza)
ingredient_for(tomato_sauce, pizza)
ingredients_missing_for(pizza)
missing_ingredient(pizza, olives)
missing_ingredient(pizza, tomato_sauce) }
SATISFIABLE

```

### Rules - the bones of an ASP program

ASP code is structured around **rules** - for example, `missing_ingredient(D, I) :- ingredient_for(I, D), not available(I).` is a rule. Rules always have the format `<HEAD> :- <BODY>.` and denote that `<HEAD>` is true if `<BODY>` is true. The end of a rule is marked with a dot: `.`, similar to how semicolons are used in other languages.
For example, the rule `vehicle(X) :- car(X).` expresses that, if `X` is a car, then `X` is also a vehicle. Rule bodies can refer to more than one propositions - consider the rule `motorcycle(X) :- vehicle(X), motorized(X), has_two_wheels(X).` which tells us that motorized vehicles with two wheels are motorcycles. Expressions of form `<predicate>(<args>)` are called **atoms**. Atoms can also be  **negated**, i.e. prefixed with `not` - in the context of a rule body, both atoms and negated atoms are called **literals**. We have an example of this in the cooking program, see the rule `can_cook(D) :- dish(D), not ingredients_missing_for(D).` which tells us that we can cook a dish if we don't miss any required ingredients.

**Facts** are rules with an empty body. They express things that are _always true_, e.g. `wet(water).`.


