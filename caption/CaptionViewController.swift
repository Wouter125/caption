//
//  ViewController.swift
//  caption
//
//  Created by Wouter van de Kamp on 25/03/2017.
//  Copyright © 2017 Wouter van de Kamp. All rights reserved.
//

import Cocoa
import Gzip

class CaptionViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate, NSTextFieldDelegate, DragDropDelegate {
    @IBOutlet weak var subtitleTableView: NSTableView!
    @IBOutlet weak var searchField: NSTextField!
    @IBOutlet weak var languagePopUp: NSPopUpButton!
    @IBOutlet weak var searchLoadingIndicator: NSProgressIndicator!
    @IBOutlet weak var searchEraseButton: NSButton!
    @IBOutlet weak var dragdropPlaceholder: DragDropView!
    
    private var selectedLanguage:String!
    private var searchData = [SubtitleSearchDataModel]()
    typealias FinishedLogIn = () -> ()
    
    override func viewDidLoad() {
        self.searchLoadingIndicator.isHidden = true
        self.searchEraseButton.isHidden = true
        
        searchField.delegate = self
        dragdropPlaceholder.delegate = self
        
        checkMovieHash()
        
        makeFirstResponder()
        initNSPopUpButton()
        
        super.viewDidLoad()
    }
    
    // MARK: - Reload TableView
    func reloadTableView() {
        self.searchData = [SubtitleSearchDataModel]()
        DispatchQueue.main.async {
            self.subtitleTableView.reloadData()
        }
    }
    
    // MARK: - TextField
    @IBAction func searchSubtitles(_ sender: NSTextField) {
        let searchTerm = searchField.stringValue
        searchData.removeAll()
        subtitleTableView.reloadData()
        searchLoadingIndicator.isHidden = false
        searchLoadingIndicator.startAnimation(NSTextField.self)
        osSearch(selectedLan: selectedLanguage, query: searchTerm, movieHash: nil)
    }
    
    override func controlTextDidChange(_ obj: Notification) {
        if searchField.stringValue != "" {
            searchEraseButton.isHidden = false
            dragdropPlaceholder.isHidden = true
        } else {
            reloadTableView()
            searchEraseButton.isHidden = true
            dragdropPlaceholder.isHidden = false
        }
    }
    
    @IBAction func didClickErase(_ sender: NSButton) {
        reloadTableView()
        searchField.stringValue = ""
        searchEraseButton.isHidden = true
        dragdropPlaceholder.isHidden = false
    }
    
    func makeFirstResponder() {
        searchField.becomeFirstResponder()
    }
    
    // MARK: - Dropdown List
    private func initNSPopUpButton() {
        selectedLanguage = "eng"
        languagePopUp.removeAllItems()
        languagePopUp.addItems(withTitles: (LanguageList.languageDict.allKeys as! [String]).sorted())
        languagePopUp.selectItem(withTitle: "English")
    }
    
