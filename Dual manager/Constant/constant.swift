//
//  Constant.swift
//  Dual
//
//  Created by Khoi Nguyen on 10/4/20.
//

import Foundation
import Cache
import UIKit
import CoreLocation
import SwiftEntryKit
import Alamofire
import SendBirdCalls
import Firebase
import SendBirdSDK
import SendBirdUIKit
import AlgoliaSearchClient
import SendBirdSDK

var selected_channelUrl: String?
var hideChannelToadd: SBDGroupChannel?
var actionMade = false

var profileDelegateListen: ListenerRegistration!

//


var pendingvideoListen: ListenerRegistration!

var discord_domain = ["discordapp.com", "discord.com", "discord.co", "discord.gg", "watchanimeattheoffice.com", "dis.gd", "discord.media", "discordapp.net", "discordstatus.com" ]

let btnSpeakerSelected = UIImage(named: "3xunmute")?.resize(targetSize: CGSize(width: 35, height: 35))
let btnSpeaker = UIImage(named: "3xmute")?.resize(targetSize: CGSize(width: 35, height: 35))
let xBtn = UIImage(named: "1024x")?.resize(targetSize: CGSize(width: 12, height: 12))


func findDataInList(item: ReportModel, list: [ReportModel]) -> Bool {
    
    for i in list {
        
        if i.reportID == item.reportID{
            
            return true
            
        }
                  
    }
    
    return false
    
}

func findIndexInList(item: ReportModel, list: [ReportModel]) -> Int {
    
    var count = 0
    for i in list {
        
        if i.reportID == item.reportID {
            
            return count
            
        }
        
        count += 1
                  
    }
    
    return -1
    
}

func removeAllListen() {
    
    if pendingvideoListen != nil {
        pendingvideoListen.remove()
    }

    
    if profileDelegateListen != nil {
        profileDelegateListen.remove()
    }
    
}

var isHighlightNoti = false
var isChallengeNoti = false
var isCommentNoti = false
var isFollowNoti = false
var isMessageNoti = false
var isCallNoti = false
var isMentionNoti = false
var isSound = false
var isSocial = false
var isChallenge = false
var isDiscord = false
var refId = ""
var sessionId = ""

var general_call: DirectCall!
var general_room: Room!
var gereral_group_chanel_url: String!

var sendbird_applicationID = "F1A6D993-4873-45E9-A88E-38B239234441"
let googleMap_Key = "AIzaSyAAYuBDXTubo_qcayPX6og_MrWq9-iM_KE"
let googlePlace_key = "AIzaSyAAYuBDXTubo_qcayPX6og_MrWq9-iM_KE"
var recommendationId = ""
var impression = [String]()
var global_block_list = [String]()
var global_following_list = [String]()
var global_care_list = [String]()
var global_availableChatList = [String]()
let algolia_appID = "5B48T9UH41"
let algolia_key = "d1bec7be010afb97f09149a51ed315df"
let algoliaSearchClient: SearchClient = SearchClient(appID: ApplicationID(rawValue: algolia_appID), apiKey: APIKey(rawValue: algolia_key))
var global_avatar_url = ""
var global_username = ""

//


//


var global_percentComplete:Double = 0.000

typealias DownloadComplete = () -> ()
let selectedColor = UIColor(red: 248/255, green: 189/255, blue: 91/255, alpha: 1.0)
let movedColor = UIColor(red: 247/255, green: 88/255, blue: 28/255, alpha: 1.0)

extension String: ParameterEncoding {

    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }

}


let diskConfig = DiskConfig(
  // The name of disk storage, this will be used as folder name within directory
  name: "Floppy",
  // Expiry date that will be applied by default for every added object
  // if it's not overridden in the `setObject(forKey:expiry:)` method
  expiry: .date(Date().addingTimeInterval(2*3600)),
  // Maximum size of the disk cache storage (in bytes)
  maxSize: 10000,
  // Where to store the disk cache. If nil, it is placed in `cachesDirectory` directory.
  directory: try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask,
    appropriateFor: nil, create: true).appendingPathComponent("MyPreferences"),
  // Data protection is used to store files in an encrypted format on disk and to decrypt them on demand
  protectionType: .complete
)

let memoryConfig = MemoryConfig(
  // Expiry date that will be applied by default for every added object
  // if it's not overridden in the `setObject(forKey:expiry:)` method
  expiry: .date(Date().addingTimeInterval(2*60)),
  /// The maximum number of objects in memory the cache should hold
  countLimit: 50,
  /// The maximum total cost that the cache can hold before it starts evicting objects
  totalCostLimit: 0
)


let disksConfig = DiskConfig(name: "Mix")

