-module(ptracker_app).
-behaviour(application).

-export([start/2,
         stop/1]).

start(_StartType, _StartArgs) ->
    Dispatch = cowboy_router:compile([
                                      {'_', [
                                             {"/products", products_handler, []},
                                             {"/products/[:id]", products_handler_id, []}
                                            ]}
                                     ]),
    {ok, _} = cowboy:start_clear(http, [{port, 8080}], #{
                                                         env => #{dispatch => Dispatch}
                                                        }),
    ptracker_sup:start_link().

stop(_State) ->
    ok.
