import Foundation

func testVariable() {
    let constantBoolean = true
    var variableInteger = 2
    var typedVariableString: String = "Hello"
}

func testTuple() {
    let tuple = (404, "Not Found")
    let (statusCode, statusMessage) = tuple
    let (justTheStatusCode, _) = tuple
    let namedTuple = (statusCode: 200, description: "OK")
}

func testOptional() {
    var optionalInteger: Int?
    optionalInteger = nil
    optionalInteger = 1
    let nonOptionalInteger: Int = optionalInteger!
}

func testArray() {
    var integerArray = [Int]()
    integerArray.append(1)
    integerArray.insert(0, at: 0)
    integerArray = []
    
    var literalStringArray: [String] = ["Egg", "Milk"]
    literalStringArray += ["Cheese", "Butter"]
    literalStringArray[0...3] = ["Apples"]
    for _ in literalStringArray {
        
    }
    
    var threeDoubles = Array(repeating: 0.0, count: 3)
}

func testString() {
    
    let str = "한你👪🇺🇸"

    let cfstr = str as CFString
    let cfstrLength = CFStringGetLength(cfstr)
    for i in 0..<cfstrLength {
        let code = CFStringGetCharacterAtIndex(cfstr, i)
        print("\(i):\(code)")
    }
    
    var startIndex = str.startIndex
    for i in 0..<str.count  {
        let index = str.index(startIndex, offsetBy: i)
        let c = str[index]
        print("\(i):\(c)")
        
        for utf8Code in c.utf8 {
            print("\tutf8:\(utf8Code)")
        }
        for utf16Code in c.utf16 {
            print("\tutf16:\(utf16Code)")
        }
        for unicode in c.unicodeScalars {
            print("\tunicode:\(unicode)")
        }
    }
    
}

func testDictionary() {
    var emptyDict = [Int: String]()
    emptyDict = [:]
    var literalDict: [String: String] = ["key0": "value0", "key1": "value1"]
    if let _ = literalDict.updateValue("value2", forKey: "key2") {
        //key2不存在，不会进入
    }
    if let _ = literalDict.removeValue(forKey: "key1") {
        //会进入
    }
    if let _ = literalDict["key2"] {
        //会进入
    }
    for (_, _) in literalDict {
        
    }
    for _ in literalDict.keys {
        
    }
    for _ in literalDict.values {
        
    }
    let keys = [String](literalDict.keys)
    let values = [String](literalDict.values)
}

func testFunction() {
    func multiReturn() -> (min: Int, max: Int) {
        return (0, 1)
    }
    let (min, max) = multiReturn()
//-----------------------------------------------
    func implicitReturn() -> String {
        ""
    }
    let r = implicitReturn()
// -------------------------------------------------
    func argumentLabel(outsideName insideName: String) {
        
    }
    argumentLabel(outsideName: "argumentLabelTest")
// -------------------------------------------------
    func omittingArgumentLabel(_ insideName: Int) {
        
    }
    omittingArgumentLabel(6)
// -------------------------------------------------
    func variadicParameters(_ numbers: Double...) {
        for _ in numbers {
        }
    }
    variadicParameters(4.0, 5.0, 6.0)
// -------------------------------------------------
    func inoutParameters(_ a: inout Int, _ b: inout Int) {
        let temporaryA = a
        a = b
        b = temporaryA
    }
// -------------------------------------------------
    func addTwoInts(_ a: Int, _ b: Int) -> Int {
        return a + b
    }
    var functionType: (Int, Int) -> Int = addTwoInts
    let sum = functionType(2, 3);
}

