// RUN: %target-typecheck-verify-swift -enable-parser-lookup

class A1 {
  func foo1() {}
  func foo2() {
    var foo1 = foo1() // expected-error {{variable used within its own initial value}}
  }
}

class A2 {
  var foo1 = 2
  func foo2() {
    // FIXME: "the var" doesn't sound right.
    var foo1 = foo1 // expected-error {{variable used within its own initial value}}
  }
}

class A3 {
  func foo2() {
    // FIXME: this should also add fixit.
    var foo1 = foo1() // expected-error {{variable used within its own initial value}}{{none}}
  }
  func foo1() {}
}

class A4 {
  func foo2() {
    var foo1 = foo1 // expected-error {{variable used within its own initial value}}{{none}}
  }
}

func localContext() {
  class A5 {
    func foo1() {}
    func foo2() {
      var foo1 = foo1() // expected-error {{variable used within its own initial value}}
    }

    class A6 {
      func foo1() {}
      func foo2() {
        var foo1 = foo1() // expected-error {{variable used within its own initial value}}
      }
    }

    extension E { // expected-error {{declaration is only valid at file scope}}
      // expected-error@-1{{cannot find type 'E' in scope}}
      class A7 {
        func foo1() {}
        func foo2() {
          var foo1 = foo1() // expected-error {{variable used within its own initial value}}
        }
      }
    }
  }
}
