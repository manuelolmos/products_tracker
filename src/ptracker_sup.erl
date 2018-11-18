-module(ptracker_sup).
-behaviour(supervisor).

-export([
         start_link/0,
         init/1
        ]).

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
    lager:start(),
    {ok, { {one_for_all, 0, 1}, []} }.
