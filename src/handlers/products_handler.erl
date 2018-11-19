-module(products_handler).
-export([init/2]).

init(Req0 = #{method := <<"GET">>}, State) ->
    {ok, Products} = product:get_all(),
    Json = jsx:encode(Products),
    {ok, cowboy_req:reply(200, #{<<"content-type">> => <<"application/json">>},
                          Json, Req0), State};
init(Req0 = #{method := <<"POST">>}, State) ->
    {ok, cowboy_req:reply(200, #{<<"content-type">> => <<"text/plain">>}, <<"product created">>,
                          Req0), State};
init(Req0, State) ->
    {ok, cowboy_req:reply(400, Req0), State}.
