//
//  ValueTransformerRegistration.swift
//  WorshipSongManager
//
//  Created by Paul Lyons on 4/30/25.
//

import Foundation

class ArrayValueTransformer: NSSecureUnarchiveFromDataTransformer {
    
    static let name = NSValueTransformerName("ArrayValueTransformer")
    
    // Register the transformer
    public static func register() {
        let transformer = ArrayValueTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
    
    // Override allowedTopLevelClasses to specify what classes we can transform
    override public class var allowedTopLevelClasses: [AnyClass] {
        return [NSArray.self, NSString.self]
    }
}

class ValueTransformerRegistration {
    static func registerTransformers() {
        // Register the custom transformer
        ArrayValueTransformer.register()
    }
}
