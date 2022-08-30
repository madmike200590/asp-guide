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

### Choices and multiple answer sets

ASP is often used for computationally complex problems from domains like scheduling and optimization. These problems have in common that it is hard (or even effectively impossible) to formulate an efficient algorithm that calculates optimal solutions. The "ASP way" to handle this is the **guess-and-check** design pattern - we have one program part that specifies how a solution candidate looks (guess) and one that evaluates whether a solution candidate is in fact a valid solution (check).

We'll demonstrate this pattern using the **graph coloring** problem as an example. Given a graph that is specified through its vertices and edges, we want to know how whether there is a way to color all vertices in the graph so that no two adjacent vertices have the same color. The most common variant is graph 3-coloring where we want to use 3 colors, e.g. red, green and blue.

We encode our input graph as ASP facts as follows:
```
vertex(a).
vertex(b).
vertex(c).
edge(a, b).
edge(b, c).
edge(c, a).
```
The above facts describe a triangular graph where every vertex is connected to two others. We also create a helper rule to express that our graph is undirected, i.e. an edge from `a` to `c` is synonymous for an edge from `c` to `a`.
```
% Edges are undirected
edge(Y, X) :- edge(X, Y).
```

#### Guessing - Generating a solution space




