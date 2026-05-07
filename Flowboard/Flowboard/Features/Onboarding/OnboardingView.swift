import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var currentPage = 0

    var body: some View {
        TabView(selection: $currentPage) {
            onboardingPage(
                icon: "square.grid.2x2",
                title: "Organize Your Work",
                subtitle: "Create beautiful kanban boards to visualize your projects and tasks at a glance."
            )
            .tag(0)

            onboardingPage(
                icon: "hand.draw",
                title: "Drag & Drop Simplicity",
                subtitle: "Move tasks between columns with a simple drag. No learning curve, just flow."
            )
            .tag(1)

            onboardingPage(
                icon: "sparkles",
                title: "AI-Powered Productivity",
                subtitle: "Break down complex tasks with AI, use natural language input, and stay focused."
            )
            .tag(2)
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }

    private func onboardingPage(icon: String, title: String, subtitle: String) -> some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: icon)
                .font(.system(size: 72))
                .foregroundStyle(.flowPrimary)

            Text(title)
                .font(.largeTitle)
                .bold()
                .multilineTextAlignment(.center)

            Text(subtitle)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            Spacer()

            Button(action: {
                withAnimation {
                    if currentPage < 2 {
                        currentPage += 1
                    } else {
                        hasCompletedOnboarding = true
                    }
                }
            }) {
                Text(currentPage < 2 ? "Next" : "Get Started")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(width: 200, height: 50)
                    .background(Color.flowPrimary)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            Spacer().frame(height: 40)
        }
    }
}
