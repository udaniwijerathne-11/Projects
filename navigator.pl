% Facts: road(FromCity, ToCity, DistanceKM).
road(colombo, gampaha, 30).
road(gampaha, colombo, 30).
road(colombo, kaluthara, 45).
road(kaluthara, colombo, 45).
road(colombo, kegalle, 80).
road(kegalle, colombo, 80).
road(gampaha, kegalle, 70).
road(kegalle, gampaha, 70).
road(kegalle, kandy, 50).
road(kandy, kegalle, 50).
road(kandy, matale, 25).
road(matale, kandy, 25).
road(kandy, nuwaraeliya, 90).
road(nuwaraeliya, kandy, 90).
road(kaluthara, galle, 80).
road(galle, kaluthara, 80).
road(galle, matara, 45).
road(matara, galle, 45).

% Facts: attraction(AttractionName, DistrictCity, DistanceFromCityKM, Description).
attraction('Galle Face Green', colombo, 5, 'Urban park and promenade').
attraction('Gangaramaya Temple', colombo, 6, 'Important Buddhist temple').
attraction('Negombo Beach', gampaha, 20, 'Famous beach near the airport').
attraction('Kalutara Bodhiya', kaluthara, 1, 'Sacred fig tree and temple').
attraction('Temple of the Tooth Relic', kandy, 1, 'Most sacred Buddhist site in Sri Lanka').

% Heuristic data: distance_from_colombo(City, DistanceKM)
distance_from_colombo(colombo, 0).
distance_from_colombo(gampaha, 30).
distance_from_colombo(kaluthara, 45).
distance_from_colombo(kegalle, 80).
distance_from_colombo(kandy, 113).
distance_from_colombo(nuwaraeliya, 161).
distance_from_colombo(galle, 140).
distance_from_colombo(matara, 192).

% Heuristic function for A* - uses difference from Colombo distances
h(City, Goal, Dist) :-
    distance_from_colombo(City, CityDist),
    distance_from_colombo(Goal, GoalDist),
    Dist is abs(CityDist - GoalDist).

% BFS Implementation
bfs(Start, Goal, Path) :-
    bfs_path([[Start]], Goal, RevPath),
    reverse(RevPath, Path).

bfs_path([[Goal|Path]|_], Goal, [Goal|Path]) :- !.
bfs_path([Path|Paths], Goal, FinalPath) :-
    extend_path(Path, NewPaths),
    append(Paths, NewPaths, Queue),
    bfs_path(Queue, Goal, FinalPath).

extend_path([Node|Path], ExtendedPaths) :-
    findall([NewNode, Node|Path],
            (road(Node, NewNode, _),
             \+ member(NewNode, [Node|Path])),
            ExtendedPaths).

% DFS Implementation
dfs(Goal, Goal, _, [Goal]).
dfs(Start, Goal, Visited, [Start|Path]) :-
    road(Start, Next, _),
    \+ member(Next, Visited),
    dfs(Next, Goal, [Next|Visited], Path).

dfs(Start, Goal, Path) :-
    dfs(Start, Goal, [Start], Path).

% A* Implementation
astar_path([fcost(_, [Goal|Path])|_], Goal, [Goal|Path]).
astar_path([fcost(_, Path)|Queue], Goal, FinalPath) :-
    extend_astar_path(Path, Goal, NewPaths),
    append(Queue, NewPaths, NewQueue),
    sort(NewQueue, SortedQueue),
    astar_path(SortedQueue, Goal, FinalPath).

extend_astar_path([Node|Path], Goal, NewPaths) :-
    findall(fcost(FNew, [NewNode, Node|Path]),
            (road(Node, NewNode, D),
             \+ member(NewNode, [Node|Path]),
             g_cost([NewNode, Node|Path], G),
             h(NewNode, Goal, H),
             FNew is G + H),
            NewPaths).

g_cost([_], 0).
g_cost([A,B|T], Cost) :-
    road(A, B, D),
    g_cost([B|T], RestCost),
    Cost is D + RestCost.

astar(Start, Goal, Path) :-
    h(Start, Goal, H),
    astar_path([fcost(H, [Start])], Goal, RevPath),
    reverse(RevPath, Path).

% Calculate total distance of a path
path_distance([_], 0).
path_distance([A,B|T], Distance) :-
    road(A, B, D),
    path_distance([B|T], RemainingDistance),
    Distance is D + RemainingDistance.

% Main predicate: find route from StartCity to AttractionName
find_route(Algorithm, StartCity, AttractionName, TotalPath, TotalDistance) :-
    attraction(AttractionName, DistrictCity, FinalDistance, _),
    call(Algorithm, StartCity, DistrictCity, CityPath),
    path_distance(CityPath, PathDistance),
    TotalDistance is PathDistance + FinalDistance,
    append(CityPath, [AttractionName], TotalPath).

% Predicate to run the navigator
navigate :-
    write('=== AI Tourist Navigator ==='), nl, nl,
    write('Start City: '), read(Start),
    write('Attraction you want to visit: '), read(Attraction),
    nl, write('Choose algorithm (bfs/dfs/astar): '), read(Algo),
    nl,
    find_route(Algo, Start, Attraction, Path, Distance),
    write('Path to your attraction: '), write(Path), nl,
    write('Total distance: '), write(Distance), write(' km'), nl, nl.

% Helper to show all attractions in a city
show_attractions(City) :-
    write('Attractions in '), write(City), write(':'), nl,
    attraction(Name, City, Dist, Desc),
    write(' - '), write(Name), write(' ('), write(Dist), write(' km): '), write(Desc), nl,
    fail.
show_attractions(_).