//
// InlineResponse2001.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct InlineResponse2001: Codable {

    public var violations: [String]
    public var locations: [String]

    public init(violations: [String], locations: [String]) {
        self.violations = violations
        self.locations = locations
    }


}

