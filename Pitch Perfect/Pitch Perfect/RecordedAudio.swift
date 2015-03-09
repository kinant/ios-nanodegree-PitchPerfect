//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Kinan Turjman on 3/9/15.
//  Copyright (c) 2015 Kinan Turjman. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    var filePathUrl: NSURL!
    var title: String!
    
    init(path: NSURL, title: String){
        self.filePathUrl = path;
        self.title = title;
    }
    
}
