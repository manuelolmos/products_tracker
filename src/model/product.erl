-module(product).

-export([create/4,
        get/1,
        delete/1,
        update/4,
        get_all/0]).

create(Name, Prize, Date, Seller) ->
    db_product:create(Name, Prize, Date, Seller).

get(Name) ->
    db_product:get(Name).

delete(Name) ->
    db_product:delete(Name).

update(Name, Prize, Date, Seller) ->
    db_product:update(Name, Prize, Date, Seller).

get_all() ->
    db_product:get_all().
