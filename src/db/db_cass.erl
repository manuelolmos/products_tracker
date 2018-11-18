-module(db_cass).

-export([
         exec/1,
         exec/2,
         exec_batch/1
        ]).

-include_lib("cqerl/include/cqerl.hrl").

exec(Q) ->
  case run_query(Q, []) of
    {ok, void} ->
      [];
    {ok, Result} ->
      paginate(Result, []);
    R ->
      lager:warning("DB Response ~p~nquery was ~p", [R, Q]),
      []
  end.

exec(Q, Vals) ->
  case run_query(Q, Vals) of
    {ok, void} ->
      [];
    {ok, Result} ->
      paginate(Result, []);
    R ->
      lager:warning("DB Response ~p~nquery was ~p ~p", [R, Q, Vals]),
      []
  end.

exec_batch(Queries) ->
  case run_batch_query(Queries) of
    {ok, void} ->
      [];
    {ok, Result} ->
      Result;
    R ->
      lager:warning("DB Response ~p~nquery was ~p ~p", [R, Queries]),
      []
  end.

%% internal
run_query(Q, Vals) ->
  try_query(#cql_query{statement = Q, values = Vals}, 3).

run_batch_query([]) -> [];
run_batch_query(Queries) ->
  Queries1 = [#cql_query{statement = Statement, values = Values}
              || {Statement, Values} <- Queries],
  try_query(#cql_query_batch{mode = ?CQERL_BATCH_UNLOGGED, queries = Queries1}, 3).

try_query(Q, 0) ->
  lager:error("Query retries exceeded, giving up: ~p", [Q]),
  {error, db_retries_exceeded};
try_query(Q, N) ->
  try
    {ok, Client} = cqerl:get_client(),
    cqerl:run_query(Client, Q)
  catch
    exit:{timeout, _} ->
      lager:error("Query failed, retrying: ~p", [Q]),
      try_query(Q, N - 1)
  end.

paginate(Result, Accum) ->
  case cqerl:has_more_pages(Result) of
    true ->
      {ok, Result2} = cqerl:fetch_more(Result),
      paginate(Result2, Accum ++ cqerl:all_rows(Result));
    false ->
      Accum ++ cqerl:all_rows(Result)
  end.
