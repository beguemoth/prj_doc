_id
���� ������������� �� ����� ����, �� MongoDB ������� ����������� �������� �������� �������� 12 ����. 
��� �������� ������� �� ���������� ���������: �������� ���� timestamp �������� 4 �����, ������������� ������ �� 3 ����, ������������� �������� �� 2 ���� � ������� �� 3 ����. 
����� �������, ������ 9 ���� ����������� ������������ ����� ������ �����, �� ������� ����� ���� ������� ���� ������.
--------
autoreplication - one master node and one or more slaves. If master node failes, one of slaves becames master. 

16 Mb file limit.

GridFS
������� GridFS ������� �� ���� ���������. � ������ ���������, ������� ���������� files, �������� ����� ������,
� ����� �� ����������, ��������, ������. � � ������ ���������, ������� ���������� chunks, � ���� ��������� ��������� �������� ������ ������, ������ ���������� �� 256 ��.

��� ������������ GridFS ����� ������������ ����������� ������� mongofiles, ������� ���� � ������ mongodb.

\bin

bsondump: ��������� ����������+ BSON-������ � ����������� �� � ����������� ������, ��������, � JSON
mongo: ������������ ���������� ��������� ��� �������������� � ������ ������, ������ ���� ���������� ������
mongod: ������ ��� ������ MongoDB. �� ������������ �������, ��������� �������� ������ � ��������� ��������� �������� � ������� ������ �� ���������� ������ ������
mongodump: ������� �������� ������ ��� ������
mongoexport: ������� ��� �������� ������ � ������� JSON, TSV ��� CSV
mongofiles: �������, ����������� ��������� ������� � ������� GridFS
mongoimport: �������, ������������ ������ � �������� JSON, TSV ��� CSV � ���� ������ MongoDB
mongorestore: ��������� ���������� ������ �� �����, ���������� mongodump, � ����� ��� ������������ ���� ������
mongos: ������ ������������� MongoDB, ������� �������� ������������ ������� � ���������� �������������� ������ � �������� MongoDB
mongorestat: ������������ �������� �������� � ��
mongotop: ������������� ������ �������� �������, ������������ �� �������� ������-������ � ��

c:\data\db
/data/db

���� �� �������� ������������� ������������ �����-�� ������ ���� � ������, �� ��� ����� �������� ��� ������� MongoDB �� ����� --dbpath.

---
show dbs
db --shows current db
db.stats()
use test1    //creates new db if it does not exist
db.usert.save({name : "Tom", age : 45})
db.usert.find()
db.users.find().pretty()
db.users.find().limit(3)
db.users.find().skip(3)
db.users.find().sort({name: 1}).skip(3).limit(3) // name : 1 --ascending order, -1 -- descending
db.users.find({name: "Tom"})
db.users.find({languages: "english"})
db.users.find({languages: ["english", "deutch"]})
db.users.find({"languages.0": "english"}) -- find array with english first place
db.users.find({name: "Tom"}, {age: 1})  --include age
db.users.find().sort({ $natural: -1 }) -- insertion order (backword) 
db.usert.findOne()
same as
db.usert.find().limit(1)	
db.users.find ({name: "Tom"}, {languages: {$slice : 2}}) --two first elements (one-based index)
db.users.find ({name: "Tom"}, {languages: {$slice : -2}}) --two last elements
db.users.find ({name: "Tom"}, {languages: {$slice : [1,2]}}) -- skip the first element and get two next

db.users.find ({age: {$lt : 30}})
db.users.find ({age: {$gt : 30, $lt: 50}})

$eq (�����)
$ne (�� �����)
$gt (������ ���)
$lt (������ ���)
$gte (������ ��� �����)
$lte (������ ��� �����)
$in ���������� ������ ��������, ���� �� ������� ������ ����� ���� ���������
$nin ���������� ������ ��������, ������� �� ������ ����� ���� ���������
db.users.find ({age: {$nin : [22, 32]}}) //returns also documents without field 'age'

values and field names in queries are case-dependent! Tom != TOM

$or: ��������� ��� �������, � �������� ������ ��������������� ������ �� ���� �������
$and: ��������� ��� �������, � �������� ������ ��������������� ����� ��������
$not: �������� ������ �� ��������������� �������
$nor: ��������� ��� �������, � �������� ������ �� �������������� ����� ��������
db.users.find ({$or : [{name: "Tom"}, {age: 22}]})
db.users.find ({name: "Tom", $or : [{age: 22}, {languages: "german"}]})

$all: ���������� ����� ��������, ������� ������ ������� � �������
$size: ���������� ���������� ���������, ������� ������ ���� � �������
$elemMatch: ���������� �������, ������� ������ ��������������� ������� � �������
db.users.find ({languages: {$all : ["english", "french"]}})
db.users.find ({languages: {$size:2}})
db.grades.find({courses: {$elemMatch: {name: "MongoDB", grade: {$gt: 3}}}})
db.users.find ({company: {$exists:true}})
db.users.find ({age: {$type:"number"}})
db.users.find ({name: {$regex:"b"}})
{$regex:"om$"} - �������� name ������ ������������ �� "om".
	
db.usert.stats()

