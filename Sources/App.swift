import SwiftUI

@main
struct ClaudeUsageMonitorApp: App {
    @StateObject private var service = UsageService()

    var body: some Scene {
        MenuBarExtra {
            UsageView(service: service)
        } label: {
            HStack(spacing: 4) {
                Image(systemName: "gauge.with.needle")
                Text(menuBarTitle)
                    .monospacedDigit()
            }
        }
        .menuBarExtraStyle(.window)
    }

    private var menuBarTitle: String {
        guard let usage = service.usage else { return "—" }
        return "\(usage.fiveHour.percentage)%"
    }
}