let dataStorage = try! Storage(
  diskConfig: disksConfig,
  memoryConfig: MemoryConfig(),
  transformer: TransformerFactory.forData()
)
let imageStorage = dataStorage.transformImage()


func timeAgoSinceDate(_ date:Date, numericDates:Bool) -> String {
    let calendar = Calendar.current
    let now = Date()
    let earliest = (now as NSDate).earlierDate(date)
    let latest = (earliest == now) ? date : now
    let components:DateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.minute , NSCalendar.Unit.hour , NSCalendar.Unit.day , NSCalendar.Unit.weekOfYear , NSCalendar.Unit.month , NSCalendar.Unit.year , NSCalendar.Unit.second], from: earliest, to: latest, options: NSCalendar.Options())
    
    if (components.year! >= 2) {
        return "\(String(describing: components.year)) years"
    } else if (components.year! >= 1){
        if (numericDates){
            return "1 year"
        } else {
            return "Last year"
        }
    } else if (components.month! >= 2) {
        return "\(components.month!) months"
    } else if (components.month! >= 1){
        if (numericDates){
            return "1 month"
        } else {
            return "Last month"
        }
    } else if (components.weekOfYear! >= 2) {
        return "\(components.weekOfYear!) weeks"
    } else if (components.weekOfYear! >= 1){
        if (numericDates){
            return "1 week"
        } else {
            return "Last week"
        }
    } else if (components.day! >= 2) {
        return "\(components.day!) days"
    } else if (components.day! >= 1){
        if (numericDates){
            return "1 day"
        } else {
            return "Yesterday"
        }
    } else if (components.hour! >= 2) {
        return "\(components.hour!) hours"
    } else if (components.hour! >= 1){
        if (numericDates){
            return "1 hour"
        } else {
            return "An hour"
        }
    } else if (components.minute! >= 2) {
        return "\(components.minute!) mins"
    } else if (components.minute! >= 1){
        if (numericDates){
            return "1 min"
        } else {
            return "A min"
        }
    } else if (components.second! >= 3) {
        return "\(components.second!)s"
    } else {
        return "Just now"
    }
    
}

func timeForChat(_ date:Date, numericDates:Bool) -> String {
    let calendar = Calendar.current
    let now = Date()
    let earliest = (now as NSDate).earlierDate(date)
    let latest = (earliest == now) ? date : now
    let components:DateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.minute , NSCalendar.Unit.hour , NSCalendar.Unit.day , NSCalendar.Unit.weekOfYear , NSCalendar.Unit.month , NSCalendar.Unit.year , NSCalendar.Unit.second], from: earliest, to: latest, options: NSCalendar.Options())
    
    let lastMessageDateFormatter = DateFormatter()
    lastMessageDateFormatter.dateStyle = .short
    lastMessageDateFormatter.timeStyle = .none
    
    if (components.year! >= 2) {
        return "\(String(describing: components.year)) years"
    } else if (components.year! >= 1){
        if (numericDates){
            return lastMessageDateFormatter.string(from: date)
        } else {
            return "Last year"
        }
    } else if (components.month! >= 2) {
        return "\(components.month!) months"
    } else if (components.month! >= 1){
        if (numericDates){
            return lastMessageDateFormatter.string(from: date)
        } else {
            return "Last month"
        }
    } else if (components.weekOfYear! >= 2) {
        return "\(components.weekOfYear!) weeks"
    } else if (components.weekOfYear! >= 1){
        if (numericDates){
            return lastMessageDateFormatter.string(from: date)
        } else {
            return "Last week"
        }
    } else if (components.day! >= 2) {
        return "\(components.day!) days"
    } else if (components.day! >= 1){
        if (numericDates){
            return "1 day"
        } else {
            return "Yesterday"
        }
    } else if (components.hour! >= 2) {
        return "\(components.hour!) hours"
    } else if (components.hour! >= 1){
        if (numericDates){
            return "1 hour"
        } else {
            return "An hour"
        }
    } else if (components.minute! >= 2) {
        return "\(components.minute!) mins"
    } else if (components.minute! >= 1){
        if (numericDates){
            return "1 min"
        } else {
            return "A min"
        }
    } else if (components.second! >= 3) {
        return "\(components.second!)s"
    } else {
        return "Just now"
    }
    
}

func delay(_ seconds: Double, completion:@escaping ()->()) {
    let popTime = DispatchTime.now() + Double(Int64( Double(NSEC_PER_SEC) * seconds )) / Double(NSEC_PER_SEC)
    DispatchQueue.main.asyncAfter(deadline: popTime) {
        completion()
    }
}

func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
    return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
}


