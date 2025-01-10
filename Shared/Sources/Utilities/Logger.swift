//
//  Logger.swift
//  Shared
//
//  Created by 홍기웅 on 12/24/24.
//

import Foundation
import Combine
import OSLog

public enum LogLevel {
    case trace
    case debug
    case info
    case notice
    case warning
    case error
    case critical
    
    var string: String {
        switch self {
        case .trace: "TRACE"
        case .debug : "DEBUG"
        case .info : "INFO"
        case .notice : "NOTICE"
        case .warning : "WARNING"
        case .error : "ERROR"
        case .critical : "CRITICAL"
        }
    }
    
    var emoji: String {
        switch self {
        case .trace: "👀"
        case .debug: "🐞"
        case .info: "ℹ️"
        case .notice: "📍"
        case .warning: "⚠️"
        case .error: "‼️"
        case .critical: "🚨"
        }
    }
}

public enum Log {
  /// Logger를 생성합니다.
  /// - Parameter category: 모듈 별로 Log를 구분하기 위한 파라미터
    public static func make(with category: LogCategory = .app) -> Logger {
    return Logger(subsystem: .bundleIdentifier, category: category.rawValue)
  }
}

// MARK: - LogCategory

/// 로그 카테고리
public enum LogCategory: String {
    case app = "App"
    case data = "Data"
    case domain = "Domain"
    case shared = "Shared"
    case presentation = "Presentation"

}

private extension String {
  static let bundleIdentifier: String = Bundle.main.bundleIdentifier ?? "None"
}

extension Logger {
    
    public func log(
        level: LogLevel = .trace,
        _ object: Any,
        fileID: String = #fileID,
        line: Int = #line,
        column: Int = #column,
        funcName: String = #function
    ) {
        let message = "[\(sourceFileModuleName(fileID))] [\(level.emoji)] [\(sourceFileName(fileID)) - \(funcName) #\(line)] || \(object)"

        switch level {
        case .trace: trace("\(message)")
        case .debug: debug("\(message)")
        case .info: info("\(message)")
        case .notice: notice("\(message)")
        case .warning: warning("\(message)")
        case .error: error("\(message)")
        case .critical: critical("\(message)")
        }
    }
    
    private func sourceFileModuleName(_ fileID: String) -> String {
        let components = fileID.components(separatedBy: "/")
        guard let moduleName = components.first else { return "UNKNOWN" }
        
        return moduleName
    }
    
    private func sourceFileName(_ fileID: String) -> String {
        let components = fileID.components(separatedBy: "/")
        if let last = components.last {
            let files = last.components(separatedBy: ".")
            return files.first ?? "UNKNOWN"
        }
        return components.isEmpty ? "" : components.last!
    }
    
}
