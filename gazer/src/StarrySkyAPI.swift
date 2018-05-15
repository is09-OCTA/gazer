//
//  StarrySkyAPI.swift
//  gazer
//
//  Created by Keisuke Kitamura on 2018/05/05.
//  Copyright © 2018年 OCTA. All rights reserved.
//

import Foundation

class Star: NSObject, XMLParserDelegate {
    
    //XMLのフィード取得用URL
    let feedUrl : NSURL = NSURL(string:"http://www.walk-in-starrysky.com/star.do?cmd=detail&hrNo=6134")!
    
    //XMLの現在要素名を入れる変数
    var currentElementName : String!
    
    //取得する要素名(とりはじめの要素)
    let starElementName : String  = "star"
    
    //取得する要素名の決定(star要素の下にあるもの)
    let jpNameElementName  : String = "jpName"                                  // 日本語名
    let distanceElementName : String = "distance"                               // 距離
    let rightAscensionElementName  : String = "rightAscension"                  // 赤経
    let celestialDeclinationNameElementName  : String = "celestialDeclination"  // 赤緯
    
    //各エレメント用の変数
    var posts:[Dictionary<String, String>]!
    var elements:Dictionary = [String: String]()
    var element:String!
    
    var jpName:String!
    var distance:String!
    var rightAscension:String!
    var celestialDeclination:String!
    
    
}
