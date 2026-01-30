import Foundation

enum MenuBarDisplay: String, CaseIterable {
    case percentOnly = "percent"
    case timeOnly = "time"
    case both = "both"

    var label: String {
        switch self {
        case .percentOnly: return "Percentage only"
        case .timeOnly: return "Time only"
        case .both: return "Both"
        }
    }
}

enum FlameMode: String, CaseIterable {
    case off = "off"
    case single = "single"
    case dynamic = "dynamic"

    var label: String {
        switch self {
        case .off: return "Off"
        case .single: return "1"
        case .dynamic: return "3"
        }
    }
}

enum PollingInterval: Int, CaseIterable {
    case one = 60
    case five = 300
    case ten = 600

    var label: String {
        switch self {
        case .one: return "1 min"
        case .five: return "5 min"
        case .ten: return "10 min"
        }
    }
}

@MainActor
final class AppSettings: ObservableObject {
    static let shared = AppSettings()

    @Published var menuBarDisplay: MenuBarDisplay {
        didSet { UserDefaults.standard.set(menuBarDisplay.rawValue, forKey: "menuBarDisplay") }
    }
    @Published var pollingInterval: PollingInterval {
        didSet { UserDefaults.standard.set(pollingInterval.rawValue, forKey: "pollingInterval") }
    }
    @Published var flameMode: FlameMode {
        didSet { UserDefaults.standard.set(flameMode.rawValue, forKey: "flameMode") }
    }

    private init() {
        if let raw = UserDefaults.standard.string(forKey: "menuBarDisplay"),
           let value = MenuBarDisplay(rawValue: raw) {
            self.menuBarDisplay = value
        } else {
            self.menuBarDisplay = .both
        }

        let interval = UserDefaults.standard.integer(forKey: "pollingInterval")
        if interval > 0, let value = PollingInterval(rawValue: interval) {
            self.pollingInterval = value
        } else {
            self.pollingInterval = .five
        }

        if let raw = UserDefaults.standard.string(forKey: "flameMode"),
           let value = FlameMode(rawValue: raw) {
            self.flameMode = value
        } else {
            self.flameMode = .dynamic
        }
    }
}