extension Double {
    func roundTo(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}


extension DispatchQueue {
    
    static func background(delay: Double = 0.0, background: (()->Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
    }
    
}
extension StringProtocol {
    var firstUppercased: String {
        guard let first = first else { return "" }
        return String(first).uppercased() + dropFirst()
    }
}

extension Array where Element: Comparable {
    func containsSameElements(as other: [Element]) -> Bool {
        return self.count == other.count && self.sorted() == other.sorted()
    }
}
extension Date {
    func addedBy(minutes:Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
    }
}


func applyShadowOnView(_ view:UIView) {

    view.layer.cornerRadius = 8
    view.layer.shadowColor = UIColor.lightGray.cgColor
    view.layer.shadowOpacity = 1
    view.layer.shadowOffset = CGSize.zero
    view.layer.shadowRadius = 3

}

private var kAssociationKeyMaxLength: Int = 0


extension UITextField {
    
    @IBInspectable var maxLength: Int {
        get {
            if let length = objc_getAssociatedObject(self, &kAssociationKeyMaxLength) as? Int {
                return length
            } else {
                return Int.max
            }
        }
        set {
            objc_setAssociatedObject(self, &kAssociationKeyMaxLength, newValue, .OBJC_ASSOCIATION_RETAIN)
            addTarget(self, action: #selector(checkMaxLength), for: .editingChanged)
        }
    }
    
    @objc func checkMaxLength(textField: UITextField) {
        guard let prospectiveText = self.text,
            prospectiveText.count > maxLength
            else {
                return
        }
        
        let selection = selectedTextRange
        
        let indexEndOfText = prospectiveText.index(prospectiveText.startIndex, offsetBy: maxLength)
        let substring = prospectiveText[..<indexEndOfText]
        text = String(substring)
        
        selectedTextRange = selection
    }
}



var pixel_key = "ZFZ7ImsiOiJve3NvYDZKJFY7SjlON01dMWJBIiwidiI6ImY4RkRqIiwiaSI6IjUzIn1yTWZ1"
var env_key = "v9s48ds44jmrgnqgmp666jcpe"
var applicationKey = "2c3ccae1-c080-467b-b989-d1d70aaf159c"
var twApiKey = "4ob6dNOQJPIjz9DQtCiLcD8VY"
var twSecretKey = "mGTOy20I2fhrvvkGsNIRJwKKY7TCywJbrjuaEJexzVrfKeJyqQ"
var should_Play = false
var login_type = ""

extension UIView
{
    func fixInView(_ container: UIView!) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}

extension UITextField{
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}


extension UIView {

    @IBInspectable var shadow: Bool {
        get {
            return layer.shadowOpacity > 0.0
        }
        set {
            if newValue == true {
                self.addShadow()
            }
        }
    }

    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue

            // Don't touch the masksToBound property if a shadow is needed in addition to the cornerRadius
            if shadow == false {
                self.layer.masksToBounds = true
            }
        }
    }


    func addShadow(shadowColor: CGColor = UIColor.orange.cgColor,
               shadowOffset: CGSize = CGSize(width: 3.0, height: 4.0),
               shadowOpacity: Float = 0.7,
               shadowRadius: CGFloat = 4.5) {
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
    }
}

extension UIView {
    func addBottomBorderWithColor(color: UIColor, height: CGFloat) -> CALayer {
            
            let border = CALayer()
            border.backgroundColor = color.cgColor
            border.frame = CGRect(x: 0, y: self.frame.size.height - height,
                                  width: self.frame.size.width, height: height)
            
            
            return border
            
        }

}

extension Dictionary {
    mutating func merge(dict: [Key: Value]){
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
}


public enum Model : String {

    case simulator     = "simulator",

    iPod1              = "iPod 1",
    iPod2              = "iPod 2",
    iPod3              = "iPod 3",
    iPod4              = "iPod 4",
    iPod5              = "iPod 5",

    iPad2              = "iPad 2",
    iPad3              = "iPad 3",
    iPad4              = "iPad 4",
    iPadAir            = "iPad Air ",
    iPadAir2           = "iPad Air 2",
    iPadAir3           = "iPad Air 3",
    iPad5              = "iPad 5",
    iPad6              = "iPad 6",
    iPad7              = "iPad 7",

    iPadMini           = "iPad Mini",
    iPadMini2          = "iPad Mini 2",
    iPadMini3          = "iPad Mini 3",
    iPadMini4          = "iPad Mini 4",
    iPadMini5          = "iPad Mini 5",

