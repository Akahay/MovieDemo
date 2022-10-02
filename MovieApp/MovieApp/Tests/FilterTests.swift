//
//  FilterTests.swift
//  MovieAppTests
//
//  Created by Akshay Naithani on 01/10/22.
//

import XCTest
@testable import MovieApp

final class FilterTests: XCTestCase, LoadJsonProtocol {
    
    let viewModel = FilterlListViewModel()
    
    func test_title() {
        XCTAssertEqual(viewModel.title, "Select filter")
    }
    
    func test_searchTypeEmpty() {
        XCTAssertTrue(viewModel.searchTypes.isEmpty)
    }
    
    func test_searchTypeAllCases() {
        viewModel.loadData()
        XCTAssertEqual(viewModel.searchTypes, SearchType.allCases as [SearchType])
    }
    
}