    @IBAction func didSelectLanguage(_ sender: NSPopUpButton) {
        self.selectedLanguage = LanguageList.languageDict.object(forKey: languagePopUp.titleOfSelectedItem! as String)! as! String
        osSearch(selectedLan: selectedLanguage, query: searchField.stringValue, movieHash: nil)
    }
    
    
    // MARK: - Tableview
    func numberOfRows(in tableView: NSTableView) -> Int {
        return searchData.count
    }
    
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cellView = tableView.make(withIdentifier: "cell", owner: self) as! NSTableCellView
        if searchData[row].MovieReleaseName != nil {
            cellView.textField?.stringValue = searchData[row].MovieReleaseName!
        } else {
            cellView.textField?.stringValue = "Title is missing"
        }
        return cellView
    }
    
    func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
        return SubtitleTableViewRow()
    }
    
    
    @IBAction func didSelectRow(_ sender: NSTableView) {
        if searchData.count != 0 {
            let selectedRow = subtitleTableView.selectedRow
            let subtitleID = searchData[selectedRow].IDSubtitleFile
            let movieName = searchData[selectedRow].MovieReleaseName
            osDownload(subtitleID: subtitleID!, movieName: movieName!)
        }
    }
    
    
    
    // MARK: - OpenSubtitles Handlers
    func osLogin(completed: @escaping FinishedLogIn) {
        let params = ["", "", "en", OpenSubtitleConfiguration.userAgent] as [Any]
        
        let loginManager = OpenSubtitleDataManager(
            secureBaseURL: OpenSubtitleConfiguration.secureBaseURL!,
            osMethod: "LogIn",
            parameters: params)
        
        loginManager.fetchOpenSubtitleData { (response) in
            OpenSubtitleConfiguration.token = response[0]["token"].string!
            completed()
        }
    }
    
    
    func osSearch(selectedLan: String!, query: String?, movieHash: String?) {
        osLogin { () -> () in
            self.searchData = [SubtitleSearchDataModel]()
            var params = [Any]()
            
            if movieHash != nil {
                params = [OpenSubtitleConfiguration.token!, [["sublanguageid": selectedLan!, "moviehash": movieHash!]]] as [Any]
            } else {
                params = [OpenSubtitleConfiguration.token!, [["sublanguageid": selectedLan!, "query": query!]]] as [Any]
            }
            
            let searchManager = OpenSubtitleDataManager(
                secureBaseURL: OpenSubtitleConfiguration.secureBaseURL!,
                osMethod: "SearchSubtitles",
                parameters: params)
            
            searchManager.fetchOpenSubtitleData { (response) in
                let data = response[0]["data"].array
                if data == nil {
                    print("No Results")
                    
                    DispatchQueue.main.async {
                        self.searchLoadingIndicator.isHidden = true
                        self.searchLoadingIndicator.stopAnimation(response)
                    }
                    
                } else {
                    for subtitle in data! {
                        let subtitleData = SubtitleSearchDataModel(subtitle: subtitle)
                        self.searchData.append(subtitleData!)
                    }
                    
                    DispatchQueue.main.async {
                        self.searchLoadingIndicator.isHidden = true
                        self.searchLoadingIndicator.stopAnimation(response)
                        self.subtitleTableView.reloadData()
                    }
                }
            }
        }
    }
    
    func checkMovieHash() {
        osLogin { () -> () in
            let params = [OpenSubtitleConfiguration.token!, ["ca8f3c95403dd70f"]] as [Any]
            
            let checkMovieHashManager = OpenSubtitleDataManager(
                secureBaseURL: OpenSubtitleConfiguration.secureBaseURL!,
                osMethod: "CheckMovieHash",
                parameters: params)
            
            checkMovieHashManager.fetchOpenSubtitleData(completion: { (response) in
                //When checking hash we can use the following structure to receive the details.
                //let _ = response[0]["data"]["ca8f3c95403dd70f"]["MovieName"].string
            })
        }
        
    }
    
    func osDownload(subtitleID: String, movieName: String) {
        osLogin { () -> () in
            let params = [OpenSubtitleConfiguration.token!, [subtitleID]] as [Any]
            
            let downloadManager = OpenSubtitleDataManager(
                secureBaseURL: OpenSubtitleConfiguration.secureBaseURL!,
                osMethod: "DownloadSubtitles",
                parameters: params)
            
            downloadManager.fetchOpenSubtitleData(completion: { (response) in
                let data = response[0]["data"].array
                if data == nil {
                    print("Download Unavailable")
                } else {
                    for download in data! {
                        let base64Str = download["data"].string!
                        let decodedData = Data(base64Encoded: base64Str)!
                        let decompressedData: Data
                        if decodedData.isGzipped {
                            decompressedData = try! decodedData.gunzipped()
                            DispatchQueue.main.async {
                                self.saveSubtitle(subtitle: decompressedData, filename: movieName)
                            }
                        } else {
                            decompressedData = decodedData
                        }
                    }
                }
            })
        }
    }
    
    func saveSubtitle(subtitle: Data, filename: String) {
        let fileContentToWrite = subtitle
        
        let FS = NSSavePanel()
        FS.canCreateDirectories = true
        FS.nameFieldStringValue = filename
        FS.title = "Save Subtitle"
        FS.allowedFileTypes = ["srt"]
        
        
        FS.beginSheetModal(for: self.view.window!, completionHandler: { result in
            if result == NSFileHandlingPanelOKButton {
                guard let url = FS.url else { return }
                do {
                    try fileContentToWrite.write(to: url)
                } catch {
                    print (error.localizedDescription)
                }
            }
            
        })
    }
    
    //MARK: - DragDrop Delegate
    
    func droppingDidComplete(hash: String) {
        searchData.removeAll()
        subtitleTableView.reloadData()
        dragdropPlaceholder.isHidden = true
        searchLoadingIndicator.isHidden = false
        searchLoadingIndicator.startAnimation(NSTextField.self)
        
        osSearch(selectedLan: selectedLanguage, query: nil, movieHash: hash)
    }
}

