## What is Answer Set Programming?

Answer Set Programming (ASP) is a programming language mainly used for modelling in artificial intelligence applications. It lends itself to complex search and optimization problems from domains such as planning, scheduling, etc. ASP is a declarative language, meaning instead of writing a "step by step" list (i.e. an algorithm) for the computer on how to calculate something, we specify just _how a valid solution looks_ by means of logic-based rules. The software needed to run ASP code (i.e. the interpreter) is called an _ASP Solver_.

## Getting Started

This section will walk you through the steps to install an ASP solver on your computer and solve your first program.

### Installing the Alpha ASP solver

Alpha is an actively developed ASP solver written in Java. In order to run it, you need a Java Runtime Environment (JRE) compatible with Java 8. Start by [downloading](https://github.com/alpha-asp/Alpha/releases) the latest release of Alpha. Place the Alpha distribution jar in a folder of your choosing and place the following script in a location included in your `PATH` variable in order to have Alpha available from every directory:
```
#!/bin/bash

java -jar /path/to/alpha-jar/alpha-cli-app-x.y.z-bundled.jar $@
```

### Running a hello world program with Alpha 

Once you've downloaded and installed Alpha, try the following call:
```
$ alpha-solver -str "helloWorld."
```
The output should look something like
```
Answer set 1:
{ helloWorld }
SATISFIABLE
```
Congratulations! Now that you've installed Alpha and verified it works, you can start coding along with the [ASP tutorial](tutorial.html)
