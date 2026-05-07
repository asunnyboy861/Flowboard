import SwiftUI

struct ContactSupportView: View {
    @State private var feedbackText = ""
    @State private var email = ""
    @State private var isSending = false
    @State private var showSuccess = false
    @State private var showError = false

    var body: some View {
        Form {
            Section("Contact Information") {
                TextField("Email (optional)", text: $email)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
            }

            Section("Feedback") {
                TextEditor(text: $feedbackText)
                    .frame(minHeight: 120)
            }

            Section {
                Button(action: sendFeedback) {
                    HStack {
                        if isSending {
                            ProgressView()
                        }
                        Text("Send Feedback")
                    }
                }
                .disabled(feedbackText.isEmpty || isSending)
            }
        }
        .navigationTitle("Contact Support")
        .alert("Thank you!", isPresented: $showSuccess) {
            Button("OK") { feedbackText = ""; email = "" }
        } message: {
            Text("Your feedback has been sent successfully.")
        }
        .alert("Error", isPresented: $showError) {
            Button("OK") {}
        } message: {
            Text("Failed to send feedback. Please try again later.")
        }
    }

    private func sendFeedback() {
        isSending = true
        let payload: [String: String] = [
            "email": email,
            "feedback": feedbackText,
            "app": "Flowboard",
            "version": Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        ]

        guard let url = URL(string: "https://formspree.io/f/xpwdjkql") else {
            isSending = false
            showError = true
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: payload)
        } catch {
            isSending = false
            showError = true
            return
        }

        URLSession.shared.dataTask(with: request) { _, response, error in
            DispatchQueue.main.async {
                isSending = false
                if let error {
                    print("Feedback error: \(error)")
                    showError = true
                } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    showSuccess = true
                } else {
                    showError = true
                }
            }
        }.resume()
    }
}
