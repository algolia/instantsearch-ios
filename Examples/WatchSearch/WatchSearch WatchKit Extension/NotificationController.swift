//
//  NotificationController.swift
//  WatchSearch WatchKit Extension
//
//  Created by Vladislav Fitc on 20/05/2022.
//

import SwiftUI
import UserNotifications
import WatchKit

class NotificationController: WKUserNotificationHostingController<NotificationView> {
  override var body: NotificationView {
    return NotificationView()
  }

  override func didReceive(_: UNNotification) {
    // This method is called when a notification needs to be presented.
    // Implement it if you use a dynamic notification interface.
    // Populate your dynamic notification interface as quickly as possible.
  }
}
