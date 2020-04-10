import XCTest

import MyLibraryTests

var tests = [XCTestCaseEntry]()
tests += CerberusTests.allTests()
XCTMain(tests)
