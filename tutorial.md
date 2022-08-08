# ASP - A Tutorial

## The Basics

This chapter will cover the basics of understanding and writing ASP programs. You'll learn about the basic building blocks of a program, how to put them together, and what the results mean. First off, we'll look at a simple program and go through what it does.

Consider the program [cooking.asp](examples/cooking.asp):
```
{% include_relative examples/cooking.asp %}
```



First off, we'll take a look at what we got out of our Hello World program from the last chapter.
### Understanding the Hello World Program
At the end of the "Getting Started" chapter, we got an _answer set_ out of our solver when running the program. Let's take a look at it:
```prolog
{ say("Hello World"), world }
```
The answer set contains two items, namely `say("Hello World")` and `world`. We call those items _facts_ (or "atoms" for the more mathematically inclined). Since ASP is concerned with representing knowledge in a way computers can understand, the intended way to read this is:
> We know `say("Hello World")` and `world` to be **true**.

So, _**an answer set represents all the knowledge that can be gained from a program and it's input**_.

Accordingly, an ASP program is a computer-readable form to express knowledge and how to derive new knowledge from it. Basically, we're teaching our computer how to think ;-)

Since - as we all know - computers are immensely stupid an not at all suited to thinking, we need a very simple way to express information and how to handle it. This brings us back to our good old `helloWorld.asp` file:
```prolog
world.
say("Hello World") :- world.
```
It consists of a _fact_, `world`, and a _rule_, `say("Hello World") :- world`.

- **Facts** represent things that are true. 
- **Rules** tell the computer (our ASP solver, to be precise) _the consequences of something being true_. 
The rule in our example reads as:
> If `world` is true, then `say("Hello World")`must also be true. 

Translating that into a more "natural" language, we might say _If there is a world, say "Hello World"_.
Since we know there is a world (from the fact `world`) and we know that we're supposed to say hello if that is the case (from the rule), we get to our answer set from above.
```prolog
{ say("Hello World"), world }
```

**_Wait, isn't a program supposed to "do" stuff? It just gives these strange answer sets..!_** 
If that's what you're asking yourself, it's a justified question. We're used to being able to print text, read user input, display windows, write files, and all kinds of stuff in the programs we write in other languages. What all those have in common is that they involve _system calls_, meaning our program asks the operating system to do something for us. Since only the operating system is allowed to print text to the console, our programming language needs some mechanism to ask the operating system to do that. In Java, that would be the good old `System.out.println("stuff I want printed")` - in the background, it tells our operating system that `stuff I want printed` should be written to the console. As a rule, most ASP solvers currently don't have system calls. This is due to technical reasons that mostly go beyond the scope of a beginner's book, however, there are still ways to interact with the "outside world" from an ASP program, and also workarounds for the "missing" system calls. We'll talk about that in the Chapter "Applications using ASP" in some detail. For now, let's ignore the outside world and focus on ASP programs themselves for a bit longer ;-)

### The Anatomy of an ASP program

This section focuses on the basic building blocks on ASP programs and how they work together. We'll take a quick look a logic in general, and then explore how that lines up with what we have in our programs.

#### Meet Socrates, a Mortal Man 

.. or "_an intuitive ten-mintue introduction to logic_"

In computer science classes, a widely used example for a very simple logical construct is the following [_syllogism_](https://en.wikipedia.org/wiki/Syllogism):
```
All humans are mortal.
Socrates is human.

Hence, Socrates is mortal.
```
This kind of _logical deduction system_ was first introduced by ancient greek philosophers, and has seen continuing development ever since. The important point for us is that it provides a very simple structure for presenting a "rational thought": Based on some preconditions (or _premises_), in this case `All humans are mortal` and `Socrates is human`, we know that - provided those preconditions are true - our conclusion, `Socrates is mortal` is also true. We'll call this a _logical inference rule_.

Now, let's take a look at what we know about ASP so far, and how we could teach an ASP solver to draw the conclusion from above.

#### Rules, Predicates, Constants and Variables

##### Predicates

Let's start with the second premise, `Socrates is human`. Since this is a bit of knowledge we know to be true, based on what we've seen from our hello world example, we'll have to put it into our program as a fact:
```
human(socrates). % Expresses the premise "Socrates is human"
```
We've got a few things here we haven't seen yet:

- A comment: text that is prefixed with `%` is not part of the program. It is ignored by the solver and we can use this to document our code.
- The _predicate_ `human`: A predicate tells the ASP solver that the object it refers to (it's _argument_) has a certain property. In this case, we stated that the object `socrates` has the property of being human.

Great, we've told the solver that Socrates is human! 

> Note that a *Predicate* may have *any number of arguments*, i.e.:
> `human(socrates), carries(frodo, ring), addition_result(2, 2, 4)` are all valid.

##### Rules
If we put the fact from above into a file called `socrates.asp` and feed it into our solver using
```
> java -jar alpha.jar -i socrates.asp
```
or
```
> clingo -n 0 socrates.asp
```
we get the answer set
```
{ human(socrates) }
```

As we can see, on it's own, that piece of information isn't all that useful - the answer set contains only what we already knew (in other words, it contains all facts). But we want to draw conclusions from our facts, so let's add a rule to our file:
```
human(socrates). % Expresses the premise "Socrates is human"
mortal(X) :- human(X). % All humans are mortal
```
Before we look at how that rule works in detail, let's run the updated program and look at the answer set:
```
{ human(socrates), mortal(socrates) }
```
Wow, the fact `mortal(socrates)` wasn't contained in the program. The solver drew that conclusion for us!
Now let's get back to that rule...
```
mortal(X) :- human(X).
```
Up to now, I haven't explicitly told you how to read this - let me fix that now:
> The rule `B :- A.` states that, if A is true, B must be true as well.

This is called a _logical implication_. We say _The right part (what comes after the `:-`) **implies** the left part_. The right part of the rule is called it's _body_, the left part it's _head_.
in our example above, `mortal(X)` is the rule head, and `human(X)` it's body.
Let's not think about the `X` and what is has to do with `socrates` just yet, let's look at the predicates.
Based on what we established about predicates denoting properties of objects above, we can read this rule as:
> If X has the property of being human, X also has the property of being mortal.

So far, so good.. But now, what about that `X`? As you may have guessed, `X` is a _**variable**_. It can stand for any known object in our program. But what are those _known objects_? Well, basically everything mentioned in facts.
In our case, that would be `socrates`, which is a _**constant**_. The predicate in a fact always refers to constants. The predicates in rules may refer to constants or variables. Now we're really close to having covered the basics of an ASP program.. Just a couple of things are missing..

##### Variables vs. Constants

In ASP code, **variable names** always start with an **upper-case letter**, while **constant names** always start with lower-case letters.
The following are all valid variable names:
```
V,
VAR,
AVariable
OneMoreVariable,
SOME_VALUE,
X1,
Y1,
X2Y2
```
I prefer having variable names in all upper-case letters and separating words using underscores, like the `SOME_VALUE` example above, but camel-casing (e.g. `OneMoreVariable`) is also a common style.

Constants can be names starting with lower-case letters, as well as integers or quoted strings. The following are all valid constants:
```
socrates,
no_one,
someOne,
"a string",
"another string",
1,
223,
42,
answer_42
```
