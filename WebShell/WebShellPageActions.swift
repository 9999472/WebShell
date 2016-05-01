//
//  WebShellPageActions.swift
//  WebShell
//
//  Created by Wesley de Groot on 31-01-16.
//  Copyright © 2016 RandyLu. All rights reserved.
//

import Foundation
import AppKit

extension ViewController {
	func addObservers() {
		// add menu action observers
		let observers = ["goHome", "reload", "copyUrl", "clearNotificationCount", "printThisPage"]

		for observer in observers {
			NSNotificationCenter.defaultCenter().addObserver(self, selector: NSSelectorFromString(observer), name: observer, object: nil)
		}
	}

	func goHome() {
		loadUrl((WebShellSettings["url"] as? String)!)
	}

	func reload() {
		let currentUrl: String = (mainWebview.mainFrame.dataSource?.request.URL?.absoluteString)!
		loadUrl(currentUrl)
	}

	func copyUrl() {
		let currentUrl: String = (mainWebview.mainFrame.dataSource?.request.URL?.absoluteString)!
		let clipboard: NSPasteboard = NSPasteboard.generalPasteboard()
		clipboard.clearContents()

		clipboard.setString(currentUrl, forType: NSStringPboardType)
	}

	func initSettings() {
		// controll the progress bar
		if (!(WebShellSettings["showLoadingBar"] as? Bool)!) {
			progressBar.hidden = true // @wdg: Better progress indicator | Issue: #37
		}

		// @wdg Add Custom useragent support
		// Issue: #52
		if ((WebShellSettings["useragent"] as! String).lowercaseString == "default") {
			var UA: String = NSBundle.mainBundle().infoDictionary!["CFBundleName"] as! String
			UA = UA.stringByAppendingString("/")
			UA = UA.stringByAppendingString(NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String)
			UA = UA.stringByAppendingString(" based on Safari/AppleWebKit (KHTML, like Gecko)")

			NSUserDefaults.standardUserDefaults().registerDefaults(["UserAgent": UA]) // For iOS
			mainWebview.customUserAgent = UA // For Mac OS X
		} else {
			let UA: String = WebShellSettings["useragent"] as! String
			NSUserDefaults.standardUserDefaults().registerDefaults(["UserAgent": UA]) // For iOS
			mainWebview.customUserAgent = UA // For Mac OS X
		}

		// set launching text
		launchingLabel.stringValue = (WebShellSettings["launchingText"] as? String)!
	}

	func initWindow() {
		firstAppear = false

		// set window size
		var frame: NSRect = mainWindow.frame

		let WIDTH: CGFloat = CGFloat(WebShellSettings["initialWindowWidth"] as! Int),
			HEIGHT: CGFloat = CGFloat(WebShellSettings["initialWindowHeight"] as! Int)

		frame.size.width = WIDTH
		frame.size.height = HEIGHT

		// @wdg Fixed screen position (now it centers)
		// Issue: #19
		// Note: do not use HEIGHT, WIDTH for some strange reason the window will be positioned 25px from bottom!
		let ScreenHeight: CGFloat = (NSScreen.mainScreen()?.frame.size.width)!,
			WindowHeight: CGFloat = CGFloat(WebShellSettings["initialWindowWidth"] as! Int), // do not use HEIGHT!
		ScreenWidth: CGFloat = (NSScreen.mainScreen()?.frame.size.height)!,
			WindowWidth: CGFloat = CGFloat(WebShellSettings["initialWindowHeight"] as! Int) // do not use WIDTH!
		frame.origin.x = (ScreenHeight / 2 - WindowHeight / 2)
		frame.origin.y = (ScreenWidth / 2 - WindowWidth / 2)

		// @froge-xyz Fixed initial window size
		// Issue: #1, #45
		mainWindow.window?.setFrame(frame, display: true)
		// defims Fixed the initial window size.
		mainWindow.frame = frame

		// set window title
		mainWindow.window?.title = WebShellSettings["title"] as! String

		// Force some preferences before loading...
		mainWebview.preferences.javaScriptEnabled = true
		mainWebview.preferences.javaScriptCanOpenWindowsAutomatically = true
		mainWebview.preferences.plugInsEnabled = true
	}

	func loadUrl(url: String) {
		if ((WebShellSettings["showLoadingBar"] as? Bool)!) {
			progressBar.hidden = false
			progressBar.startAnimation(self)
			progressBar.maxValue = 100;
			progressBar.minValue = 1;
			progressBar.incrementBy(24)
		}
		let URL = NSURL(string: url)
		mainWebview.mainFrame.loadRequest(NSURLRequest(URL: URL!))
	}

	// @wdg Add Print Support
	// Issue: #39
	func printThisPage(Sender: AnyObject? = "") -> Void {
		let url = mainWebview.mainFrame.dataSource?.request?.URL?.absoluteString

		let operation: NSPrintOperation = NSPrintOperation.init(view: mainWebview)
		operation.jobTitle = "Printing \(url!)"

		// If want to print landscape
		operation.printInfo.orientation = NSPaperOrientation.Landscape
		operation.printInfo.scalingFactor = 0.7

		if operation.runOperation() {
			print("Printed?")
		}
	}
}