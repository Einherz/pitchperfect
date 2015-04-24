//
//  RecordedAudio.swift
//  pitchperfect
//
//  Created by Amorn Apichattanakul on 4/16/15.
//  Copyright (c) 2015 amorn. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    var filePathUrl: NSURL!
    var title: String!
    
    //Task 1////
    init(path: NSURL, title:String)
    {
        self.filePathUrl = path;
        self.title = title;
    }
}
