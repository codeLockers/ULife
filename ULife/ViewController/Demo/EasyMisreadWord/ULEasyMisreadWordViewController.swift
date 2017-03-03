//
//  ULEasyMisreadWordViewController.swift
//  ULife
//
//  Created by codeLocker on 2017/3/3.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import UIKit
import AVFoundation

class ULEasyMisreadWordViewController: ULBaseViewController {

    fileprivate let tableView : UITableView = UITableView()
    
    fileprivate let speechSynthesizer : AVSpeechSynthesizer = AVSpeechSynthesizer()
    
    fileprivate let misreadWords = ULMisreadWordModel.data
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUI()
        layout()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Load_UI
    private func loadUI() {
        navigationItem.title = "Misread"
        view.backgroundColor = UIColor.white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
    }
    
    fileprivate func readMisreadWord(of indexPath:IndexPath) {
    
        let misreadWord = misreadWords[indexPath.row]
        
        if speechSynthesizer.isSpeaking{
            speechSynthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
        }
        let utterance = AVSpeechUtterance.init(string: misreadWord.origin)
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate
        utterance.voice = AVSpeechSynthesisVoice.init(language: "en-US")
        
        speechSynthesizer.speak(utterance)
    }
    
    //MARK: - Layout
    private func layout() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

extension ULEasyMisreadWordViewController: UITableViewDelegate,UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return misreadWords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self))
        if cell == nil {
            cell = UITableViewCell.init(style: .value1, reuseIdentifier: String(describing: UITableViewCell.self))
        }
        
        cell!.textLabel?.text = misreadWords[indexPath.row].origin
        cell!.detailTextLabel?.text = "[\(misreadWords[indexPath.row].US)]"
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        readMisreadWord(of: indexPath)
    }
}