    iPadPro9_7         = "iPad Pro 9.7\"",
    iPadPro10_5        = "iPad Pro 10.5\"",
    iPadPro11          = "iPad Pro 11\"",
    iPadPro12_9        = "iPad Pro 12.9\"",
    iPadPro2_12_9      = "iPad Pro 2 12.9\"",
    iPadPro3_12_9      = "iPad Pro 3 12.9\"",

    iPhone4            = "iPhone 4",
    iPhone4S           = "iPhone 4S",
    iPhone5            = "iPhone 5",
    iPhone5S           = "iPhone 5S",
    iPhone5C           = "iPhone 5C",
    iPhone6            = "iPhone 6",
    iPhone6Plus        = "iPhone 6 Plus",
    iPhone6S           = "iPhone 6S",
    iPhone6SPlus       = "iPhone 6S Plus",
    iPhoneSE           = "iPhone SE",
    iPhone7            = "iPhone 7",
    iPhone7Plus        = "iPhone 7 Plus",
    iPhone8            = "iPhone 8",
    iPhone8Plus        = "iPhone 8 Plus",
    iPhoneX            = "iPhone X",
    iPhoneXS           = "iPhone XS",
    iPhoneXSMax        = "iPhone XS Max",
    iPhoneXR           = "iPhone XR",
    iPhone11           = "iPhone 11",
    iPhone11Pro        = "iPhone 11 Pro",
    iPhone11ProMax     = "iPhone 11 Pro Max",
    iPhoneSE2          = "iPhone SE 2nd gen",
    iPhone12Mini       = "iPhone 12 Mini",
    iPhone12           = "iPhone 12",
    iPhone12Pro        = "iPhone 12 Pro",
    iPhone12ProMax     = "iPhone 12 Pro Max",

    AppleTV            = "Apple TV",
    AppleTV_4K         = "Apple TV 4K",
    unrecognized       = "?unrecognized?"
}

public extension UIDevice {

    var type: Model {
        var systemInfo = utsname()
        uname(&systemInfo)
        let modelCode = withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                ptr in String.init(validatingUTF8: ptr)
            }
        }

        let modelMap : [String: Model] = [
            "i386"      : .simulator,
            "x86_64"    : .simulator,

            "iPod1,1"   : .iPod1,
            "iPod2,1"   : .iPod2,
            "iPod3,1"   : .iPod3,
            "iPod4,1"   : .iPod4,
            "iPod5,1"   : .iPod5,

            "iPad2,1"   : .iPad2,
            "iPad2,2"   : .iPad2,
            "iPad2,3"   : .iPad2,
            "iPad2,4"   : .iPad2,
            "iPad3,1"   : .iPad3,
            "iPad3,2"   : .iPad3,
            "iPad3,3"   : .iPad3,
            "iPad3,4"   : .iPad4,
            "iPad3,5"   : .iPad4,
            "iPad3,6"   : .iPad4,
            "iPad6,11"  : .iPad5,
            "iPad6,12"  : .iPad5,
            "iPad7,5"   : .iPad6,
            "iPad7,6"   : .iPad6,
            "iPad7,11"  : .iPad7,
            "iPad7,12"  : .iPad7,

            "iPad2,5"   : .iPadMini,
            "iPad2,6"   : .iPadMini,
            "iPad2,7"   : .iPadMini,
            "iPad4,4"   : .iPadMini2,
            "iPad4,5"   : .iPadMini2,
            "iPad4,6"   : .iPadMini2,
            "iPad4,7"   : .iPadMini3,
            "iPad4,8"   : .iPadMini3,
            "iPad4,9"   : .iPadMini3,
            "iPad5,1"   : .iPadMini4,
            "iPad5,2"   : .iPadMini4,
            "iPad11,1"  : .iPadMini5,
            "iPad11,2"  : .iPadMini5,

            "iPad6,3"   : .iPadPro9_7,
            "iPad6,4"   : .iPadPro9_7,
            "iPad7,3"   : .iPadPro10_5,
            "iPad7,4"   : .iPadPro10_5,
            "iPad6,7"   : .iPadPro12_9,
            "iPad6,8"   : .iPadPro12_9,
            "iPad7,1"   : .iPadPro2_12_9,
            "iPad7,2"   : .iPadPro2_12_9,
            "iPad8,1"   : .iPadPro11,
            "iPad8,2"   : .iPadPro11,
            "iPad8,3"   : .iPadPro11,
            "iPad8,4"   : .iPadPro11,
            "iPad8,5"   : .iPadPro3_12_9,
            "iPad8,6"   : .iPadPro3_12_9,
            "iPad8,7"   : .iPadPro3_12_9,
            "iPad8,8"   : .iPadPro3_12_9,

            "iPad4,1"   : .iPadAir,
            "iPad4,2"   : .iPadAir,
            "iPad4,3"   : .iPadAir,
            "iPad5,3"   : .iPadAir2,
            "iPad5,4"   : .iPadAir2,
            "iPad11,3"  : .iPadAir3,
            "iPad11,4"  : .iPadAir3,

            "iPhone3,1" : .iPhone4,
            "iPhone3,2" : .iPhone4,
            "iPhone3,3" : .iPhone4,
            "iPhone4,1" : .iPhone4S,
            "iPhone5,1" : .iPhone5,
            "iPhone5,2" : .iPhone5,
            "iPhone5,3" : .iPhone5C,
            "iPhone5,4" : .iPhone5C,
            "iPhone6,1" : .iPhone5S,
            "iPhone6,2" : .iPhone5S,
            "iPhone7,1" : .iPhone6Plus,
            "iPhone7,2" : .iPhone6,
            "iPhone8,1" : .iPhone6S,
            "iPhone8,2" : .iPhone6SPlus,
            "iPhone8,4" : .iPhoneSE,
            "iPhone9,1" : .iPhone7,
            "iPhone9,3" : .iPhone7,
            "iPhone9,2" : .iPhone7Plus,
            "iPhone9,4" : .iPhone7Plus,
            "iPhone10,1" : .iPhone8,
            "iPhone10,4" : .iPhone8,
            "iPhone10,2" : .iPhone8Plus,
            "iPhone10,5" : .iPhone8Plus,
            "iPhone10,3" : .iPhoneX,
            "iPhone10,6" : .iPhoneX,
            "iPhone11,2" : .iPhoneXS,
            "iPhone11,4" : .iPhoneXSMax,
            "iPhone11,6" : .iPhoneXSMax,
            "iPhone11,8" : .iPhoneXR,
            "iPhone12,1" : .iPhone11,
            "iPhone12,3" : .iPhone11Pro,
            "iPhone12,5" : .iPhone11ProMax,
            "iPhone12,8" : .iPhoneSE2,
            "iPhone13,1" : .iPhone12Mini,
            "iPhone13,2" : .iPhone12,
            "iPhone13,3" : .iPhone12Pro,
            "iPhone13,4" : .iPhone12ProMax,

            "AppleTV5,3" : .AppleTV,
            "AppleTV6,2" : .AppleTV_4K
            
        ]

