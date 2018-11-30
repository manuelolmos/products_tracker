# Product


## GET all products:

```
$ curl -i http://localhost:8080/products

HTTP/1.1 200 OK
content-length: 118
content-type: application/json
date: Fri, 30 Nov 2018 02:46:15 GMT
server: Cowboy

[
   {
      "name":"milk",
      "date":"30/10",
      "prize":4,
      "seller":"jumbo"
   },
   {
      "name":"sugar",
      "date":"30/10",
      "prize":15,
      "seller":"coto"
   }
]
```

## GET product:

```
$ curl -i http://localhost:8080/products/milk

HTTP/1.1 200 OK
content-length: 57
content-type: application/json
date: Fri, 30 Nov 2018 02:49:23 GMT
server: Cowboy

{
   "name":"milk",
   "date":"30/10",
   "prize":4,
   "seller":"jumbo"
}
```

## CREATE product:

```
$ curl -i -X POST http://localhost:8080/products -d '{"name":"milk","date":"30/10","prize":32,"seller":"coto"}'

HTTP/1.1 201 Created
content-length: 15
content-type: text/plain
date: Fri, 30 Nov 2018 02:53:07 GMT
server: Cowboy
```

## UPDATE product:

```
$ curl -i -X PUT http://localhost:8080/products/milk -d '{"name":"milk","date":"30/10","prize":4,"seller":"jumbo"}'
HTTP/1.1 204 No Content
content-length: 0
date: Fri, 30 Nov 2018 03:05:59 GMT
server: Cowboy
```

### DELETE product:

```
$ curl -i -X DELETE http://localhost:8080/products/milk

HTTP/1.1 204 No Content
content-length: 0
date: Fri, 30 Nov 2018 02:52:03 GMT
server: Cowboy
```
