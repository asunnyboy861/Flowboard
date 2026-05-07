import NaturalLanguage

struct ParsedTask {
    let title: String
    var dueDate: Date?
    var priority: Int16 = 0
    var tags: [String] = []
}

final class NaturalLanguageParser {
    static func parse(_ input: String) -> ParsedTask {
        var title = input
        var dueDate: Date?
        var priority: Int16 = 0
        var tags: [String] = []

        if let regex = try? NSRegularExpression(pattern: "#(\\w+)") {
            let range = NSRange(title.startIndex..., in: title)
            let matches = regex.matches(in: title, range: range)
            for match in matches.reversed() {
                if let range = Range(match.range(at: 1), in: title) {
                    tags.append(String(title[range]))
                }
                if let fullRange = Range(match.range, in: title) {
                    title.removeSubrange(fullRange)
                }
            }
        }

        let priorityKeywords: [(String, Int16)] = [
            ("!!!", 3), ("urgent", 3), ("critical", 3),
            ("!!", 2), ("high", 2), ("important", 2),
            ("!", 1), ("medium", 1)
        ]
        for (keyword, value) in priorityKeywords {
            if title.lowercased().contains(keyword) {
                priority = value
                title = title.replacingOccurrences(of: keyword, with: "", options: .caseInsensitive)
                break
            }
        }

        let dateKeywords = ["today", "tomorrow", "next week", "monday", "tuesday",
                           "wednesday", "thursday", "friday", "saturday", "sunday"]
        for keyword in dateKeywords {
            if title.lowercased().contains(keyword) {
                dueDate = parseRelativeDate(keyword)
                title = title.replacingOccurrences(of: keyword, with: "", options: .caseInsensitive)
                break
            }
        }

        title = title.trimmingCharacters(in: .whitespaces)

        return ParsedTask(title: title, dueDate: dueDate, priority: priority, tags: tags)
    }

    private static func parseRelativeDate(_ keyword: String) -> Date? {
        let cal = Calendar.current
        let now = Date()
        switch keyword.lowercased() {
        case "today": return cal.startOfDay(for: now)
        case "tomorrow": return cal.date(byAdding: .day, value: 1, to: cal.startOfDay(for: now))
        case "next week": return cal.date(byAdding: .weekOfYear, value: 1, to: cal.startOfDay(for: now))
        default:
            let weekdays: [String: Int] = [
                "sunday": 1, "monday": 2, "tuesday": 3, "wednesday": 4,
                "thursday": 5, "friday": 6, "saturday": 7
            ]
            if let targetWeekday = weekdays[keyword.lowercased()] {
                let currentWeekday = cal.component(.weekday, from: now)
                var daysToAdd = targetWeekday - currentWeekday
                if daysToAdd <= 0 { daysToAdd += 7 }
                return cal.date(byAdding: .day, value: daysToAdd, to: cal.startOfDay(for: now))
            }
            return nil
        }
    }
}