        if let model = modelMap[String.init(validatingUTF8: modelCode!)!] {
            if model == .simulator {
                if let simModelCode = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
                    if let simModel = modelMap[String.init(validatingUTF8: simModelCode)!] {
                        return simModel
                    }
                }
            }
            return model
        }
        
        return Model.unrecognized
        
    }
}

extension String {
    var stringByRemovingWhitespaces: String {
        return components(separatedBy: .whitespaces).joined()
    }
}

extension Date {
    var ticks: UInt64 {
        return UInt64((self.timeIntervalSince1970) / 10)
    }
}

extension Double {
    /// Rounds the double to decimal places value
    mutating func roundToPlaces(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return Darwin.round(self * divisor) / divisor
    }
}

func formatPoints(num: Double) ->String{
    var thousandNum = num/1000
    var millionNum = num/1000000
    if num >= 1000 && num < 1000000{
        if(floor(thousandNum) == thousandNum){
            return("\(Int(thousandNum))K")
        }
        return("\(thousandNum.roundToPlaces(places: 1))k")
    }
    if num > 1000000{
        if(floor(millionNum) == millionNum){
            return("\(Int(thousandNum))K")
        }
        return ("\(millionNum.roundToPlaces(places: 1))M")
    }
    if num > 1000000000{
        if(floor(millionNum) == millionNum){
            return("\(Int(thousandNum))M")
        }
        return ("\(millionNum.roundToPlaces(places: 1))B")
    }
    else{
        if(floor(num) == num){
            return ("\(Int(num))")
        }
        return ("\(num)")
    }

}

func showNote(text: String) {
    
    var attributes = EKAttributes.topNote
    attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.1), scale: .init(from: 1, to: 0.7, duration: 0.2)))
    attributes.entryBackground = .color(color: .musicBackground)
    attributes.shadow = .active(with: .init(color: .black, opacity: 0.5, radius: 10, offset: .zero))
    attributes.statusBar = .dark
    attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
    attributes.positionConstraints.maxSize = .init(width: .constant(value: UIScreen.main.bounds.width), height: .intrinsic)
    
    
    let style = EKProperty.LabelStyle(
        font: UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium),
        color: .white,
        alignment: .center
    )
    let labelContent = EKProperty.LabelContent(
        text: text,
        style: style
    )
    let contentView = EKNoteMessageView(with: labelContent)
    SwiftEntryKit.display(entry: contentView, using: attributes)
    
}

