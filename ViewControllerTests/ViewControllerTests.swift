//
//  ViewControllerTests.swift
//  ViewControllerTests
//
//  Created by Nikola Andrijasevic on 18.3.22..
//
import ViewControllerPresentationSpy
import XCTest
@testable import CodingTaskMobile
class ViewControllerTests: XCTestCase {
    private var sut : ViewController!
    private var session: MockURLSession!
    private var alertVerifier: AlertVerifier!
   
    override func setUp() {
       super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
         sut = storyboard.instantiateViewController(
        identifier: String(describing: ViewController.self))
        session = MockURLSession()
        
        sut.session = session//Inject mock
        sut.loadViewIfNeeded()
    }
    
    override  func tearDown() {
        //executeRunLoop()//To give the window a chance to disappear, add a call to execute the run loop.
        sut = nil
        session = nil
        alertVerifier = nil
        super.tearDown()
    }
    func test_navigationBarTitleIs_Github_Trends(){
        let navigation = UINavigationController(rootViewController: sut)
        XCTAssertNotNil(sut.navigationController)
        XCTAssertEqual(navigation.navigationBar.topItem?.title, "Github Trends")
    }
    func test_ConfirmSUTCalled_dataTaskMethodOnceWithThisRequestAsArgument(){
        //sut.fetchData()
        XCTAssertEqual(session.dataTaskCallCount, 1)
        XCTAssertEqual(session.dataTaskArgsRequest.first, URLRequest(url: URL(string: "https://api.github.com/search/repositories?q=created:%3E2022-03-08")!),"request")
    }
    func test_DataForAsyncSuccessURLSessionResponse(){
        let handleResultsCalled = expectation(description: "handleResults called")
        sut.handleResults = {_ in
            handleResultsCalled.fulfill()
        }
        session.dataTaskArgsCompletionHandler.first?(
            jsonData(),response(statusCode: 200)!,nil)//we provided mock objets(fake objects)
        waitForExpectations(timeout: 0.1)
        //print(sut.git)
       XCTAssertEqual(sut.git, [GitInfo(fullName: "Nikola",owner: OwnerInfo(avatarUrl: "URL"), description: "junior", forksCount: 2, stargazersCount: 2)])
    }
    func test_dataBeforeAsyncSuccessShouldNotBeSaved(){
        session.dataTaskArgsCompletionHandler.first?(jsonData(),response(statusCode: 200),nil)
        XCTAssertEqual(sut.git, [])
    }
    
    func test_AfterAsyncNetworkErrorShouldShowAlert(){
        let alertShowm = expectation(description: "alert shown")
       
        alertVerifier.testCompletion = {
            alertShowm.fulfill()
        }
        session.dataTaskArgsCompletionHandler.first?(
            nil,nil,TestError(message: "Lele")
        )
        wait(for: [alertShowm], timeout: 0.01)
        verifyErrorAlert(message: "Lele")
    }
    func test_beforeAsyncNetworkErrorShouldNotBeShown(){
        session.dataTaskArgsCompletionHandler.first?(jsonData(),response(statusCode: 200),TestError(message: "No message"))
        XCTAssertEqual(alertVerifier.presentedCount, 0)
    }
    
    private func verifyErrorAlert(message: String, file: StaticString = #file, line: UInt = #line){
        alertVerifier.verify(title: "Network problem", message: message, animated: true, actions: [.default("OK")], presentingViewController: sut,file: file,line: line)
        XCTAssertEqual(alertVerifier.preferredAction?.title, "OK","preferred action", file: file,line: line)
    }
    
    func test_sortButtonShouldChangeNameOnFirstTap(){
        sut.sorting()
        let rightBarButtonItem = self.sut.navigationItem.rightBarButtonItem?.title
        XCTAssertNotNil(rightBarButtonItem)
        XCTAssertEqual(rightBarButtonItem,"Sort by most stars")
    }
    func test_sortButtonShouldChangeBackToInitialTitleOnSecondTap(){
        sut.sorting()
        sut.sorting()
        let rightBarButtonItem = self.sut.navigationItem.rightBarButtonItem?.title
        XCTAssertNotNil(rightBarButtonItem)
        XCTAssertEqual(rightBarButtonItem,"Sort by least stars")
    }

}
private func response(statusCode: Int) -> HTTPURLResponse?{
    HTTPURLResponse(url: URL(string: "http")!, statusCode: statusCode, httpVersion: nil, headerFields: nil)
}

private func jsonData() -> Data {
        """
{
"items": [
{
    "fullName": "Nikola",
    "owner" : {
     "avatarUrl" : "URL"
        },
    "description": "junior",
    "forksCount": 2,
    "stargazersCount": 2
        }
    ]
}
""".data(using: .utf8)!
    }

struct TestError : LocalizedError {
    let message: String
    var errorDescription: String? {message}
}
