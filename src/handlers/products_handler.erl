-module(products_handler).
-export([init/2]).

init(Req0 = #{method := <<"GET">>}, State) ->
    {ok, cowboy_req:reply(200, #{<<"content-type">> => <<"text/plain">>},
                          <<"hello world">>, Req0), State};
init(Req0, State) ->
    {ok, cowboy_req:reply(400, Req0), State}.