func getCurrentMillis()->Int64 {
    return Int64(Date().timeIntervalSince1970 * 1000)
}

extension UITableView {

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width - 20, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .white
        messageLabel.numberOfLines = 3
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }

    func restore() {
        self.backgroundView = nil
    }
}

func calculateMedian(array: [Int]) -> Double {
    // Array should be sorted
    let sorted = array.sorted()
    let length = array.count
    
    // handle when count of items is even
    if (length % 2 == 0) {
        return (Double(sorted[length / 2 - 1]) + Double(sorted[length / 2])) / 2.0
    }
    
    // handle when count of items is odd
    return Double(sorted[length / 2])
}


extension UINavigationBar {

    @IBInspectable var bottomBorderColor: UIColor {
        get {
            return self.bottomBorderColor;
        }
        set {
            let bottomBorderRect = CGRect.zero;
            let bottomBorderView = UIView(frame: bottomBorderRect);
            bottomBorderView.backgroundColor = newValue;
            addSubview(bottomBorderView);

            bottomBorderView.translatesAutoresizingMaskIntoConstraints = false;

            self.addConstraint(NSLayoutConstraint(item: bottomBorderView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0));
            self.addConstraint(NSLayoutConstraint(item: bottomBorderView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0));
            self.addConstraint(NSLayoutConstraint(item: bottomBorderView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0));
            self.addConstraint(NSLayoutConstraint(item: bottomBorderView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,multiplier: 1, constant: 1));
        }

    }

}

extension Array where Element : Equatable  {
    public mutating func removeObject(_ item: Element) {
        if let index = self.firstIndex(of: item) {
            self.remove(at: index)
        }
    }
}

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    /*
    subscript (exists index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
     */
}

extension Array where Element:Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()

        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }

        return result
    }
}


extension UINavigationController {

    func popBack(_ nb: Int) {
        let viewControllers: [UIViewController] = self.viewControllers
        guard viewControllers.count < nb else {
            self.popToViewController(viewControllers[viewControllers.count - nb], animated: true)
            return
        }
    }

    /// pop back to specific viewcontroller
    func popBack<T: UIViewController>(toControllerType: T.Type) {
        var viewControllers: [UIViewController] = self.viewControllers
        viewControllers = viewControllers.reversed()
        for currentViewController in viewControllers {
            if currentViewController .isKind(of: toControllerType) {
                self.popToViewController(currentViewController, animated: true)
                break
            }
        }
    }

 }

extension UIViewController: UIViewControllerTransitioningDelegate {
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting)
    }
}

extension UIButton {
    
    func beat() {
        
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.4
        pulse.fromValue = 1.0
        pulse.toValue = 1.12
        pulse.autoreverses = true
        pulse.repeatCount = .infinity
        pulse.initialVelocity = 0.5
        pulse.damping = 0.8
        layer.add(pulse, forKey: nil)
    
    
    }
    
    
    

    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.y")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.9
        animation.values = [-5.0, 5.0, -5.0, 5.0, -5.0, 2.0, -1.0, 1.0, 0.0 ]
        animation.repeatCount = .infinity
        layer.add(animation, forKey: "shake")
    }
    
    func removeAnimation() {
        
        layer.removeAllAnimations()
        
    }

}

@IBDesignable extension UIView {
    @IBInspectable var borderColors: UIColor? {
        set {
            layer.borderColor = newValue?.cgColor
        }
        get {
            guard let color = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
    }
    @IBInspectable var borderWidths: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
}


@IBDesignable extension UIButton {
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable override var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}

@IBDesignable
class UISwitchCustom: UISwitch {
    @IBInspectable var OffTint: UIColor? {
        didSet {
            self.tintColor = OffTint
            self.layer.cornerRadius = 16
            self.backgroundColor = OffTint
        }
    }
}

extension String {
    func findMHashtagText() -> [String] {
        var arr_hasStrings:[String] = []
        let regex = try? NSRegularExpression(pattern: "(#[a-zA-Z0-9_\\p{L}\\p{N}]*)", options: [.useUnicodeWordBoundaries, .caseInsensitive])
        if let matches = regex?.matches(in: self, options:[], range:NSMakeRange(0, self.count)) {
            for match in matches {
                arr_hasStrings.append(NSString(string: self).substring(with: NSRange(location:match.range.location, length: match.range.length )))
            }
        }
        return arr_hasStrings
    }
    
