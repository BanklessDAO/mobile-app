//
//  Created with ♥ by BanklessDAO contributors on 2021-12-02.
//  Copyright (C) 2021 BanklessDAO.

//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU Affero General Public License as
//  published by the Free Software Foundation, either version 3 of the
//  License, or (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU Affero General Public License for more details.
//
//  You should have received a copy of the GNU Affero General Public License
//  along with this program.  If not, see https://www.gnu.org/licenses/.
//
    

import Foundation
import Sentry

final class SentryErrorReporter: ErrorReporter {
    func start() {
        SentrySDK.start { options in
            options.dsn = Environment.sentryDSN
#if DEBUG
            options.debug = true
            options.tracesSampleRate = 1.0
#endif
            options.tracesSampleRate = 0.1
            
            options.onCrashedLastRun = { event in
                self.collectFeedback(for: .crash(id: event.eventId))
            }
        }
    }
    
    func report(
        error: Error,
        beforeFeedback: ((@escaping () -> Void) -> Void)? = nil
    ) {
        let errorId = SentrySDK.capture(error: error) { scope in
            scope.setExtra(value: error.localizedDescription, key: "description")
        }
        
        guard let beforeFeedback = beforeFeedback else {
            collectFeedback(for: .error(id: errorId))
            return
        }
        
        beforeFeedback {
            self.collectFeedback(for: .error(id: errorId))
        }
    }
}

extension SentryErrorReporter {
    private static let feedbackForm = (
        title: (
            crash: NSLocalizedString(
                "issue.crash.feedback.title",
                value: "Crash Feedback",
                comment: ""
            ),
            error: NSLocalizedString(
                "issue.error.feedback.title",
                value: "Error Feedback",
                comment: ""
            )
        ),
        message: (
            crash: NSLocalizedString(
                "issue.crash.feedback.message",
                value: "Please tell us what made the app crash the last time",
                comment: ""
            ),
            error: NSLocalizedString(
                "issue.error.feedback.message",
                value: "Please tell us where have you encountered this error",
                comment: ""
            )
        )
    )
    
    enum Issue {
        case crash(id: SentryId)
        case error(id: SentryId)
    }
    
    private func collectFeedback(for issue: Issue) {
        let title: String
        let message: String
        let userFeedback: UserFeedback
        
        switch issue {
            
        case .crash(let id):
            title = SentryErrorReporter.feedbackForm.title.crash
            message = SentryErrorReporter.feedbackForm.message.crash
            userFeedback = UserFeedback(eventId: id)
        case .error(let id):
            title = SentryErrorReporter.feedbackForm.title.error
            message = SentryErrorReporter.feedbackForm.message.error
            userFeedback = UserFeedback(eventId: id)
        }
        
        DispatchQueue.main.async {
            let feedbackAlert = UIAlertController(
                title: title,
                message: message,
                preferredStyle: .alert
            )
            
            feedbackAlert.addTextField(configurationHandler: { _ in })
            
            feedbackAlert.addAction(
                .init(
                    title: Localization.Common.Actions.save,
                    style: .default,
                    handler: { _ in
                        guard let input = feedbackAlert.textFields?.first?.text, !input.isEmpty else {
                            return
                        }
                        
                        userFeedback.comments = input
                        SentrySDK.capture(userFeedback: userFeedback)
                    }
                )
            )
            
            (UIApplication.shared.delegate as! AppDelegate)
                .applicationCoordinator.navigationController?
                .present(feedbackAlert, animated: true)
        }
    }
}
