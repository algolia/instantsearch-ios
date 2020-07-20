//
//  MultiSourceReloadNotifier.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 10/12/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public class MultiSourceReloadNotifier {

  public let target: Reloadable

  private var resultsUpdatableWrappers: [ResultsUpdatableNotificationWrapper] = []

  public init(target: Reloadable) {
    self.target = target
    self.resultsUpdatableWrappers = []
  }

  public func register<Updatable: ResultUpdatable>(_ updatable: Updatable) {
    let wrapper = ResultsUpdatableNotificationWrapper(updatable: updatable)
    wrapper.connect()
    resultsUpdatableWrappers.append(wrapper)
  }

  public func notifyReload() {
    let group = DispatchGroup()
    for updatable in resultsUpdatableWrappers {
      group.enter()
      updatable.onResultsUpdated.subscribeOnce(with: self) { (_, _) in
        group.leave()
      }
    }
    group.notify(queue: .main) { [weak self] in
      self?.target.reload()
    }
  }

}

private class ResultsUpdatableNotificationWrapper: Connection {

  public var onResultsUpdated: Observer<Void>

  private var subscribe: () -> Void
  private var unsubscribe: () -> Void

  public init<Updatable: ResultUpdatable>(updatable: Updatable) {
    onResultsUpdated = .init()
    subscribe = {}
    unsubscribe = {}
    subscribe = { [weak self] in
      guard let wrapper = self else { return }
      updatable.onResultsUpdated.subscribe(with: wrapper) { (wrapper, _) in
        wrapper.onResultsUpdated.fire(())
      }
    }
    unsubscribe = { [weak self] in
      guard let wrapper = self else { return }
      updatable.onResultsUpdated.cancelSubscription(for: wrapper)
    }
  }

  public func connect() {
    subscribe()
  }

  public func disconnect() {
    unsubscribe()
  }

}
