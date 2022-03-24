//
//  TableViewTests.swift
//  TableViewTests
//
//  Created by Nikola Andrijasevic on 20.3.22..
//
import ViewControllerPresentationSpy
import XCTest
@testable import CodingTaskMobile
class TableViewTests: XCTestCase {
    
    private var sut: ViewController!
   
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(
       identifier: String(describing: ViewController.self))
        sut.loadViewIfNeeded()
    }
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    func test_TableViewDelegates_shouldBeConnected(){
        XCTAssertNotNil(sut.tableView.dataSource)
        XCTAssertNotNil(sut.tableView.delegate)
    }
    func test_numberOfRowsInSectionShouldBe3(){
       setGitArray()
        XCTAssertEqual(numberOfRows(in: sut.tableView),20)
    }
    func test_cellForRow0ShouldSetCellLabelTo0(){
        setGitArray()
        let cell = cellForRow(in: sut.tableView, row: 0) as! TableViewCell
        XCTAssertEqual(cell.starCount.text, "\(0)")
    }
    func test_cellForRow5ShouldSetCellLabelTo5(){
        setGitArray()
        let cell = cellForRow(in: sut.tableView, row: 5) as! TableViewCell
        XCTAssertEqual(cell.starCount.text, "\(5)")
    }
    func test_didSelectItemAtRow0ShouldPresentDetailVCObjects(){
        let navigation = UINavigationController(rootViewController: sut)
        // putInWindow(sut)
        
        setGitArray()
        didSelect(in: sut.tableView, row: 0)
        executeRunLoop()
        
        XCTAssertNotNil(sut.navigationController)
        XCTAssertEqual(navigation.viewControllers.count,2, "2 navigation stack")
        let pushedVC = navigation.viewControllers.last
        guard let nextVC = pushedVC as? DetailViewController else {
            XCTFail("Expected DetailViewController, but was \(String(describing: pushedVC))")
            return }
        nextVC.loadViewIfNeeded()//to load DetailVC ibjects
        XCTAssertEqual(nextVC.starsCountLabel.text, "0")
        XCTAssertNotNil(nextVC.webView)
        XCTAssertNotNil(nextVC.starForkView)
    }
    
    func setGitArray(){
        for number in 0..<20 {
              let info = GitInfo(fullName: "John", owner: OwnerInfo(avatarUrl: "Url"), description: "lol", forksCount: 3, stargazersCount: number)
            sut.git2.append(info)
          }
    }

}


