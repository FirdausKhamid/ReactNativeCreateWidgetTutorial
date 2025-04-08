//
//  WidgetTutorial.swift
//  WidgetTutorial
//
//  Created by Mohamad Firdaus K Hamid on 08/04/2025.
//

import WidgetKit
import SwiftUI

// MARK: - Provider

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: .smiley, data: .mock)
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration, data: .mock)
    }

    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        let currentDate = Date()
        for hourOffset in 0..<5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration, data: .mock)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }
}

// MARK: - Mock ValuesData

struct ValuesData: Codable {
    let sum: Double
    let amount: Double
    static let mock = ValuesData(sum: 42.0, amount: 7.0)
}

// MARK: - Entry

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    let data: ValuesData
}

// MARK: - Widget View

struct WidgetTutorialEntryView: View {
    var entry: Provider.Entry
    
    let buttons: [[String]] = [
        ["AC", "±", "%", "÷"],
        ["7", "8", "9", "×"],
        ["4", "5", "6", "−"],
        ["1", "2", "3", "+"],
        ["0", ".", "="]
    ]
    
    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let height = geo.size.height
            
            let buttonSpacing: CGFloat = 4
            let columns = 4
            let rows = buttons.count
            let buttonWidth = (width - (CGFloat(columns + 1) * buttonSpacing)) / CGFloat(columns)
            let buttonHeight = (height - 40 - (CGFloat(rows + 1) * buttonSpacing)) / CGFloat(rows)
            
            VStack(spacing: buttonSpacing) {
                // Display area
                HStack {
                    Spacer()
                    Text("\(entry.data.sum, specifier: "%.0f") + \(entry.data.amount, specifier: "%.0f") = \(entry.data.sum + entry.data.amount, specifier: "%.0f")")
                        .font(.system(size: 16, weight: .bold, design: .monospaced))
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .padding(.horizontal, 6)
                }
                .frame(height: 40)
                .background(RoundedRectangle(cornerRadius: 8).fill(Color.black.opacity(0.1)))
                
                // Buttons
                VStack(spacing: buttonSpacing) {
                    ForEach(buttons, id: \.self) { row in
                        HStack(spacing: buttonSpacing) {
                            ForEach(row, id: \.self) { button in
                                ButtonView(title: button,
                                           width: button == "0" ? buttonWidth * 2 + buttonSpacing : buttonWidth,
                                           height: buttonHeight)
                            }
                        }
                    }
                }
            }
            .padding(buttonSpacing)
        }
    }
}

struct ButtonView: View {
    let title: String
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        Link(destination: URL(string: "widgetcalculator://input/\(title)")!) {
            Text(title)
                .frame(width: width, height: height)
                .background(Color.gray.opacity(0.2))
                .foregroundColor(.black)
                .font(.system(size: 16, weight: .medium))
                .cornerRadius(8)
        }
    }
}

// MARK: - Widget

struct WidgetTutorial: Widget {
    let kind: String = "WidgetTutorial"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            WidgetTutorialEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .supportedFamilies([.systemMedium])
    }
}

// MARK: - Configuration Extensions

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

// MARK: - Preview

#Preview(as: .systemMedium) {
    WidgetTutorial()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley, data: .mock)
    SimpleEntry(date: .now.addingTimeInterval(3600), configuration: .starEyes, data: .mock)
}
