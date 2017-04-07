//
//  ULMisreadWordModel.swift
//  ULife
//
//  Created by codeLocker on 2017/3/3.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import Foundation

struct ULMisreadWordModel {
    
    let UK : String
    let US : String
    let origin : String
    
    init(_ origin: String, US: String, UK: String) {
        self.origin = origin
        self.US = US
        self.UK = UK
    }
}

extension ULMisreadWordModel {

    static let data : [ULMisreadWordModel] = [
        ULMisreadWordModel("access", US: "'ækses", UK: ""),
        ULMisreadWordModel("Angular", US: "'æŋgjʊlə", UK: ""),
        ULMisreadWordModel("AJAX", US: "'eidʒæks", UK: ""),
        ULMisreadWordModel("Apache", US: "ə'pætʃɪ", UK: ""),
        ULMisreadWordModel("archive", US: "'ɑːkaɪv", UK: ""),
        ULMisreadWordModel("array", US: "ə'rei", UK: ""),
        ULMisreadWordModel("avatar", US: "'ævətɑː", UK: ""),
        ULMisreadWordModel("Azure", US: "'æʒə", UK: ""),
        ULMisreadWordModel("cache", US: "kæʃ", UK: ""),
        ULMisreadWordModel("deque", US: "'dek", UK: ""),
        ULMisreadWordModel("digest", US: "'dɑɪdʒɛst", UK: ""),
        ULMisreadWordModel("Django", US: "ˈdʒæŋɡoʊ", UK: ""),
        ULMisreadWordModel("Git", US: "ɡɪt", UK: ""),
        ULMisreadWordModel("height", US: "haɪt", UK: ""),
        ULMisreadWordModel("hidden", US: "'hɪdn", UK: ""),
        ULMisreadWordModel("image", US: "'ɪmɪdʒ", UK: ""),
        ULMisreadWordModel("integer", US: "'ɪntɪdʒə", UK: ""),
        ULMisreadWordModel("issue", US: "'ɪʃuː", UK: ""),
        ULMisreadWordModel("Java", US: "'dʒɑːvə", UK: ""),
        ULMisreadWordModel("Linux", US: "'lɪnəks", UK: ""),
        ULMisreadWordModel("main", US: "meɪn", UK: ""),
        ULMisreadWordModel("margin", US: "'mɑːdʒɪn", UK: ""),
        ULMisreadWordModel("maven", US: "'meɪvn", UK: ""),
        ULMisreadWordModel("module", US: "'mɒdjuːl", UK: ""),
        ULMisreadWordModel("null", US: "nʌl", UK: ""),
        ULMisreadWordModel("parameter", US: "pə'ræmɪtə", UK: ""),
        ULMisreadWordModel("putty", US: "ˈpʌti", UK: ""),
        ULMisreadWordModel("query", US: "'kwɪəri", UK: ""),
        ULMisreadWordModel("resolved", US: "rɪ'zɒlvd", UK: ""),
        ULMisreadWordModel("retina", US: "'retɪnə", UK: ""),
        ULMisreadWordModel("san jose", US: "sænhəu'zei", UK: ""),
        ULMisreadWordModel("safari", US: "sə'fɑːrɪ", UK: ""),
        ULMisreadWordModel("scheme", US: "skiːm", UK: ""),
        ULMisreadWordModel("suite", US: "swiːt", UK: ""),
        ULMisreadWordModel("typical", US: "'tɪpɪkl", UK: ""),
        ULMisreadWordModel("Ubuntu", US: "ʊ'bʊntʊ", UK: ""),
        ULMisreadWordModel("variable", US: "'veəriəbl", UK: ""),
        ULMisreadWordModel("vue", US: "v'ju:", UK: ""),
        ULMisreadWordModel("width", US: "wɪdθ", UK: ""),
        ULMisreadWordModel("YouTube", US: "'juː'tjuːb", UK: "")
    
    ]
}
