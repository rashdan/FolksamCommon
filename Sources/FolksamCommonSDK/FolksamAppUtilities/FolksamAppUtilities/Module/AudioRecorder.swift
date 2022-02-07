//
//  AudioRecorder.swift
//  FolksamAppUtilities
//
//  Created by Johan Torell on 2021-10-27.
//

import AVFoundation
import UIKit

@available(iOS 13.0, *)
public class AudioRecorder: NSObject, ObservableObject {
    @Published public var currentlyRecording = false
    @Published public var successfulRecording = false

    private var audioRecorder: AVAudioRecorder!
    private var recordingSession: AVAudioSession!

    public func setupAudioRecorder() {
        recordingSession = AVAudioSession.sharedInstance()

        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission { allowed in
                DispatchQueue.main.async {
                    if allowed {
                        print("User has allowed recording")
                    } else {
                        print("User has not allowed recording")
                    }
                }
            }
        } catch {
            print("There was an error executing setupAudioRecorder")
        }
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docDirectory = paths[0]
        return docDirectory
    }

    func startRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        print(audioFilename.absoluteString)

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue,
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            print("start recording")
        } catch {
            finishRecording(success: false)
        }
    }

    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil

        if success {
            print("successful recording")
            successfulRecording = true
        } else {
            print("failed recording")
        }
    }

    public func toggle() {
        if audioRecorder == nil {
            startRecording()
            successfulRecording = false
        } else {
            finishRecording(success: true)
        }
        currentlyRecording.toggle()
    }
}

@available(iOS 13.0, *)
extension AudioRecorder: AVAudioRecorderDelegate {
    public func audioRecorderDidFinishRecording(_: AVAudioRecorder, successfully flag: Bool) {
        if flag == false {
            finishRecording(success: false)
        }
    }
}
