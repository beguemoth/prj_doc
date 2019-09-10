_id
Если идентификатор не задан явно, то MongoDB создает специальное бинарное значение размером 12 байт. 
Это значение состоит из нескольких сегментов: значение типа timestamp размером 4 байта, идентификатор машины из 3 байт, идентификатор процесса из 2 байт и счетчик из 3 байт. 
Таким образом, первые 9 байт гарантируют уникальность среди других машин, на которых могут быть реплики базы данных.
--------
autoreplication - one master node and one or more slaves. If master node failes, one of slaves becames master. 

16 Mb file limit.

GridFS
Система GridFS состоит из двух коллекций. В первой коллекции, которая называется files, хранятся имена файлов,
а также их метаданные, например, размер. А в другой коллекции, которая называется chunks, в виде небольших сегментов хранятся данные файлов, обычно сегментами по 256 кб.

Для тестирования GridFS можно использовать специальную утилиту mongofiles, которая идет в пакете mongodb.

\bin

bsondump: считывает содержимое+ BSON-файлов и преобразует их в читабельный формат, например, в JSON
mongo: представляет консольный интерфейс для взаимодействия с базами данных, своего рода консольный клиент
mongod: сервер баз данных MongoDB. Он обрабатывает запросы, управляет форматом данных и выполняет различные операции в фоновом режиме по управлению базами данных
mongodump: утилита создания бэкапа баз данных
mongoexport: утилита для экспорта данных в форматы JSON, TSV или CSV
mongofiles: утилита, позволяющая управлять файлами в системе GridFS
mongoimport: утилита, импорирующая данных в форматах JSON, TSV или CSV в базу данных MongoDB
mongorestore: позволяет записывать данные из дампа, созданного mongodump, в новую или существующую базу данных
mongos: служба маршрутизации MongoDB, которая помогает обрабатывать запросы и определять местоположение данных в кластере MongoDB
mongorestat: представляет счетчики операций с бд
mongotop: предоставляет способ подсчета времени, затраченного на операции чтения-записи в бд

c:\data\db
/data/db

Если же возникла необходимость использовать какой-то другой путь к файлам, то его можно передать при запуске MongoDB во флаге --dbpath.

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

$eq (равно)
$ne (не равно)
$gt (больше чем)
$lt (меньше чем)
$gte (больше или равно)
$lte (меньше или равно)
$in определяет массив значений, одно из которых должно иметь поле документа
$nin определяет массив значений, которые не должно иметь поле документа
db.users.find ({age: {$nin : [22, 32]}}) //returns also documents without field 'age'

values and field names in queries are case-dependent! Tom != TOM

$or: соединяет два условия, и документ должен соответствовать одному из этих условий
$and: соединяет два условия, и документ должен соответствовать обоим условиям
$not: документ должен НЕ соответствовать условию
$nor: соединяет два условия, и документ должен НЕ соответстовать обоим условиям
db.users.find ({$or : [{name: "Tom"}, {age: 22}]})
db.users.find ({name: "Tom", $or : [{age: 22}, {languages: "german"}]})

$all: определяет набор значений, которые должны иметься в массиве
$size: определяет количество элементов, которые должны быть в массиве
$elemMatch: определяет условие, которым должны соответствовать элемены в массиве
db.users.find ({languages: {$all : ["english", "french"]}})
db.users.find ({languages: {$size:2}})
db.grades.find({courses: {$elemMatch: {name: "MongoDB", grade: {$gt: 3}}}})
db.users.find ({company: {$exists:true}})
db.users.find ({age: {$type:"number"}})
db.users.find ({name: {$regex:"b"}})
{$regex:"om$"} - значение name должно оканчиваться на "om".
	
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
db.usert.find({name : "Том"}).count()
db.users.find({name: "Tom"}).skip(2).count(true)
db.usert.distinct("name")

//функция group начиная с версии 3.4 объявлена deprecated
db.users.group (
{
key: {name : true},   //group by 'name' field
initial: {total : 0}, //aggregate field will have name 'total' with inital value 0
reduce : function (curr, res){res.total += 1} //function, that forms aggregate value 'total'
})

key: указывает на ключ, по которому надо проводить группировку
initial: инициализирует поля документа, который будет представлять группу документов
reduce: представляет функцию, возвращающую количество элементов. Эта функция принимает в качестве аргументов два параметра: текущий элемент и агрегатный результирующий документ для текущей группы
keyf: необязательный параметр. Используется вместо параметра key и представляет функцию, которая возвращает объект key
cond: необязательный параметр. Представляет собой условие, которое должно возвращать true, иначе документ не примет участия в группировке. Если данный параметр неуказан, то в группировке участвуют все документы
finalize: необязательный параметр. Представляет функцию, которая срабатывает перед тем, как будут возвращены результаты группировки.

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
String: строковый тип данных, как в приведенном выше примере (для строк используется кодировка UTF-8)
Array (массив): тип данных для хранения массивов элементов
Binary data (двоичные данные): тип для хранения данных в бинарном формате
Boolean: булевый тип данных, хранящий логические значения TRUE или FALSE, например, {"married": FALSE}
Date: хранит дату в формате времени Unix
Double: числовой тип данных для хранения чисел с плавающей точкой
Integer: используется для хранения целочисленных значений, например, {"age": 29}
JavaScript: тип данных для хранения кода javascript
Min key/Max key: используются для сравнения значений с наименьшим/наибольшим элементов BSON
Null: тип данных для хранения значения Null
Object: строковый тип данных, как в приведенном выше примере
ObjectID: тип данных для хранения id документа
Regular expression: применяется для хранения регулярных выражений
Symbol: тип данных, идентичный строковому. Используется преимущественно для тех языков, в которых есть специальные символы.
Timestamp: применяется для хранения времени
----
Not the same types!
{"age" : "28"}
{"age" : 28}
--------------
insertOne(): добавляет один документ
db.users.insertOne({"name": "Tom", "age": 28, languages: ["english", "spanish"]})
db.users.insertOne({"_id": 123457, "name": "Tom", "age": 28, languages: ["english", "spanish"]})
Стоит отметить, что названия ключей могут использоваться в кавычках, а могут и без кавычек.

insertMany(): добавляет несколько документов
db.users.insertMany([{"name": "Bob", "age": 26, languages: ["english", "frensh"]}, 
{"name": "Alice", "age": 31, languages:["german", "english"]}])

insert(): может добавлять как один, так и несколько документов
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
Как сломать систему: создаем коллекцию, переименовываем ее в типа db.vasians.renameCollection("СУПЕРПУППЕР КОЛЛЕКЦИЯ!") ,и все


???-------
что такое
	реплика
	туннель SSLH
How to obtain collection list?

db.users.find({name:/T\w+/i})