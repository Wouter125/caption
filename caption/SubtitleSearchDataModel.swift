//
//  SubtitleSearchData.swift
//  caption
//
//  Created by Wouter van de Kamp on 30/03/2017.
//  Copyright © 2017 Wouter van de Kamp. All rights reserved.
//

import Cocoa
import Alamofire
import AlamofireXMLRPC

public struct SubtitleSearchDataModel {
    
    // MARK: - Properties
    public let IDSubMovieFile: String?
    public let MovieHash: String?
    public let MovieByteSize: String?
    public let MovieTimeMS: String?
    public let IDSubtitleFile: String?
    public let SubFileName: String?
    public let SubActualCD: String?
    public let SubSize: String?
    public let SubHash: String?
    public let IDSubtitle: String?
    public let UserID: String?
    public let SubLanguageID: String?
    public let SubFormat: String?
    public let SubSumCD: String?
    public let SubAuthorComment: String?
    public let SubAddDate: String?
    public let SubBad: String?
    public let SubRating: String?
    public let SubDownloadsCnt: String?
    public let MovieReleaseName: String?
    public let IDMovie: String?
    public let IDMovieImdb: String?
    public let MovieName: String?
    public let MovieNameEng: String?
    public let MovieYear: String?
    public let MovieImdbRating: String?
    public let UserNickName: String?
    public let ISO639: String?
    public let LanguageName: String?
    public let SubDownloadLink: String?
    public let ZipDownloadLink: String?
    
    // MARK: - Initializers
    public init?(subtitle: XMLRPCNode) {
        let IDSubMovieFile = subtitle["IDSubMovieFile"].string
        let MovieHash = subtitle["MovieHash"].string
        let MovieByteSize = subtitle["MovieByteSize"].string
        let MovieTimeMS = subtitle["MovieTimeMS"].string
        let IDSubtitleFile = subtitle["IDSubtitleFile"].string
        let SubFileName = subtitle["SubFileName"].string
        let SubActualCD = subtitle["SubActualCD"].string
        let SubSize = subtitle["SubSize"].string
        let SubHash = subtitle["SubHash"].string
        let IDSubtitle = subtitle["IDSubtitle"].string
        let UserID = subtitle["UserID"].string
        let SubLanguageID = subtitle["SubLanguageID"].string
        let SubFormat = subtitle["SubFormat"].string
        let SubSumCD = subtitle["SubSumCD"].string
        let SubAuthorComment = subtitle["SubAuthorComment"].string
        let SubAddDate = subtitle["SubAddDate"].string
        let SubBad = subtitle["SubBad"].string
        let SubRating = subtitle["SubRating"].string
        let SubDownloadsCnt = subtitle["SubDownloadsCnt"].string
        let MovieReleaseName = subtitle["MovieReleaseName"].string
        let IDMovie = subtitle["IDMovie"].string
        let IDMovieImdb = subtitle["IDMovieImdb"].string
        let MovieName = subtitle["MovieName"].string
        let MovieNameEng = subtitle["MovieNameEng"].string
        let MovieYear = subtitle["MovieYear"].string
        let MovieImdbRating = subtitle["MovieImdbRating"].string
        let UserNickName = subtitle["UserNickName"].string
        let ISO639 = subtitle["ISO639"].string
        let LanguageName = subtitle["LanguageName"].string
        let SubDownloadLink = subtitle["SubDownloadLink"].string
        let ZipDownloadLink = subtitle["ZipDownloadLink"].string
        
        
        self.IDSubMovieFile = IDSubMovieFile
        self.MovieHash = MovieHash
        self.MovieByteSize = MovieByteSize
        self.MovieTimeMS = MovieTimeMS
        self.IDSubtitleFile = IDSubtitleFile
        self.SubFileName = SubFileName
        self.SubActualCD = SubActualCD
        self.SubSize = SubSize
        self.SubHash = SubHash
        self.IDSubtitle = IDSubtitle
        self.UserID = UserID
        self.SubLanguageID = SubLanguageID
        self.SubFormat = SubFormat
        self.SubSumCD = SubSumCD
        self.SubAuthorComment = SubAuthorComment
        self.SubAddDate = SubAddDate
        self.SubBad = SubBad
        self.SubRating = SubRating
        self.SubDownloadsCnt = SubDownloadsCnt
        self.MovieReleaseName = MovieReleaseName
        self.IDMovie = IDMovie
        self.IDMovieImdb = IDMovieImdb
        self.MovieName = MovieName
        self.MovieNameEng = MovieNameEng
        self.MovieYear = MovieYear
        self.MovieImdbRating = MovieImdbRating
        self.UserNickName = UserNickName
        self.ISO639 = ISO639
        self.LanguageName = LanguageName
        self.SubDownloadLink = SubDownloadLink
        self.ZipDownloadLink = ZipDownloadLink
    }
}
