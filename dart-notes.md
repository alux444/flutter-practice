# types

- fundamental: int, double, String, bool, dynamic
- num: int or double
- records: anonymous, immutable aggregate type

```dart
var record = ('first', a: 2, b: true, 'last');
print(record.$1); // 'first'
print(record.a); // 2

(String, int) record = ('hello', 12);
({int a, int b}) record = (a: 1, b: 2);



({String name, int age}) userInfo(Map<String, dynamic> json)
var (name, age) = userInfo(json); // destructure using positional fields
final (:name, :age) = userInfo(json); // destructure using named fields
```

# syntax

```dart
// using variable in code
var age = 1;
var str = "Age: $age";

// literal string
String s = r'\n';
// multiline string
String ml = '''
hello
world
'''

// parsing
int one = int.parse('1');
assert(one == 1);
String str = 1.toString();
assert(str == '1');
str = 3.14169.toStringAsFixed(2);
assert(str == '3.14');

// constants
const constInteger = 12;
print(constInteger.runtimeType); // int

// null awareness
Object n;
int number = n?.num; // null
number = n?.num ?? 0; // 0
number = null;
print(number ??= 100); // 100

// arrow function
dynamic sum(var num1, var num2) => num1 + num2;
print(sum(1, 2));

dynamic sum({var num1, var num2}) => num1 + num2; // enforcing name parameters
print(sum(num1: 1, num2: 2));

dynamic sum(var num1, {var num2}) => num1 + num2; // num2 optional named parameter
print(sum(1)); // runtime error
dynamic sum(var num1, {var num2}) => num1 + (num2 ?? 0); // null checking
dynamic sum(var num1, {var num2 = 0}) => num1 + num2; // default value

dynamic sum(var num1, [var num2]) => num1 + (num2 ?? 0); // num2 optional positional parameter
```

# data structures

```dart
// list
List <String> names = ['a', 'b'];
List <String> constList = const ['a', 'b'];
List <String> deepCopy = [...names]; // normally a reference

// set
Set <String> mySet = {'a', 'b'};
var variable = {}; // implicitly a hashmap
variable = <String>{}; // set

// hashmap
var map = Map();
map['a'] = 'b';
Map <int, String> map = {
  1: 'a',
  2: 'b'
};
```

# classes

```dart
class Person {
  String name;
  int age;

  // named constructor
  Person.guest() {
    name = 'Guest';
    age = 18;
  }
}

Person guest = Person.guest();

final name; // can't be changed after initialisation - runtime constant
Person myPerson = Person('name');
myPerson.lastName = 'otherName';

static const int age = 10; // const - compile time constant
print(Person.age); // class scoped age

class Rectangle {
  num left, top, width, height;

  Rectangle(this.left, this.top, this.width. this.height);

  num get right => left + width;
  set right => left = value - width;
  num get bottom => top + height;
  set bottom => top = value - height;
}

Rectangle rect = Rectangle(1, 2, 10, 20);
rect.right = 4;
```

# exceptions

```dart
int greaterThanZero(int val) {
  if (val <= 0) {
    throw Exception('Value must be greater than 0');
  }
  return val;
}

var val;
try {
  greaterThanZero(val);
} on SpecificExceptionType {
  // specific handling
} catch (e) {
  print(e);
} finally {
  if (val == null) {
    print('Val is null');
  } else {
    print('Val is $val');
  }
}
```
