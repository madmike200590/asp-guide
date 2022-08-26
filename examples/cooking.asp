% Known dishes
dish(pizza).
dish(sandwich).

% Ingredients for each dish
ingredient_for(pizza_dough, pizza).
ingredient_for(tomato_sauce, pizza).
ingredient_for(mushrooms, pizza).
ingredient_for(cheese, pizza).
ingredient_for(olives, pizza).
ingredient_for(bread, sandwich).
ingredient_for(ham, sandwich).
ingredient_for(cheese, sandwich).

% Inference rules to determine what can be cooked
missing_ingredient(D, I) :- ingredient_for(I, D), not available(I).
ingredients_missing_for(D) :- missing_ingredient(D, _).

can_cook(D) :- dish(D), not ingredients_missing_for(D).

%% Available ingredients
available(pizza_dough).
available(bread).
available(mushrooms).
available(cheese).
available(ham).
