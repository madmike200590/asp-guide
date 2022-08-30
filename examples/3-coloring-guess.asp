% Graph is specified as facts
vertex(a).
vertex(b).
vertex(c).
edge(a, b).
edge(b, c).
edge(c, a).

% Edges are undirected
edge(Y, X) :- edge(X, Y).

% Guess color for each vertex
red(V) :- vertex(V), not green(V), not blue(V).
green(V) :- vertex(V), not red(V), not blue(V).
blue(V) :- vertex(V), not red(V), not green(V).
