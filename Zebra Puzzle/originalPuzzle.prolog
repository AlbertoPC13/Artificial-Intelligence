% =================================================================================== %
%
%   Alberto Palacios Cabrera
%	
%	Zebra Puzzle
%
%   - Well-known logic puzzle
%
%   - It was published in Life International magazine on December 17, 1962.
%	
%   - Life version of the puzzle: 5 houses with 5 attributes and 15 clues
%
%       1)  There are five houses.
%       2)  The Englishman lives in the red house.
%       3)  The Spaniard owns the dog.	
%       4)  Coffee is drunk in the green house.
%       5)  The Ukrainian drinks tea.
%       6)  The green house is next to the ivory house. 
%       7)  The Old Gold smoker owns snails.
%       8)  Kools are smoked in the yellow house.
%       9)  Milk is drunk in the middle house.
%       10) The norwegian lives in the first house.
%       11) The man who smokes Chesterfields lives in 
%           the house next to the man with fox.
%       12) Kools are smoked in the house next to the
%           house where the horse is kept.
%       13) The Lucky Strike smoker drinks orange juice.
%       14) The Japanese smokes Parliaments.
%       15) The Norwegian lives next to the blue house.
%
%       Q: Now, who drinks water? Who owns the zebra?
%
%	Relevant predicates:
%
%   neighborhood(<Lista>).
%   next_to(<House 1>,<House 2>,<Lista>).
%   
% =================================================================================== %

% =================================================================================== %
%   next_to/3. Indicates if the Houses received as a parameter are found 
%   together in the provided list.

%                   next_to(<House 1>,<House 2>,<List>).

%   True if <List> is a list with elements <House 1> and <House 2> together
% =================================================================================== %

next_to(House_1,House_2,List) :- append(_,[House_1,House_2|_],List).
next_to(House_1,House_2,List) :- append(_,[House_2,House_1|_],List).

% =================================================================================== %
%   neighborhood/1. Generates a list showing the universe described based on 
%   the clues in the zebra problem.

%                       neighborhood(<List>).

%   True if <List> is a list that meets each of the clues that describe the
%   universe posed in the zebra problem.
%
%   NOTE: The Houses that make up the neighborhood are represented as follows:

%               House(<Color>,<Nationality>,<Pet>,<Drink>,<Smoke>)
% =================================================================================== %

neighborhood(N) :-
    N = [_,_,_,_,_], % 1
    member(house(red,englishman,_,_,_), N), % 2
    member(house(_,spaniard,dog,_,_), N), % 3
    member(house(green,_,_,coffee,_), N), % 4
    member(house(_,ukrainian,_,tea,_), N), % 5
    next_to(house(ivory,_,_,_,_),house(green,_,_,_,_), N), % 6
    member(house(_,_,snails,_,'old gold'), N), % 7
    member(house(yellow,_,_,_,kool), N), % 8
    N = [_,_,house(_,_,_,milk,_),_,_], % 9
    N = [house(_,norwegian,_,_,_)|_], % 10
    next_to(house(_,_,_,_,chesterfield),house(_,_,fox,_,_), N), % 11
    next_to(house(_,_,_,_,kool),house(_,_,horse,_,_), N), % 12
    member(house(_,_,_,juice,'lucky strike'), N), % 13
    member(house(_,japanese,_,_,parliaments), N), % 14
    next_to(house(_,norwegian,_,_,_),house(blue,_,_,_,_), N), % 15
    member(house(_,_,_,water,_), N), % Someone drinks water...
    member(house(_,_,zebra,_,_), N). % Someone owns a zebra...

% =================================================================================== %
%   show_neighborhood/1. Prints the neighborhood universe in table format.

%                   show_neighborhood(<List>).

%   True if <List> corresponds to the universe described for the neighborhood of
%   the zebra problem and it is possible to print it with the defined format.
% =================================================================================== %

show_neighborhood(V) :-
    neighborhood(V),
    format('~n~n+~`-t~100|+ ~n', []),
    format('|~t~w~t~20+|~t~w~t~20+|~t~w~t~20+|~t~w~t~20+|~t~w~t~20+|~n',
    ['Color','Nationality','Pet','Drink','Smoke']),
    print_house(V).

% =================================================================================== %
%   print_house/1. Prints each 'house' element contained in the provided list.

%                   print_house(<List>).

%   True if <List> corresponds to a list of 'house' elements that can be printed
%   with the defined format.
% =================================================================================== %

print_house([H|T]) :-
    H = house(Color,Nationality,Pet,Drink,Smoke),
    format('~`-t~100| ~n', []),
    format('|~t~w~t~20+|~t~w~t~20+|~t~w~t~20+|~t~w~t~20+|~t~w~t~20+|~n',
    [Color,Nationality,Pet,Drink,Smoke]),
    format('~`-t~100| ~n', []),
    print_house(T).