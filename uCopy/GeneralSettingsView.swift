//
//  GeneralSettingsView.swift
//  uCopy
//
//  Created by 周辉 on 2022/11/16.
//

import SwiftUI
import AVFoundation
import LaunchAtLogin
import KeyboardShortcuts

struct GeneralSettingsView: View {
    @AppStorage("uCopy.sound")
    private var selectedSound: SoundNames = .blow
    var body: some View {
        Form {
            Section {
                LaunchAtLogin.Toggle("Launch at login")
            }
            .padding(.bottom)
            Section {
                KeyboardShortcuts.Recorder("History Shortcuts:", name: .historyShortcuts)
                KeyboardShortcuts.Recorder("Snippet Shortcuts:", name: .snippetShortcuts)
            }
            .padding(.bottom)
            Section {
                Picker("Sound", selection: $selectedSound) {
                    ForEach(SoundNames.allCases) { sound in
                        Text(sound.rawValue.capitalized)
                    }
                }
            }
        }
        .padding(20)
        .frame(width: 350, height: 100)
        .onChange(of: selectedSound) { newSound in
            NSSound(named: newSound.rawValue.capitalized)?.play()
        }
    }
}

enum SoundNames: String, CaseIterable, Identifiable {
    /**
         Basso.aiff     Bottle.aiff    Funk.aiff      Hero.aiff      Ping.aiff      Purr.aiff      Submarine.aiff
         Blow.aiff      Frog.aiff      Glass.aiff     Morse.aiff     Pop.aiff       Sosumi.aiff    Tink.aiff
     */
    case none, basso, blow, bottle, frog, funk, glass, hero, morse, ping, pop, purr, sosumi, submarine, tink
    var id: Self { self }
}

extension KeyboardShortcuts.Name {
    static let historyShortcuts = Self("historyShortcuts",
                                       default: .init(.c, modifiers: [.command, .option]))
    static let snippetShortcuts = Self("snippetShortcuts",
                                       default: .init(.x, modifiers: [.command, .option]))
}
