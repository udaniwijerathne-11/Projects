:- use_module(library(http/http_server)).
:- use_module(library(http/http_json)).
:- use_module(library(http/http_cors)).

% Enable CORS for all origins
:- set_setting(http:cors, [*]).

% Load the navigator code
:- [navigator].

% HTTP handler for /find_route
:- http_handler('/find_route', handle_find_route, []).

handle_find_route(Request) :-
    http_parameters(Request, [
        start(Start, [atom]),
        attraction(Attraction, [atom]),
        algo(Algo, [atom])
    ]),
    (   find_route(Algo, Start, Attraction, Path, Distance)
    ->  cors_enable,
        reply_json_dict(_{path: Path, distance: Distance})
    ;   cors_enable,
        reply_json_dict(_{error: "No route found"}, [status(404)])
    ).

% Start the server
start_server :-
    http_server([port(3000)]).

% Run the server
:- initialization(start_server).