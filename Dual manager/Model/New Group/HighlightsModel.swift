//
//  HighlightsModel.swift
//  Dual
//
//  Created by Khoi Nguyen on 10/15/20.
//

import Foundation
import Firebase


class HighlightsModel {
    
    
    fileprivate var _category: String!
    fileprivate var _url: String!
    fileprivate var _status: String!
    fileprivate var _mode: String!
    fileprivate var _music: String!
    fileprivate var _Mux_processed: Bool!
    fileprivate var _Mux_playbackID: String!
    fileprivate var _Mux_assetID: String!
    fileprivate var _Allow_comment: Bool!
    fileprivate var _userUID: String!
    fileprivate var _highlight_title: String!
    fileprivate var _highlight_id: String!
    fileprivate var _post_time: Timestamp!
    fileprivate var _ratio: CGFloat!
    fileprivate var _hashtag_list: [String]!
    
    var _stream_link: String!

    var hashtag_list: [String]! {
        get {
            if _hashtag_list.isEmpty {
                return _hashtag_list
            }
            
            return _hashtag_list
        }
        
    }
    
    var ratio: CGFloat! {
        get {
            if _ratio == nil {
                _ratio = 0.0
            }
            return _ratio
        }
        
    }
    
    
    var Mux_assetID: String! {
        get {
            if _Mux_assetID == nil {
                _Mux_assetID = ""
            }
            return _Mux_assetID
        }
        
    }
    
    
    var highlight_id: String! {
        get {
            if _highlight_id == nil {
                _highlight_id = ""
            }
            return _highlight_id
        }
        
    }

    var category: String! {
        get {
            if _category == nil {
                _category = ""
            }
            return _category
        }
        
    }
    
    var url: String! {
        get {
            if _url == nil {
                _url = ""
            }
            return _url
        }
        
    }
    var status: String! {
        get {
            if _status == nil {
                _status = ""
            }
            return _status
        }
        
    }
    
    var mode: String! {
        get {
            if _mode == nil {
                _mode = ""
            }
            return _mode
        }
        
    }
    
    var music: String! {
        get {
            if _music == nil {
                _music = ""
            }
            return _music
        }
        
    }
    
    var Mux_playbackID: String! {
        get {
            if _Mux_playbackID == nil {
                _Mux_playbackID = ""
            }
            return _Mux_playbackID
        }
        
    }
    
    var userUID: String! {
        get {
            if _userUID == nil {
                _userUID = ""
            }
            return _userUID
        }
        
    }
    
    var highlight_title: String! {
        get {
            if _highlight_title == nil {
                _highlight_title = ""
            }
            return _highlight_title
        }
        
    }
    
    var stream_link: String! {
        get {
            if _stream_link == nil {
                _stream_link = ""
            }
            return _stream_link
        }
        
    }
    
    var Mux_processed: Bool! {
        get {
            if _Mux_processed == nil {
                _Mux_processed = false
            }
            return _Mux_processed
        }
        
    }
    
    var Allow_comment: Bool! {
        get {
            if _Allow_comment == nil {
                _Allow_comment = false
            }
            return _Allow_comment
        }
        
    }
    
    var post_time: Timestamp! {
        get {
            if _post_time == nil {
                _post_time = nil
            }
            return _post_time
        }
    }


    
    init(postKey: String, Highlight_model: Dictionary<String, Any>) {
        
        
        self._highlight_id = postKey
       

        if let ratio = Highlight_model["ratio"] as? CGFloat {
            self._ratio = ratio
        }
        
        if let Mux_assetID = Highlight_model["Mux_assetID"] as? String {
            self._Mux_assetID = Mux_assetID
        }
        
        
        if let url = Highlight_model["url"] as? String {
            self._url = url
        }
        
        if let category = Highlight_model["category"] as? String {
            self._category = category
        }
        
        if let status = Highlight_model["h_status"] as? String {
            self._status = status
        }
        
        if let mode = Highlight_model["mode"] as? String {
            self._mode = mode
        }
        
        if let music = Highlight_model["music"] as? String {
            self._music = music
        }
        
        if let Mux_playbackID = Highlight_model["Mux_playbackID"] as? String {
            self._Mux_playbackID = Mux_playbackID
        }
        
        if let userUID = Highlight_model["userUID"] as? String {
            self._userUID = userUID
        }
        
        if let highlight_title = Highlight_model["highlight_title"] as? String {
            self._highlight_title = highlight_title
        }
        
        if let stream_link = Highlight_model["stream_link"] as? String {
            self._stream_link = stream_link
        }
        
        if let Mux_processed = Highlight_model["Mux_processed"] as? Bool {
            self._Mux_processed = Mux_processed
        }
        
        if let Allow_comment = Highlight_model["Allow_comment"] as? Bool {
            self._Allow_comment = Allow_comment
        }
        
        if let post_time = Highlight_model["post_time"] as? Timestamp {
            self._post_time = post_time
            
        }
         
        if let hashtag_list = Highlight_model["hashtag_list"] as? [String] {
            
            var update_hashtag = hashtag_list
            
            if update_hashtag.count == 1 {
                update_hashtag.insert("#dual", at: 0)
            }
            
            self._hashtag_list = update_hashtag
        } else {
            self._hashtag_list = []
        }
        
        
        //hashtag_list
        
        
    }
    
}

extension HighlightsModel: Equatable {
    static func == (lhs: HighlightsModel, rhs: HighlightsModel) -> Bool {
        return lhs._highlight_id == rhs._highlight_id
    }
}