    func findMentiontagText() -> [String] {
        var arr_hasStrings:[String] = []
        let regex = try? NSRegularExpression(pattern: "(@[a-zA-Z0-9_\\p{L}\\p{N}]*)", options: [.useUnicodeWordBoundaries, .caseInsensitive])
        if let matches = regex?.matches(in: self, options:[], range:NSMakeRange(0, self.count)) {
            for match in matches {
                arr_hasStrings.append(NSString(string: self).substring(with: NSRange(location:match.range.location, length: match.range.length )))
            }
        }
        return arr_hasStrings
    }
}


func findUserIndexFromArray(userUID: String, arr: [String]) -> Int {
    
    var count = 0
    for item in arr {
        
        
        if item == userUID {
            return count
        }
        
        count+=1
        
    }
    
    return count
    
}

func findUserIndexFromCareList(userUID: String) -> Int {
    
    var count = 0
    for item in global_care_list {
        
        
        if item == userUID {
            return count
        }
        
        count+=1
        
    }
    
    return count
    
}

func update_care_list(uid: String) {
    
    let db = DataService.instance.mainFireStoreRef
    let my_uid = Auth.auth().currentUser?.uid
    
    db.collection("Users").whereField("userUID", isEqualTo: my_uid!).getDocuments {  querySnapshot, error in
     
         guard let snapshot = querySnapshot else {
             print("Error fetching snapshots: \(error!)")
             return
         }
     
     if !snapshot.isEmpty {
         
         for item in snapshot.documents {
             
             if let care_list = item.data()["care_list"] as? [String] {
                 
                var update_care_list = care_list
                
                if care_list.count >= 20 {
                    
                    update_care_list.removeLast()
                    
                }
                
                update_care_list.insert(uid, at: 0)
                
                db.collection("Users").document(item.documentID).updateData(["care_list": update_care_list])
                 
             } else {
                
                var care_list = [String]()
                care_list.append(uid)
                
                db.collection("Users").document(item.documentID).updateData(["care_list": care_list])
                
             }
             
             
             
         }
         
     }

    }
    
    
}

extension String{

    func widthWithConstrainedHeight(_ height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)

        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.width)
    }

    func heightWithConstrainedWidth(_ width: CGFloat, font: UIFont) -> CGFloat? {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.height)
    }

}

func verifyUrl (urlString: String?) -> Bool {
    if let urlString = urlString {
        if let url = NSURL(string: urlString) {
            return UIApplication.shared.canOpenURL(url as URL)
        }
    }
    
    return false
}

extension UIViewController {
    func showInputDialog(title:String? = nil,
                         subtitle:String? = nil,
                         actionTitle:String? = "Add",
                         cancelTitle:String? = "Cancel",
                         inputPlaceholder:String? = nil,
                         inputKeyboardType:UIKeyboardType = UIKeyboardType.default,
                         cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                         actionHandler: ((_ text: String?) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        
        let custom: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: "Avenir-Light", size: 13)!, NSAttributedString.Key.foregroundColor: UIColor.white]
        
        let subtitleString = NSMutableAttributedString(string: subtitle!, attributes: custom)
        
        
        alert.setValue(subtitleString, forKey: "attributedMessage")
        
        
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = inputPlaceholder
            textField.keyboardType = inputKeyboardType
        }
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { (action:UIAlertAction) in
            guard let textField =  alert.textFields?.first else {
                actionHandler?(nil)
                return
            }
            actionHandler?(textField.text)
        }))
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func showCodeDialog(title:String? = nil,
                         subtitle:String? = nil,
                         actionTitle:String? = "Add",
                         cancelTitle:String? = "Cancel",
                         inputPlaceholder:String? = nil,
                         inputKeyboardType:UIKeyboardType = UIKeyboardType.default,
                         cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                         actionHandler: ((_ text: String?) -> Void)? = nil) {
        
        
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        
        let custom: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: "Avenir-Light", size: 13)!, NSAttributedString.Key.foregroundColor: UIColor.white]
        
        let subtitleString = NSMutableAttributedString(string: subtitle!, attributes: custom)
        
        
        alert.setValue(subtitleString, forKey: "attributedMessage")
        
        
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = inputPlaceholder
            textField.keyboardType = inputKeyboardType
        }
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { (action:UIAlertAction) in
            guard let textField =  alert.textFields?.first else {
                actionHandler?(nil)
                return
            }
            actionHandler?(textField.text)
        }))
        
        
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: { (action:UIAlertAction) in
            
            
            actionHandler?("Skip Code")
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}


extension Array where Element: Hashable {
    func difference(from other: [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.symmetricDifference(otherSet))
    }
}

