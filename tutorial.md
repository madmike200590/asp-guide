# ASP - A Tutorial

## The Basics

This chapter will cover the basics of understanding and writing ASP programs. You'll learn about the basic building blocks of a program, how to put them together, and what the results mean. Let's start with a small example where we write a simple knowledge base that helps us decide what we can cook with a given set of stores.

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

In the guessing part of our graph coloring implementation, we specify three rules that basically express that every vertex can have every color.
```
red(V) :- vertex(V), not green(V), not blue(V).
green(V) :- vertex(V), not red(V), not blue(V).
blue(V) :- vertex(V), not red(V), not green(V).
```
It's important to note that only one out of the three rules from the example can fire: As soon as any rule fires, it "blocks" the other two. However, there is no way to decide which of the three rules that can fire is the single correct one. In fact, any of the three is fine, we just want our vertex to have a color, but have no particular preferences on which color is assigned to an individual vertex. In cases such as these, where there can be no single correct answer, ASP solvers generate _all_ correct solutions, i.e. one answer set per coloring. A call to alpha and some answer sets for the graph coloring program are listed below (Alpha's `-f` option allows filtering for specific predicate names). You can find the full code [here](examples/3-coloring-guess.asp).
```
$ alpha-solver -i 3-coloring-guess.asp -filter red -filter green -filter blue
Answer set 1:
{ blue(b), green(a), red(c) }
Answer set 2:
{ green(a), green(b), red(c) }
Answer set 3:
{ green(a), red(b), red(c) }
Answer set 4:
{ blue(a), blue(b), red(c) }
...
```
With the current state of the program, we get _all_ possible colorings. Now, to filter out those not representing valid 3-colorings, we write a so-called **check-part** to our program.

#### Checking - Filtering solutions

In order to extend our program from the previous section to a valid 3-coloring implementation, we need to exclude all answer sets where neighboring vertices have the same color. To that end, we introduce the concept of a **constraint**: a constraint is a rule _without head_. It expresses that any solution candidate in which the constraint body holds true can not be a valid answer set.
The constraints we need are:
```
:- vertex(V1), vertex(V2), edge(V1, V2), red(V1), red(V2).
:- vertex(V1), vertex(V2), edge(V1, V2), green(V1), green(V2).
:- vertex(V1), vertex(V2), edge(V1, V2), blue(V1), blue(V2).
```

