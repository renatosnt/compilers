class A {
};

class BB__ inherits A {

};

class C inherits IO {
    num1: Int <- 10;
    num2: Int <- 20;
    str: String <- "Hello, world!";
    
    a() : String {
        out_string("This is method A.");
    };
    
    b() : Int {
        let x : Int <- num1 + num2 in {
            out_string("The sum of num1 and num2 is ");
            out_int(x);
            x;
        }
    };
    
    c() : X {
        case 1 = 1 of
            x : X => x;
        esac
    };
    
    d() : X {
        case 1 = 2 of
            x : X => x;
            y : Y => y;
        esac
    };
    
    e() : Object {
        {
            out_string("Printing numbers:");
            out_int(num1);
            out_int(num2);
        }
    };
    
    f() : Object {
        {
            out_string("Printing string:");
            out_string(str);
        }
    };
    
    g() : Object {
        let y : Y <- new Y in {
            out_string("Created a new instance of Y.");
        }
    };
    
    h() : Object {
        {
            out_string("Method H - Part 1");
            out_string("Method H - Part 2");
        }
    };
    
    i() : Object {
        let n : Int <- 5 in {
            out_string("The value of n is ");
            out_int(n);
        }
    };
};