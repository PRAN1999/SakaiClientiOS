//
//  GradeItem.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 5/13/18.
//

import Foundation

class GradeItem {
    
    private var grade:Double
    private var points:Double
    private var title:String
    
    init(_ grade:Double, _ points:Double, _ title:String) {
        self.grade = grade
        self.points = points
        self.title = title
    }
    
    func getGrade() -> Double {
        return self.grade
    }
    
    func getPoints() -> Double {
        return self.points
    }
    
    func getTitle() -> String {
        return self.title
    }
    
}
