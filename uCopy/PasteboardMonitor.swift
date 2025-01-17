//
//  PasteboardMonitor.swift
//  uCopy
//
//  Created by 周辉 on 2022/11/14.
//

import AppKit

class PasteboardData {
    let string: String
    let createDate: Date
    let source: String?
    init(string: String, createDate: Date, source: String?) {
        self.string = string
        self.createDate = createDate
        self.source = source
    }
}

class PasteboardMonitor {
    var timer: Timer!
    let pasteboard = NSPasteboard.general
    var lastChangeCount = 0
    init() {
        self.lastChangeCount = self.pasteboard.changeCount
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true, block: {[weak self] t in
            if self?.lastChangeCount != self?.pasteboard.changeCount {
                self?.lastChangeCount = self?.pasteboard.changeCount ?? 0
                self?.postNotification()
            }
        })
    }
    func terminate() {
        timer.invalidate()
    }
    func postNotification() {
        guard let string = self.pasteboard.string(forType: NSPasteboard.PasteboardType.string) else {
            return
        }
        let frontmostApp = NSWorkspace.shared.frontmostApplication
        let data = PasteboardData(string: string, createDate: Date.now, source: frontmostApp?.localizedName)
        NotificationCenter.default.post(name: .NSPasteboardDidChange, object: self.pasteboard, userInfo: ["data": data])
    }
}

extension NSNotification.Name {
    public static let NSPasteboardDidChange: NSNotification.Name = .init(rawValue: "pasteboardDidChangeNotification")
}