func testClosure() {
    let names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
    //非闭包形式
    func backward(_ s1: String, _ s2: String) -> Bool {
        return s1 > s2
    }
    var reversedNames = names.sorted(by: backward)
    //基本闭包形式
    reversedNames = names.sorted(by: { (s1: String, s2: String) -> Bool in
        return s1 > s2
    })
    //自动类型推导
    reversedNames = names.sorted(by: { s1, s2 in return s1 > s2 } )
    //单表达式省略return
    reversedNames = names.sorted(by: { s1, s2 in s1 > s2 } )
    //省略参数
    reversedNames = names.sorted(by: { $0 > $1 } )
    //省略括号
    reversedNames = names.sorted { $0 > $1 }
    //操作符方法
    reversedNames = names.sorted(by: >)

    //trailing closure
    func someFunctionThatTakesAClosure(closure: () -> Void) {
        // function body goes here
    }
    // Here's how you call this function without using a trailing closure:
    someFunctionThatTakesAClosure(closure: {
        // closure's body goes here
    })
    // Here's how you call this function with a trailing closure instead:
    someFunctionThatTakesAClosure() {
        // trailing closure's body goes here
    }

    //todo: Escaping Closures
}

func testEnumeration() {
    enum CompassPoint {
        case north
        case south
        case east
        case west
    }
    var directionToHead = CompassPoint.west //定义时需要明确指定枚举类型
    directionToHead = .east //后续修改可缺省类型

    switch directionToHead {
    case .north:
        print("");
    default:
        print("");
    }
// -------------------------------------------------
    enum Beverage: CaseIterable {
        case coffee, tea, juice
    }
    let numberOfChoices = Beverage.allCases.count
    for beverage in Beverage.allCases {
        print(beverage)
    }
// -------------------------------------------------
    enum AssociatedValue
    {
        case fourIntType(Int, Int, Int, Int)
        case oneStringType(String)
    }
    var associatedVal = AssociatedValue.fourIntType(8, 85909, 51226, 3)
    associatedVal = .oneStringType("ABCDEFGHIJKLMNOP")
    switch associatedVal {
    case .fourIntType(let firstInt, let secondInt, let thirdInt, let fourthInt):
        print("\(firstInt), \(secondInt), \(thirdInt), \(fourthInt)")
    case .oneStringType(let firstString):
        print(firstString)
    }
// -------------------------------------------------
    enum RawValue : Character {
        case tab = "\t"
        case lineFeed = "\n"
        case carriageReturn = "\r"
    }

    enum ImplicatlyIntegerRawValue : Int {
        case mercury = 1, venus, earth, mars, jupiter, saturn, uranus, neptune
    }
    let earthsOrder = ImplicatlyIntegerRawValue.venus.rawValue //2
    enum ImplicatlyStringRawValue : String
    {
        case north, south, east, west
    }
    let sunsetDirection = ImplicatlyStringRawValue.east.rawValue //"east"

}

