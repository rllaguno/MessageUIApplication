//
//  EmailView.swift
//  MessageUIApplication
//
//  Created by Rodrigo Llaguno on 24/11/24.
//

import MessageUI
import SwiftUI

struct EmailView: UIViewControllerRepresentable {
    @Environment(\.dismiss) var dismiss
    var recipient: String
    var subject: String
    var body: String
    var image: UIImage?

    // Coordinator to handle delegate methods
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        var parent: EmailView

        init(parent: EmailView) {
            self.parent = parent
        }

        func mailComposeController(
            _ controller: MFMailComposeViewController,
            didFinishWith result: MFMailComposeResult,
            error: Error?
        ) {
            // Dismiss the mail composer
            controller.dismiss(animated: true)
            parent.dismiss()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let mail = MFMailComposeViewController()
        mail.mailComposeDelegate = context.coordinator
        mail.setToRecipients([recipient])
        mail.setSubject(subject)
        mail.setMessageBody(body, isHTML: false)
        
        if let image = image, let imageData = image.jpegData(compressionQuality: 1.0) {
            mail.addAttachmentData(imageData, mimeType: "image/jpeg", fileName: "Attachment.jpeg")
        }
        
        return mail
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}
}
