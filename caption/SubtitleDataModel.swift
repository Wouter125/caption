//
//  SubtitleDataModel.swift
//  caption
//
//  Created by Wouter van de Kamp on 19/02/2017.
//  Copyright © 2017 Wouter van de Kamp. All rights reserved.
//

import Foundation
import Cocoa

public struct SubtitleDataModel {
    let IDSubtitleFile: String
    let LanguageName: String
    let MovieReleaseName: String
    let IDMovieImdb: String
    let SubLanguageID: String
    let ISO639: String
    
    public init(IDSubtitleFile: String, LanguageName: String, MovieReleaseName: String, IDMovieImdb: String, SubLanguageID: String, ISO639: String) {
        self.IDSubtitleFile = IDSubtitleFile
        self.LanguageName = LanguageName
        self.MovieReleaseName = MovieReleaseName
        self.IDMovieImdb = IDMovieImdb
        self.SubLanguageID = SubLanguageID
        self.ISO639 = ISO639
    }
}
