-module(db_product).

-export([create/4,
        get/1,
        delete/1,
        update/4,
        get_all/0]).

create(Name, Prize, Date, Seller) ->
    Q = <<"INSERT INTO products(name, prize, date, seller) VALUES(?,?,?,?) ;">>,
    Vals = [{name, Name},
            {prize, Prize},
            {date, Date},
            {seller, Seller}],
    db_cass:exec(Q, Vals),
    ok.

get(Name) ->
    Q = <<"SELECT * FROM products WHERE name = ? ;">>,
    Vals = [{name, Name}],
    case db_cass:exec(Q, Vals) of
        [Result] ->
            {ok, Result};
        _ ->
            {error, not_found}
    end.

delete(Name) ->
    case ?MODULE:get(Name) of
        {ok, _Product} ->
            Q = <<"DELETE FROM products WHERE name = ? ;">>,
            Vals = [{name, Name}],
            db_cass:exec(Q, Vals);
        Error ->
            Error
    end.

update(Name, Prize, Date, Seller) ->
    Q = <<"UPDATE products SET prize = ?, date = ?, seller = ? WHERE name = ? ;">>,
    Vals = [{name, Name},
           {prize, Prize},
           {date, Date},
           {seller, Seller}],
    db_cass:exec(Q, Vals),
    ok.

get_all() ->
    Q = <<"SELECT * FROM products;">>,
    case db_cass:exec(Q) of
        [] ->
            {ok, []};
        Result ->
            {ok, Result}
    end.
