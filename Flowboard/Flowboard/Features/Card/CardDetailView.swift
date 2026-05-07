import SwiftUI
import CoreData

struct CardDetailView: View {
    @ObservedObject var card: Card
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @State private var title: String = ""
    @State private var cardDescription: String = ""
    @State private var dueDate: Date = Date()
    @State private var hasDueDate = false
    @State private var priority: Int16 = 0
    @State private var showingDeleteConfirmation = false

    var body: some View {
        Form {
            Section("Task") {
                TextField("Title", text: $title)
                TextField("Description", text: $cardDescription, axis: .vertical)
                    .lineLimit(3...6)
            }

            Section("Details") {
                Picker("Priority", selection: $priority) {
                    Text("Low").tag(Int16(0))
                    Text("Medium").tag(Int16(1))
                    Text("High").tag(Int16(2))
                    Text("Urgent").tag(Int16(3))
                }

                Toggle("Due Date", isOn: $hasDueDate)

                if hasDueDate {
                    DatePicker("Due", selection: $dueDate, displayedComponents: .date)
                }
            }

            Section("Tags") {
                if !card.tagsArray.isEmpty {
                    FlowLayout(spacing: 6) {
                        ForEach(card.tagsArray, id: \.id) { tag in
                            TagChip(name: tag.name ?? "", colorHex: tag.colorHex ?? "#8E8E93")
                        }
                    }
                } else {
                    Text("No tags")
                        .foregroundStyle(.secondary)
                }
            }

            Section {
                Button(role: .destructive) {
                    showingDeleteConfirmation = true
                } label: {
                    HStack {
                        Image(systemName: "trash")
                        Text("Delete Task")
                    }
                }
            }
        }
        .navigationTitle("Task Details")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            title = card.title ?? ""
            cardDescription = card.cardDescription ?? ""
            priority = card.priority
            if let due = card.dueDate {
                dueDate = due
                hasDueDate = true
            }
        }
        .onChange(of: title) { _, newValue in updateCard() }
        .onChange(of: cardDescription) { _, newValue in updateCard() }
        .onChange(of: priority) { _, newValue in updateCard() }
        .onChange(of: hasDueDate) { _, newValue in updateCard() }
        .onChange(of: dueDate) { _, newValue in updateCard() }
        .alert("Delete Task?", isPresented: $showingDeleteConfirmation) {
            Button("Delete", role: .destructive) { deleteCard() }
            Button("Cancel", role: .cancel) {}
        }
    }

    private func updateCard() {
        let repo = CardRepository(context: viewContext)
        do {
            try repo.updateCard(
                card,
                title: title,
                cardDescription: cardDescription,
                dueDate: hasDueDate ? dueDate : nil,
                priority: priority
            )
            if hasDueDate {
                NotificationService.shared.scheduleReminder(for: card)
            } else {
                NotificationService.shared.cancelReminder(for: card)
            }
        } catch {
            print("Failed to update card: \(error)")
        }
    }

    private func deleteCard() {
        let repo = CardRepository(context: viewContext)
        NotificationService.shared.cancelReminder(for: card)
        do {
            try repo.deleteCard(card)
            dismiss()
        } catch {
            print("Failed to delete card: \(error)")
        }
    }
}

struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = arrange(proposal: proposal, subviews: subviews)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = arrange(proposal: proposal, subviews: subviews)
        for (index, position) in result.positions.enumerated() {
            subviews[index].place(at: CGPoint(x: bounds.minX + position.x, y: bounds.minY + position.y), proposal: .unspecified)
        }
    }

    private func arrange(proposal: ProposedViewSize, subviews: Subviews) -> (size: CGSize, positions: [CGPoint]) {
        let maxWidth = proposal.width ?? .infinity
        var positions: [CGPoint] = []
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var rowHeight: CGFloat = 0
        var maxX: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if currentX + size.width > maxWidth, currentX > 0 {
                currentX = 0
                currentY += rowHeight + spacing
                rowHeight = 0
            }
            positions.append(CGPoint(x: currentX, y: currentY))
            rowHeight = max(rowHeight, size.height)
            currentX += size.width + spacing
            maxX = max(maxX, currentX)
        }

        return (CGSize(width: maxX, height: currentY + rowHeight), positions)
    }
}
