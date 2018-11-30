-module(products_handler).
-export([init/2]).

init(Req0 = #{method := <<"GET">>}, State) ->
    case cowboy_req:binding(id, Req0) of
        undefined ->
            {ok, Products} = product:get_all(),
            Json = jsx:encode(Products),
            {ok, cowboy_req:reply(200, #{<<"content-type">> => <<"application/json">>}, Json, Req0), State};
        ProductId ->
            case product:get(ProductId) of
                {ok, Product} ->
                    Json = jsx:encode(Product),
                    {ok, cowboy_req:reply(200, #{<<"content-type">> => <<"application/json">>}, Json, Req0), State};
                {error, not_found} ->
                    {ok, cowboy_req:reply(404, Req0), State}
            end
    end;
init(Req0 = #{method := <<"POST">>}, State) ->
    {ok, Data, Req1} = cowboy_req:read_body(Req0),
    Product = jsx:decode(Data),
    #{<<"name">> := Name, <<"date">> := Date, <<"prize">> := Prize, <<"seller">> := Seller} = maps:from_list(Product),
    case product:get(Name) of
        {ok, Product} ->
            {ok, cowboy_req:reply(400, Req0), State};
        {error, not_found} ->
            product:create(Name, Prize, Date, Seller),
            {ok, cowboy_req:reply(201, #{<<"content-type">> => <<"application/json">>}, Data, Req1), State}
    end;
init(Req0 = #{method := <<"PUT">>}, State) ->
    case cowboy_req:binding(id, Req0) of
        undefined ->
            {ok, cowboy_req:reply(404, Req0), State};
        ProductId ->
            case product:get(ProductId) of
                undefined ->
                    {ok, cowboy_req:reply(404, Req0), State};
                _ ->
                    {ok, Data, Req1} = cowboy_req:read_body(Req0),
                    Product = jsx:decode(Data),
                    #{<<"name">> := Name, <<"date">> := Date, <<"prize">> := Prize, <<"seller">> := Seller} = maps:from_list(Product),
                    product:update(Name, Prize, Date, Seller),
                    {ok, cowboy_req:reply(204, Req1)}
            end
        end;
init(Req0 = #{method := <<"DELETE">>}, State) ->
    case cowboy_req:binding(id, Req0) of
        undefined ->
            {ok, cowboy_req:reply(404, Req0), State};
        ProductId ->
            product:delete(ProductId),
            {ok, cowboy_req:reply(204, Req0), State}
    end;
init(Req0, State) ->
    {ok, cowboy_req:reply(400, Req0), State}.
