//
//  BMSubtitles.swift
//  Pods
//
//  Created by BrikerMan on 2017/4/2.
//
//

import Foundation

public class BMSubtitles {
    public var groups: [Group] = []
    
    public struct Group: CustomStringConvertible {
        var index: Int
        var start: TimeInterval
        var end  : TimeInterval
        var text : String
        
        init(_ index: Int, _ start: String, _ end: String, _ text: String) {
            self.index = index
            self.start = Group.parseDuration(start)
            self.end   = Group.parseDuration(end)
            self.text  = text
        }
        
        static func parseDuration(_ fromStr:String) -> TimeInterval {
            let scanner = Scanner(string: fromStr)
            let h = scanner.scanDouble() ?? 0.0
            _ = scanner.scanString(":")
            let m = scanner.scanDouble() ?? 0.0
            _ = scanner.scanString(":")
            let s = scanner.scanDouble() ?? 0.0
            _ = scanner.scanString(",")
            let c = scanner.scanDouble() ?? 0.0
            return (h * 3600.0) + (m * 60.0) + s + (c / 1000.0)
        }
        
        public var description: String {
            return "Subtile Group ==========\nindex : \(index),\nstart : \(start)\nend   :\(end)\ntext  :\(text)"
        }
    }
    
    public init(url: URL, encoding: String.Encoding? = nil) {
        DispatchQueue.global(qos: .background).async {[weak self] in
            do {
                let string: String
                if let encoding = encoding {
                    string = try String(contentsOf: url, encoding: encoding)
                } else {
                    string = try String(contentsOf: url)
                }
                self?.groups = BMSubtitles.parseSubRip(string) ?? []
            } catch {
                print("| BMPlayer | [Error] failed to load \(url.absoluteString) \(error.localizedDescription)")
            }
        }
    }
    
    /**
     Search for target group for time
     
     - parameter time: target time
     
     - returns: result group or nil
     */
    public func search(for time: TimeInterval) -> Group? {
        let result = groups.first(where: { group -> Bool in
            if group.start <= time && group.end >= time {
                return true
            }
            return false
        })
        return result
    }
    
    /**
     Parse str string into Group Array
     
     - parameter payload: target string
     
     - returns: result group
     */
    fileprivate static func parseSubRip(_ payload: String) -> [Group]? {
        var groups: [Group] = []
        let scanner = Scanner(string: payload)
        while !scanner.isAtEnd {
            let indexString = scanner.scanUpToCharacters(from: .newlines)
            
            let startString = scanner.scanUpToString(" --> ")
            
            // skip spaces and newlines by default.
            _ = scanner.scanString("-->")
            
            let endString = scanner.scanUpToCharacters(from: .newlines)
            
            var textString = scanner.scanUpToString("\r\n\r\n")
            
            if let text = textString {
                textString = text.trimmingCharacters(in: .whitespaces)
                textString = text.replacingOccurrences(of: "\r", with: "")
            }
            
            if let indexString = indexString,
                let index = Int(indexString),
                let start = startString,
                let end   = endString,
                let text  = textString {
                let group = Group(index, start, end, text)
                groups.append(group)
            }
        }
        return groups
    }
}
