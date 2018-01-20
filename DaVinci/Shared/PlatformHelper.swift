
import Foundation

public typealias ExecuteClosure = () -> Swift.Void

public enum Platforms {
    case iOS(ExecuteClosure)
    case macOS(ExecuteClosure)
    case watchOS(ExecuteClosure)
    case tvOS(ExecuteClosure)
    case linux(ExecuteClosure)
}

/// Runs code condtionally depending on the platform.
public func execute(on platforms: Platforms...) {
    for p in platforms {
        #if os(iOS)
            switch p {
            case .iOS(let closure):
                closure()
                break
            default: break
            }
        #elseif os(macOS)
            switch p {
            case .macOS(let closure):
                closure()
                break
            default: break
            }
        #elseif os(watchOS)
            switch p {
            case .watchOS(let closure):
                closure()
                break
            default: break
            }
        #elseif os(tvOS)
            switch p {
            case .tvOS(let closure):
                closure()
                break
            default: break
            }
        #elseif os(Linux)
            switch p {
            case .linux(let closure):
                closure()
                break
            default: break
            }
        #endif
    }
}

