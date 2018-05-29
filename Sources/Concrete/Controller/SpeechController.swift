//
//  SpeechController.swift
//  InstantSearch
//
//  Created by Robert Mogos on 18/12/2017.
//

import UIKit
import Speech

public typealias SpeechTextHandler = (String, Bool) -> Void
public typealias SpeechErrorHandler = (Error?) -> Void

/// A controller object that manages the speech recognition to text
/// `SpeechController` is using the Speech framework, so it can only be used with iOS 10+
/// Simply initilise the controller with the desired `locale` or the device's `default` one
/// let speechController = SpeechController()
/// let speechController = SpeechController(locale: Locale(identifier: "fr_FR"))
/// Do not forget to add `NSSpeechRecognitionUsageDescription` and `NSMicrophoneUsageDescription` to your Info.plist
@available(iOS 10.0, *)
@objcMembers public class SpeechController: NSObject, SFSpeechRecognizerDelegate {
  
  private let speechRecognizer: SFSpeechRecognizer
  private var speechRequest: SFSpeechAudioBufferRecognitionRequest?
  private var speechTask: SFSpeechRecognitionTask?
  private let audioEngine = AVAudioEngine()
  
  /// Init with the device's default locale
  override public convenience init() {
    self.init(speechRecognizer: SFSpeechRecognizer())
  }
  
  /// Init with a locale
  public convenience init(locale: Locale) {
    self.init(speechRecognizer: SFSpeechRecognizer(locale: locale))
  }
  
  private init(speechRecognizer: SFSpeechRecognizer?) {
    guard let speechRecognizer = speechRecognizer else {
      fatalError("Locale not supported. Check SpeechController.supportedLocales() or  SpeechController.localeSupported(locale: Locale)")
    }
    self.speechRecognizer = speechRecognizer
    super.init()
  }
  
  /// Helper to get a list of supported locales
  public class func supportedLocales() -> Set<Locale> {
    return SFSpeechRecognizer.supportedLocales()
  }
  
  /// Helper to check if a locale is supported or not
  public class func localeSupported(_ locale: Locale) -> Bool {
    return SFSpeechRecognizer.supportedLocales().contains(locale)
  }
  
  /// Helper to request authorization for voice search
  public func requestAuthorization(_ statusHandler: @escaping (Bool) -> Void) {
    SFSpeechRecognizer.requestAuthorization { (authStatus) in
      switch authStatus {
      case .authorized:
          statusHandler(true)
      default:
          statusHandler(false)
      }
    }
  }
  
  public func isRecording() -> Bool {
    return audioEngine.isRunning
  }
  
  /// The method is going to give an infinite stream of speech-to-text until `stopRecording` is called or an error is encounter
  public func startRecording(textHandler: @escaping SpeechTextHandler, errorHandler: @escaping SpeechErrorHandler) {
    requestAuthorization { (authStatus) in
      if authStatus {
        if !self.audioEngine.isRunning {
            self.record(textHandler: textHandler, errorHandler: errorHandler)
        }
      } else {
        let errorMsg = "Speech recognizer needs to be authorized first"
        errorHandler(NSError(domain:"com.algolia.speechcontroller", code:1, userInfo:[NSLocalizedDescriptionKey: errorMsg]))
      }
    }
  }
  
  private func record(textHandler: @escaping SpeechTextHandler, errorHandler: @escaping SpeechErrorHandler) {
    let node = audioEngine.inputNode
    let recordingFormat = node.outputFormat(forBus: 0)
    speechRequest = SFSpeechAudioBufferRecognitionRequest()
    
    node.installTap(onBus: 0, bufferSize: 1024,
                    format: recordingFormat) { [weak self] (buffer, _) in
                      self?.speechRequest?.append(buffer)
    }
    audioEngine.prepare()
    do {
      try audioEngine.start()
    } catch let err {
      errorHandler(err)
      return
    }
    
    speechTask = speechRecognizer.recognitionTask(with: speechRequest!) { (result, error) in
      if let r = result {
        let transcription = r.bestTranscription
        let isFinal = r.isFinal
        textHandler(transcription.formattedString, isFinal)
      } else {
        errorHandler(error)
      }
    }
  }
  
  /// Method which will stop the recording
  public func stopRecording() {
    if audioEngine.isRunning {
      audioEngine.stop()
      audioEngine.inputNode.removeTap(onBus: 0)
      speechTask?.cancel()
      speechRequest?.endAudio()
    }
    speechTask = nil
    speechRequest = nil
  }
  
  deinit {
    stopRecording()
  }
  
}
