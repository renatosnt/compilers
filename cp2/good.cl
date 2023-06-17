class Person {
};

class Student inherits Person {
};

class Employee inherits Person {
    isManager: Bool <- true;
    age: Int <- 25;
    salary: Int <- age * 1000;
    
    greet() : String {
        out_string("Hello, world!");
    };
    
    work(hours: Int) : String {
        if hours <= 0 then
            out_string("No work hours specified.");
        else
            out_string("Working for " + hours + " hours.");
        fi
    };
    
    checkAttendance() : String {
        if isManager then
            out_string("Manager's attendance checked.");
        else
            out_string("Employee's attendance checked.");
        fi
    };
    
    evaluatePerformance() : String {
        out_string("Performance evaluation in progress...");
    };
    
    updateSalary() : Object {
        salary <- salary + 1000;
        out_string("Salary updated.");
    };
    
    takeBreak() : Object {
        out_string("Taking a short break...");
    };
    
    sayGoodbye() : Object {
        {
            out_string("Goodbye!");
            out_string("Have a great day!");
        }
    };
    
    increaseAge() : Object {
        let newAge : Int <- age + 1 in {
            out_string("Celebrating birthday...");
            out_string("Age increased to " + newAge + ".");
        }
    };
};

class Manager inherits Employee {
    hasTeam: Bool <- true;
    numEmployees: Int <- 10;
    
    assignTasks() : Object {
        out_string("Assigning tasks to the team...");
    };
    
    conductMeeting() : Object {
        out_string("Conducting a team meeting...");
    };
    
    motivateTeam() : Object {
        out_string("Motivating the team for better performance...");
    };
    
    celebrateSuccess() : Object {
        out_string("Celebrating team's success!");
    };
    
    approveLeave() : Object {
        out_string("Approving leave requests...");
    };
    
    updateSalary() : Object {
        out_string("Salary cannot be updated for managers.");
    };
    
    increaseAge() : Object {
        out_string("Managers do not age!");
    };
};

class Customer inherits Person {
    hasMembership: Bool <- true;
    loyaltyPoints: Int <- 100;
    
    purchase(item: String) : Object {
        out_string("Purchasing " + item + "...");
    };
    
    checkMembership() : Object {
        if hasMembership then
            out_string("Membership is active.");
        else
            out_string("Membership is inactive.");
        fi
    };
    
    redeemPoints() : Object {
        out_string("Redeeming loyalty points...");
    };
    
    inquireBalance() : Object {
        out_string("Checking account balance...");
    };
    
    updateProfile() : Object {
        out_string("Updating customer profile...");
    };
    
    increaseAge() : Object {
        out_string("Customers do not age!");
    };
};