db.users.remove({name : "Tom"}) //remove all documents with key name=Tom
???? db.users.remove({name : "Tom"}, true) //removes only one document. What document?
db.users.remove({name : /T\w+/i})
db.users.remove({age: {$lt : 30}})
db.users.remove({})  //removes all docs from collection
db.users.drop() //removes collection
db.dropDatabase()

-------cursors
var cursor = db.users.find();null;
> while(cursor.hasNext()){
... obj = cursor.next();
... print(obj["name"]);
... }

var cursor = db.users.find();null;
null
> cursor.limit(5);null;
null
> cursor.forEach(function(obj){
... print(obj.name);
... })

var cursor = db.users.find();null;
null
> cursor.sort({name:1});null;
null
> cursor.forEach(function(obj){
... print(obj.name);
... })

var cursor = db.users.find();null;
null
> cursor.sort({name:1}).limit(3).skip(2);null;
null
> cursor.forEach(function(obj){
... print(obj.name);
... })
--------------
db.usert.count()
db.usert.find({name : "���"}).count()
db.users.find({name: "Tom"}).skip(2).count(true)
db.usert.distinct("name")

//������� group ������� � ������ 3.4 ��������� deprecated
db.users.group (
{
key: {name : true},   //group by 'name' field
initial: {total : 0}, //aggregate field will have name 'total' with inital value 0
reduce : function (curr, res){res.total += 1} //function, that forms aggregate value 'total'
})

key: ��������� �� ����, �� �������� ���� ��������� �����������
initial: �������������� ���� ���������, ������� ����� ������������ ������ ����������
reduce: ������������ �������, ������������ ���������� ���������. ��� ������� ��������� � �������� ���������� ��� ���������: ������� ������� � ���������� �������������� �������� ��� ������� ������
keyf: �������������� ��������. ������������ ������ ��������� key � ������������ �������, ������� ���������� ������ key
cond: �������������� ��������. ������������ ����� �������, ������� ������ ���������� true, ����� �������� �� ������ ������� � �����������. ���� ������ �������� ��������, �� � ����������� ��������� ��� ���������
finalize: �������������� ��������. ������������ �������, ������� ����������� ����� ���, ��� ����� ���������� ���������� �����������.

-------
      database
   |            |
collection1  collection2
   |            |
doc1          doc1
doc2          doc2
...           ...
docN          docN

----------
String: ��������� ��� ������, ��� � ����������� ���� ������� (��� ����� ������������ ��������� UTF-8)
Array (������): ��� ������ ��� �������� �������� ���������
Binary data (�������� ������): ��� ��� �������� ������ � �������� �������
Boolean: ������� ��� ������, �������� ���������� �������� TRUE ��� FALSE, ��������, {"married": FALSE}
Date: ������ ���� � ������� ������� Unix
Double: �������� ��� ������ ��� �������� ����� � ��������� ������
Integer: ������������ ��� �������� ������������� ��������, ��������, {"age": 29}
JavaScript: ��� ������ ��� �������� ���� javascript
Min key/Max key: ������������ ��� ��������� �������� � ����������/���������� ��������� BSON
Null: ��� ������ ��� �������� �������� Null
Object: ��������� ��� ������, ��� � ����������� ���� �������
ObjectID: ��� ������ ��� �������� id ���������
Regular expression: ����������� ��� �������� ���������� ���������
Symbol: ��� ������, ���������� ����������. ������������ ��������������� ��� ��� ������, � ������� ���� ����������� �������.
Timestamp: ����������� ��� �������� �������
----
Not the same types!
{"age" : "28"}
{"age" : 28}
--------------
insertOne(): ��������� ���� ��������
db.users.insertOne({"name": "Tom", "age": 28, languages: ["english", "spanish"]})
db.users.insertOne({"_id": 123457, "name": "Tom", "age": 28, languages: ["english", "spanish"]})
����� ��������, ��� �������� ������ ����� �������������� � ��������, � ����� � ��� �������.

insertMany(): ��������� ��������� ����������
db.users.insertMany([{"name": "Bob", "age": 26, languages: ["english", "frensh"]}, 
{"name": "Alice", "age": 31, languages:["german", "english"]}])

insert(): ����� ��������� ��� ����, ��� � ��������� ����������
document=({"name": "Bill", "age": 32, languages: ["english", "french"]})
db.users.insert(document)

-------
c:\users.js
 
db.users.insertMany([
{"name": "Alice", "age": 31, languages: ["english", "french"]},
{"name": "Lene", "age": 29, languages: ["english", "spanish"]},
{"name": "Kate", "age": 30, languages: ["german", "russian"]}
])

load("c:/users.js")
------
db.users.find({name : "Alice"}, {age : 1}, {languages : 0}) //includes age, excludes languages
db.users.find({name : "Alice"}, {age : true}, {languages : false}) //includes age, excludes languages

db.users.insert({"name": "Alex", "age": 28, company: {"name":"microsoft", "country":"USA"}})
db.users.find({"company.name": "microsoft"})

fn = function() { return this.name=="Tom"; }
db.users.find(fn)
db.users.find("this.name=='Tom'")

function quadrat(n) { return n*n; }
quadrat(5)
25



db.dropDatabase()
��� ������� �������: ������� ���������, ��������������� �� � ���� db.vasians.renameCollection("����������� ���������!") ,� ���


???-------
��� �����
	�������
	������� SSLH
How to obtain collection list?

db.users.find({name:/T\w+/i})