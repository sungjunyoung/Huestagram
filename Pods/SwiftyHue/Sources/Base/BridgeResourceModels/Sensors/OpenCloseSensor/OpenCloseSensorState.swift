//
//  OpenCloseSensorState.swift
//  Pods
//
//  Created by Jerome Schmitz on 01.05.16.
//
//

import Foundation
import Gloss

public class OpenCloseSensorState: SensorState {

    public let open: Bool
    
    required public init?(json: JSON) {
        
        guard let open: Bool = "open" <~~ json else {
            Log.error("Can't create OpenCloseSensorState, missing required attribute \"open\" in JSON:\n \(json)"); return nil
        }
        
        self.open = open
        
        super.init(json: json)
    }
    
    public override func toJSON() -> JSON? {
        
        if var superJson = super.toJSON() {
            let json = jsonify([
                "open" ~~> self.open
                ])
            superJson.unionInPlace(json!)
            return superJson
        }
        
        return nil
    }
}

public func ==(lhs: OpenCloseSensorState, rhs: OpenCloseSensorState) -> Bool {
    return lhs.lastUpdated == rhs.lastUpdated &&
        lhs.open == rhs.open
}