func testClassAndStruct() {
    class SomeClass {
        var member = 0
        var text: String? //nil
    }
    var instance0 = SomeClass()
    var instance1 = SomeClass()
    let identity = instance0 === instance1 //false
    //-----------------------------------------------
    class LazyClass {
        //第一次访问改成员时才会初始化，多个线程同时访问为初始化的成员变量时可能会多次初始化
        lazy var lazyMember = SomeClass()
    }
    //-----------------------------------------------
    struct Circle {
        //property observer
        //在类中定义默认值或在构造函数赋值时监听器不会被调用
        var r = 0.0 {
            willSet(newR) {
                //可以不定义newR，使用隐式参数newValue
            }
            didSet(oldR) {
                //可以不定义oldR，使用隐式参数oldValue
            }
        }
        //computed property
        var d: Double {
            get {
                return r * 2.0
            }
            set(newD) {
                r = newD / 2.0
            }
        }
        //shorthand setter/getter
        var c: Double {
            get {
                //省略
                r * 2.0 * 3.14
            }
            set {
                //隐式参数newValue
                r = newValue / 2.0 / 3.14
            }
        }
        //read only computed property
        var s: Double {
            2.0 * 3.14 * r * r
        }
    }
    //-----------------------------------------------
    @propertyWrapper
    struct SmallNumber {
        private var maximum: Int
        private var number: Int

        //变量名wrappedValue是规范
        var wrappedValue: Int {
            get { return number }
            set {
                projectedValue = newValue > maximum
                number = projectedValue ? maximum : newValue
            }
        }
        //变量名projectedValue是规范
        var projectedValue: Bool
        
        init() {
            maximum = 12
            number = 0
            projectedValue = false
        }
        init(wrappedValue: Int) {
            maximum = 12
            projectedValue = wrappedValue > maximum
            number = projectedValue ? maximum : wrappedValue
            
        }
        init(wrappedValue: Int, maximum: Int) {
            self.maximum = maximum
            projectedValue = wrappedValue > maximum
            number = projectedValue ? maximum : wrappedValue
        }
    }
    struct SmallRectangle {
        @SmallNumber var height: Int
        @SmallNumber var width: Int
    }
    struct NarrowRectangle {
        @SmallNumber(wrappedValue: 2, maximum: 5) var height: Int
        @SmallNumber(wrappedValue: 3, maximum: 4) var width: Int
    }
    struct MixedRectangle {
        @SmallNumber var height: Int = 1
        @SmallNumber(maximum: 9) var width: Int = 2
    }
    var rect = SmallRectangle()
    rect.width = 13
    //使用$访问projected value
    var overflow = rect.$width //true
    rect.width = 12
    overflow = rect.$width //false
    //-----------------------------------------------
    class TypeMathodClass {
        //静态成员变量默认lazy且多线程访问时保证只初始化一次
        static var storedTypeProperty = "Some value."
        static var computedTypeProperty: Int {
            return 27
        }
        //这里的class关键字表示该静态变量可以被子类重载
        class var overrideableComputedTypeProperty: Int {
            return 107
        }
        
        static func typeMethod() {
            
        }
        class func overrideableTypeMethod() {
            
        }
        func instanceMethod() {
            //调用静态函数
            TypeMathodClass.typeMethod();
        }
    }
    //-----------------------------------------------
    struct MutatingStrcture {
        var x = 0.0
        //结果和枚举成员函数默认为constant，修改成员变量需要加上mutating
        mutating func set(outerX innerX: Double) {
            x = innerX
        }
    }
    //-----------------------------------------------
    struct Matrix {
        //[]操作符重载
        subscript(row: Int, column: Int) -> Double {
            get {
                0
            }
            set {
                
            }
        }
        //静态[]操作符，通过Matrix[]调用
        static subscript(n: Int) -> Int {
            0
        }
    }
    //-----------------------------------------------
    class SuperClass {
        func overridableMethod() {}
        var overridableProperty: Int = 0
        
        final func nonOverridableMethod() {}
        final var nonOverridableProperty: Int = 0
    }
    class SubClass: SuperClass {
        override var overridableProperty: Int {
            get {
                super.overridableProperty
            }
            set {
                super.overridableProperty = newValue
            }
        }
    }
    //-----------------------------------------------
    //对于构造函数，argument label可以作为函数签名的一部分，通过不同的argument label重载构造函数
    struct Celsius {
        var temperatureInCelsius: Double
        init(fromFahrenheit fahrenheit: Double) {
            temperatureInCelsius = (fahrenheit - 32.0) / 1.8
        }
        init(fromKelvin kelvin: Double) {
            temperatureInCelsius = kelvin - 273.15
        }
        init(_ celsius: Double) {
            temperatureInCelsius = celsius
        }
    }
    let boilingPointOfWater = Celsius(fromFahrenheit: 212.0)
    let freezingPointOfWater = Celsius(fromKelvin: 273.15)
    let bodyTemperature = Celsius(37.0)
    //-----------------------------------------------
    //使用编译器提供的默认构造函数时，类必须为属性提供默认值，结构可以不提供
    class DefaultInitializerClass {
        var i: Int = 0
    }
    struct DefaultInitializerStruct {
        var i: Int
    }
    let defaultClassInstance = DefaultInitializerClass()
    let defaultStructInstance = DefaultInitializerStruct(i: 0) //memberwise initializer
    //-----------------------------------------------
    class ConvenienceClass {
        init(_ param0: Int, _ param1: Int, _ param2: Int) {
            
        }
        convenience init() {
            let defaultParam0 = 0
            let defaultParam1 = 1
            let defaultParam2 = 2
            self.init(defaultParam0, defaultParam1, defaultParam2)
        }
    }
    class ConvenienceSubClass: ConvenienceClass {
        //子类构造函数和父类一致，需要加上override
        override init(_ param0: Int, _ param1: Int, _ param2: Int) {
            super.init(param0, param1, param2)
        }
    }
    //-----------------------------------------------
    class FailableClass {
        init?() {
            return nil
        }
        init(_ param: Int) {
            
        }
    }
    let failableInstance = FailableClass()
    let nonFailableInstance = FailableClass(1)
    let _ = type(of: failableInstance) //FailableClass?
    let _ = type(of: nonFailableInstance) //FailableClass

    class NonFailableSubClass: FailableClass {
        override init() {
            super.init(0);
        }
    }
    //-----------------------------------------------
    class InitRequireClass {
        //required表示所有子类必须实现此构造函数
        required init() {
            
        }
    }
    //-----------------------------------------------
    class DefaultValueByClosure {
        //注意和computed property区分
        let property: Int = {
           return 0
        }()
    }

}

