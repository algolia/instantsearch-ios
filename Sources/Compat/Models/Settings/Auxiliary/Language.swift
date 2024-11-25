//
//  Language.swift
//  
//
//  Created by Vladislav Fitc on 12.03.2020.
//

import Foundation

public struct Language: StringOption, ProvidingCustomOption, Hashable, ExpressibleByStringInterpolation, URLEncodable {

  public var rawValue: String
  public init(rawValue: String) { self.rawValue = rawValue }
  public init(stringLiteral: String) { self.rawValue = stringLiteral }

  public static let afrikaans: Self = "af"
  public static let arabic: Self = "ar"
  public static let azeri: Self = "az"
  public static let bulgarian: Self = "bg"
  public static let brunei: Self = "bn"
  public static let catalan: Self = "ca"
  public static let czech: Self = "cs"
  public static let welsh: Self = "cy"
  public static let danish: Self = "da"
  public static let german: Self = "de"
  public static let english: Self = "en"
  public static let esperanto: Self = "eo"
  public static let spanish: Self = "es"
  public static let estonian: Self = "et"
  public static let basque: Self = "eu"
  public static let finnish: Self = "fi"
  public static let faroese: Self = "fo"
  public static let french: Self = "fr"
  public static let galician: Self = "gl"
  public static let hebrew: Self = "he"
  public static let hindi: Self = "hi"
  public static let hungarian: Self = "hu"
  public static let armenian: Self = "hy"
  public static let indonesian: Self = "id"
  public static let icelandic: Self = "is"
  public static let italian: Self = "it"
  public static let japanese: Self = "ja"
  public static let georgian: Self = "ka"
  public static let kazakh: Self = "kk"
  public static let korean: Self = "ko"
  public static let kyrgyz: Self = "ky"
  public static let lithuanian: Self = "lt"
  public static let maori: Self = "mi"
  public static let mongolian: Self = "mn"
  public static let marathi: Self = "mr"
  public static let malay: Self = "ms"
  public static let maltese: Self = "mt"
  public static let norwegian: Self = "nb"
  public static let dutch: Self = "nl"
  public static let northernsotho: Self = "ns"
  public static let polish: Self = "pl"
  public static let pashto: Self = "ps"
  public static let portuguese: Self = "pt"
  public static let quechua: Self = "qu"
  public static let romanian: Self = "ro"
  public static let russian: Self = "ru"
  public static let slovak: Self = "sk"
  public static let albanian: Self = "sq"
  public static let swedish: Self = "sv"
  public static let swahili: Self = "sw"
  public static let tamil: Self = "ta"
  public static let telugu: Self = "te"
  public static let tagalog: Self = "tl"
  public static let tswana: Self = "tn"
  public static let turkish: Self = "tr"
  public static let tatar: Self = "tt"

}
