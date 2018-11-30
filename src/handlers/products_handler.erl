-module(products_handler).
-export([init/2]).

init(Req0 = #{method := <<"GET">>}, State) ->
    {ok, Products} = product:get_all(),
    Json = jsx:encode(Products),
    {ok, cowboy_req:reply(200, #{<<"content-type">> => <<"application/json">>}, Json, Req0), State};
init(Req0 = #{method := <<"POST">>}, State) ->
    {ok, Data, Req1} = cowboy_req:read_body(Req0),
    Product = jsx:decode(Data),
    #{<<"name">> := Name, <<"date">> := Date, <<"prize">> := Prize, <<"seller">> := Seller} = maps:from_list(Product),
    product:create(Name, Prize, Date, Seller),
    {ok, cowboy_req:reply(201, #{<<"content-type">> => <<"application/json">>}, Data, Req1), State};
init(Req0, State) ->
    {ok, cowboy_req:reply(400, Req0), State}.
