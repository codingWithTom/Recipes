//
//  ShareViewController.swift
//  RecipesAppShare
//
//  Created by Tomas Trujillo on 2026-05-10.
//

import UIKit
import Social
import SwiftUI

final class ShareViewController: SLComposeServiceViewController {
  
  override func isContentValid() -> Bool {
    // Do validation of contentText and/or NSExtensionContext attachments here
    return true
  }
  
  override func didSelectPost() {
    // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
    // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
    self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
  }
  
  override func configurationItems() -> [Any]! {
    // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
    return []
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    guard
      let item = extensionContext?.inputItems.first as? NSExtensionItem,
      let provider = item.attachments?.first(where: {
        $0.hasItemConformingToTypeIdentifier("public.url")
      })
    else {
      close()
      return
    }
    
    provider.loadItem(forTypeIdentifier: "public.url", options: nil) { [weak self] item, _ in
      guard let url = item as? URL else {
        Task { @MainActor in
          self?.close()
        }
        return
      }
      Task { @MainActor in
        self?.present(with: url)
      }
    }
  }
  
  @MainActor
  private func present(with url: URL) {
    let view = ShareView(url: url) { [weak self] in
      self?.close()
    }
    let host = UIHostingController(rootView: view)
    addChild(host)
    host.view.frame = self.view.bounds
    host.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    self.view.addSubview(host.view)
    host.didMove(toParent: self)
  }
  
  private func close() {
    extensionContext?.completeRequest(returningItems: nil)
  }
  
}