func testOptionalChaining() {
    class OptionalChainingClass {
        var member: Int = 0
        func method() -> Int {
            return 0
        }
    }
    
    var obj: OptionalChainingClass? = nil
    
    //和属性值无关，只取决于obj是否为nil
    if let _ = obj?.member {
        print("obj is not nil")
    }
    else {
        print("obj is nil")
    }
    
    
    if (obj?.member = 1) != nil {
        //赋值=1 成功
    }
    else {
        //赋值失败
    }
    
    obj = OptionalChainingClass()
    
    //和函数返回值无关，只取决于obj是否为nil
    if let _ = obj?.method() {
        print("obj is not nil")
    }
    else {
        print("obj is nil")
    }
}

func testTypeCasting() {
    class Super {
        
    }
    
    class Sub: Super {
        
    }
    
    //checking type
    let sup = Super()
    let sub = Sub()
    
    let superAsAny: Any = Super()
    let numberAsAny: Any = 5
    
    print(sup is Super) //true
    print(sub is Sub) //true
    print(sup is Sub) //false
    print(sub is Super) //true
    print(superAsAny is Super) //true
    print(numberAsAny is Super) //false
    
    let _: Super? = sub as? Super
    let _: Super! = sub as! Super
    let _: Super = sub as Super
    
    let _: Super? = superAsAny as? Super
    let _: Super! = superAsAny as! Super
    //let _: Super = superAsAny as Super //not compilable
    
    let _: Super? = numberAsAny as? Super //nil
    let _: Super! = numberAsAny as! Super //crash
    //let _: Super = numberAsAny as Super //not compilable
}


func testPointer() {
//    UnsafePointer<Pointee>
//    UnsafeBufferPointer<Pointee>
//    UnsafeRawPointer
//    UnsafeRawBufferPointer
//    UnsafeMutablePointer<Pointee>
//    UnsafeMutableBufferPointer<Pointee>
//    UnsafeMutableRawBufferPointer
//    UnsafeRawBufferPointer
//
//
//    Pointer: a pointer to an element in memory with an unknown count
//    BufferPointer: a pointer to a buffer of elements in memory with a known count
//
//    Pointer: Pointee*
//    MutablePointer: const Pointee*
//
//    Unsafe pointers have an associated type Pointee which represents the type of data being pointed at
//    Pointer<Pointee>: Typed unsafe pointers are generic over their Pointee type
//    RawPointer: Raw unsafe pointers have their Pointee fixed to UInt8, representing a byte of memory
    
    let mutableRawPointer: UnsafeMutableRawPointer = UnsafeMutableRawPointer.allocate(byteCount: MemoryLayout<Float>.stride * 100, alignment: 1)
    mutableRawPointer.initializeMemory(as: Float.self, repeating: 3.0, count: 100)
    let mutableFloatPointer: UnsafeMutablePointer<Float> = mutableRawPointer.bindMemory(to: Float.self, capacity: 1024)
    let floatValue = mutableFloatPointer[0]
    print(floatValue) //3
    mutableRawPointer.deallocate()
}

func testMemoryLayout() {
    struct ExampleStruct0 {
        let foo: Int  // 8
        let bar: Bool // 1
    }

    print(MemoryLayout<ExampleStruct0>.size)      // 9
    print(MemoryLayout<ExampleStruct0>.stride)    // 16
    print(MemoryLayout<ExampleStruct0>.alignment) // 8
}
