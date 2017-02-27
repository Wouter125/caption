//
//  ViewController.swift
//  caption
//
//  Created by Wouter van de Kamp on 13/02/2017.
//  Copyright © 2017 Wouter van de Kamp. All rights reserved.
//

import Cocoa
import wpxmlrpc
import Gzip

class ViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate, NSTextFieldDelegate {
    @IBOutlet weak var searchField: NSTextField!
    @IBOutlet weak var subtitleTableView: NSTableView!
    @IBOutlet weak var loadingIndicator: NSProgressIndicator!
    @IBOutlet weak var eraseButton: NSButton!
    @IBOutlet weak var languagePopup: NSPopUpButton!
    private var searchData = [SubtitleDataModel]()
    private var selectedLanguage:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingIndicator.isHidden = true
        eraseButton.isHidden = true
        
        selectedLanguage = "eng"
        
        languagePopup.removeAllItems()
        languagePopup.addItems(withTitles: (LanguageList.languageDict.allKeys as! [String]).sorted())
        languagePopup.selectItem(withTitle: "English")
        osLogin()
        
        //Clean this up. Don't leave it in viewDidLoad. Prefer to move it to a subclass. Inside CustomSearchField
        searchField.wantsLayer = true
        let textFieldLayer = CALayer()
        searchField.layer = textFieldLayer
        searchField.backgroundColor = NSColor.white
        searchField.layer?.backgroundColor = CGColor.white
        searchField.layer?.borderColor = CGColor.white
        searchField.layer?.borderWidth = 0
        searchField.delegate = self
    }

    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    
    // MARK: - Textfield
    @IBAction func searchOpenSubtitles(_ sender: NSTextField) {
        let searchTerm = searchField.stringValue
        searchData.removeAll()
        subtitleTableView.reloadData()
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimation(NSTextField.self)
        osSearch(selectedLan: selectedLanguage, query: searchTerm)
    }
    
    override func controlTextDidChange(_ obj: Notification) {
        if searchField.stringValue != "" {
            eraseButton.isHidden = false
        } else {
            eraseButton.isHidden = true
        }
    }
    
    @IBAction func eraseText(_ sender: NSButton) {
        searchField.stringValue = ""
        eraseButton.isHidden = true
    }
    
    
    // MARK: - Dropdown List
    @IBAction func didSelectLanguage(_ sender: NSPopUpButton) {
        self.selectedLanguage = LanguageList.languageDict.object(forKey: languagePopup.titleOfSelectedItem! as String)! as! String
    }
    
    
    // MARK: - Tableview
    func numberOfRows(in tableView: NSTableView) -> Int {
        return searchData.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cellView = tableView.make(withIdentifier: "cell", owner: self) as! NSTableCellView
        cellView.textField?.stringValue = searchData[row].MovieReleaseName
        return cellView
    }
    
    func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
        return CustomTableViewRow()
    }
    
    @IBAction func rowClicked(_ sender: NSTableView) {
        if searchData.count != 0 {
            let selectedRow = subtitleTableView.selectedRow
            let downloadID = searchData[selectedRow].IDSubtitleFile
            let movieName = searchData[selectedRow].MovieReleaseName
            downloadSubtitle(subtitleID: downloadID, movieName: movieName)
        }
    }
    
    
    
    // MARK: - Subtitle Saving
    func saveSubtitle(subtitle: Data, filename: String) {
        let fileContentToWrite = subtitle
        
        let FS = NSSavePanel()
        FS.canCreateDirectories = true
        FS.nameFieldStringValue = filename
        FS.title = "Save Subtitle"
        FS.allowedFileTypes = ["srt"]
        
        FS.begin { result in
            if result == NSFileHandlingPanelOKButton {
                guard let url = FS.url else { return }
                do {
                    try fileContentToWrite.write(to: url)
                } catch {
                    print (error.localizedDescription)
                }
            }
        }
    }
    

    
    /* 
    * Login to OpenSubtitles and obtain a token
    */
    
    private func osLogin() {
        print("hallo")
        let params = ["", "", "en", OpenSubtitleConfiguration.userAgent] as [Any]
        
        let loginManager = OpenSubtitleDataManager(
            secureBaseURL: OpenSubtitleConfiguration.secureBaseURL!,
            osMethod: "LogIn",
            parameters: params)
        
        loginManager.osData { (response, error) in
            if let loginDictionary = response as? [String: AnyObject] {
                OpenSubtitleConfiguration.token = loginDictionary["token"] as? String
            }
        }
    }
    
    
    /*
    * Log out of OpenSubtitles
    */
    private func osLogout() {
        let params = [OpenSubtitleConfiguration.token!] as [Any]
        
        let loginManager = OpenSubtitleDataManager(
            secureBaseURL: OpenSubtitleConfiguration.secureBaseURL!,
            osMethod: "LogOut",
            parameters: params)
        
        loginManager.osData { (response, error) in
            if let logoutDictionary = response as? [String: AnyObject] {
                let status = logoutDictionary["status"] as? String
                let filteredStatus = status?.components(separatedBy: NSCharacterSet(charactersIn: "0123456789").inverted).joined(separator: "")
                
                if filteredStatus == "200" || filteredStatus == "206" {
                    print("succesful logout")
                } else {
                    print("error")
                }
            }
        }
    }
    
    
    /*
     * Verify Token session. If token expired, request a new one
     */
    private func tokenValidation() {
        let params = [OpenSubtitleConfiguration.token!]
        
        let tokenManager = OpenSubtitleDataManager(
            secureBaseURL: OpenSubtitleConfiguration.secureBaseURL!,
            osMethod: "NoOperation",
            parameters: params)
        
        tokenManager.osData{ (response, error) in
            if let tokenDictionary = response as? [String: AnyObject] {
                let status = tokenDictionary["status"] as? String
                let filteredStatus = status?.components(separatedBy: NSCharacterSet(charactersIn: "0123456789").inverted).joined(separator: "")
                
                //TODO: Make this into a switch statement for better error handling.
                if filteredStatus == "406" {
                    self.osLogin()
                } else if filteredStatus == "200" || filteredStatus == "206" {
                    
                } else {
                    print("error")
                }
            }
        }
    }
    
    
    
    /*
    * Search OpenSubtitles based on textfield input
    */
    private func osSearch(selectedLan: String!, query: String?) {
        osLogin()
        self.searchData = [SubtitleDataModel]()
        let params = [OpenSubtitleConfiguration.token!, [["sublanguageid": selectedLan, "query": query]]] as [Any]
        
        let searchManager = OpenSubtitleDataManager(
            secureBaseURL: OpenSubtitleConfiguration.secureBaseURL!,
            osMethod: "SearchSubtitles",
            parameters: params)
        
        searchManager.osData{ (response, error) in
            DispatchQueue.main.async {
                self.loadingIndicator.isHidden = true
                self.loadingIndicator.stopAnimation(response)
            }
            if let searchDictionary = response as? [String: AnyObject] {
                if let searchResults = searchDictionary["data"] as? [[String: AnyObject]] {
                    for results in searchResults {
                        let searchModel = SubtitleDataModel(IDSubtitleFile: results["IDSubtitleFile"]! as! String, LanguageName: results["LanguageName"]! as! String, MovieReleaseName: results["MovieReleaseName"]! as! String, IDMovieImdb: results["IDMovieImdb"]! as! String, SubLanguageID: results["SubLanguageID"]! as! String, ISO639: results["ISO639"]! as! String)
                        self.searchData.append(searchModel)
                        DispatchQueue.main.async {
                            self.subtitleTableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    
    /*
    * Download OpenSubtitle
    */
    private func downloadSubtitle(subtitleID: String, movieName: String) {
        print("let's download")
        let params = [OpenSubtitleConfiguration.token!, [subtitleID]] as [Any]
        
        let downloadManager = OpenSubtitleDataManager(
            secureBaseURL: OpenSubtitleConfiguration.secureBaseURL!,
            osMethod: "DownloadSubtitles",
            parameters: params)
        
        downloadManager.osData{ (response, error) in
            if let downloadDictionary = response as? [String: AnyObject] {
                if let downloadResults = downloadDictionary["data"] as? [[String: AnyObject]] {
                    for downloads in downloadResults {
                        let base64Str = downloads["data"] as! String
                        let decodedData = Data(base64Encoded: base64Str)!
                        let decompressedData: Data
                        if decodedData.isGzipped {
                            decompressedData = try! decodedData.gunzipped()
                            DispatchQueue.main.async {
                                self.saveSubtitle(subtitle: decompressedData, filename: movieName)
                            }
                        } else {
                            decompressedData = decodedData
                            print("not decompressed")
                        }
                    }
                }
            }
        }
    }
    
}