func getReadableDate(timeStamp: TimeInterval) -> String? {
    let date = Date(timeIntervalSince1970: timeStamp)
    let dateFormatter = DateFormatter()
    
    if Calendar.current.isDateInTomorrow(date) {
        return "Tomorrow"
    } else if Calendar.current.isDateInYesterday(date) {
        return "Yesterday"
    } else if dateFallsInCurrentWeek(date: date) {
        if Calendar.current.isDateInToday(date) {
            dateFormatter.dateFormat = "h:mm a"
            return dateFormatter.string(from: date)
        } else {
            dateFormatter.dateFormat = "EEEE"
            return dateFormatter.string(from: date)
        }
    } else {
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter.string(from: date)
    }
}

func dateFallsInCurrentWeek(date: Date) -> Bool {
    let currentWeek = Calendar.current.component(Calendar.Component.weekOfYear, from: Date())
    let datesWeek = Calendar.current.component(Calendar.Component.weekOfYear, from: date)
    return (currentWeek == datesWeek)
}


extension UIViewController {
  func hideKeyboardWhenTappedAround() {
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
  }
    
  @objc func dismissKeyboard() {
    view.endEditing(true)
  }
}

extension UIImage {

    func resize(targetSize: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size:targetSize).image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }

}

extension Date {
   func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}


func addToAvailableChatList(uid: [String]) {
    
    let db = DataService.instance.mainFireStoreRef
    
    db.collection("Users").whereField("userUID", isEqualTo: Auth.auth().currentUser!.uid).getDocuments{  querySnapshot, error in
           guard let snapshot = querySnapshot else {
               print("Error fetching snapshots: \(error!)")
               return
           }
        
        for item in snapshot.documents {
            
            if let Available_Chat_List = item.data()["Available_Chat_List"] as? [String] {
                
                var list = Available_Chat_List
                
                for user in uid {
                    
                    if !list.contains(user) {
                        list.append(user)
                    }
                    
                }
                
             
               db.collection("Users").document(item.documentID).updateData(["Available_Chat_List": list])
                
                
            } else {
                
                
                if !uid.isEmpty {
                    db.collection("Users").document(item.documentID).updateData(["Available_Chat_List": uid])
                }
               
            
                
            }
            
            
        }
        
    }
    
    
}
//Auth.auth().currentUser!.uid
func addToUserAvailableChatList(uid: String) {
    
    let db = DataService.instance.mainFireStoreRef
    
    db.collection("Users").whereField("userUID", isEqualTo: uid).getDocuments{  querySnapshot, error in
           guard let snapshot = querySnapshot else {
               print("Error fetching snapshots: \(error!)")
               return
           }
        
        for item in snapshot.documents {
            
            if let Available_Chat_List = item.data()["Available_Chat_List"] as? [String] {
                
                var list = Available_Chat_List
                
                if !list.contains(Auth.auth().currentUser!.uid) {
                    list.append(Auth.auth().currentUser!.uid)
                }
                
             
               db.collection("Users").document(item.documentID).updateData(["Available_Chat_List": list])
                
                
            } else {
                
                
                if !uid.isEmpty {
                    db.collection("Users").document(item.documentID).updateData(["Available_Chat_List": [Auth.auth().currentUser!.uid]])
                }
               
            
                
            }
            
            
        }
        
    }
    
    
}

extension UITableViewRowAction {

  func setIcon(iconImage: UIImage, backColor: UIColor, cellHeight: CGFloat, iconSizePercentage: CGFloat)
  {
    let iconHeight = cellHeight * iconSizePercentage
    let margin = (cellHeight - iconHeight) / 2 as CGFloat

    UIGraphicsBeginImageContextWithOptions(CGSize(width: cellHeight, height: cellHeight), false, 0)
    let context = UIGraphicsGetCurrentContext()

    backColor.setFill()
    context!.fill(CGRect(x:0, y:0, width:cellHeight, height:cellHeight))

    iconImage.draw(in: CGRect(x: margin, y: margin, width: iconHeight, height: iconHeight))

    let actionImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    self.backgroundColor = UIColor.init(patternImage: actionImage!)
  }
}

extension UIView {
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

extension UITableView {
    func reloadData(with animation: UITableView.RowAnimation) {
        reloadSections(IndexSet(integersIn: 0..<numberOfSections), with: animation)
    }
}

extension Double {


    // returns the date formatted.
    var dateFormatted : String? {
        let date = Date(timeIntervalSince1970: self)
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.none //Set time style
        dateFormatter.dateStyle = DateFormatter.Style.short //Set date style
        return dateFormatter.string(from: date)
     }

    // returns the date formatted according to the format string provided.
    func dateFormatted(withFormat format : String) -> String{
         let date = Date(timeIntervalSince1970: self)
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = format
         return dateFormatter.string(from: date)
    }

}
