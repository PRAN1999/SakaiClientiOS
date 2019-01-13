//
//  AppDelegate.swift
//

import UIKit
import CoreData
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        Fabric.with([Crashlytics.self])

        UIApplication.shared.setMinimumBackgroundFetchInterval(900)

        // Inject the loginService into the HomeController so it can perform
        // a login flow if necessary
        let root = window?.rootViewController as? UITabBarController
        root?.childViewControllers.forEach { child in
            let nav = child as? UINavigationController
            if let home = nav?.viewControllers.first as? HomeController {
                home.loginService = RequestManager.shared
            }
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {

    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Free up documents and url cache to keep app footprint light
        URLCache.shared.removeAllCachedResponses()
        clearDocumentsDirectory()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {

    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Since the cookies will expire after a certain amount of time,
        // they should be checked to see if they are still valid every time
        // the app comes onto the screen
        RequestManager.shared.validateLoggedInStatus(
            onSuccess: {
            RequestManager.shared.loadCookiesIntoUserDefaults()
        }, onFailure: { [weak self] _ in
            if RequestManager.shared.isLoggedIn {
                self?.logout()
            }
        })
    }

    func applicationWillTerminate(_ application: UIApplication) {

    }
    
    func application(_ application: UIApplication,
                     supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return .all
        }

        // If any ViewControllers conform to Rotatable, they will be allowed
        // to rotate
        if let _ = self.topViewControllerForRoot(window?.rootViewController) as? Rotatable {
            return .allButUpsideDown
        }
        // Only allow portrait (standard behaviour)
        return .portrait
    }

    /// Recursively retrieve the top level view controller that is presented
    /// on the screen. This means that neither a UITabBarController or
    /// UINavigationController can be a top level controller. Any view
    /// controller that is presenting another controller also is not a top
    /// level controller
    ///
    /// - Parameter rootViewController: the root view controller
    /// - Returns: the current top-level controller for the root
    private func topViewControllerForRoot(_ rootViewController: UIViewController?)
        -> UIViewController? {
        if (rootViewController == nil) { return nil }
        if let selected = (rootViewController as? UITabBarController)?.selectedViewController {
            return topViewControllerForRoot(selected)
        } else if
            let visible = (rootViewController as? UINavigationController)?.visibleViewController {
            return topViewControllerForRoot(visible)
        } else if let presented = rootViewController?.presentedViewController {
            return topViewControllerForRoot(presented)
        }
        return rootViewController
    }

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are
         legitimate error conditions that could cause the creation of the
         store to fail.
         */
        let container = NSPersistentContainer(name: "Temp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print(error)
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // Refresh the cookies if they are available and load them into
        // User Defaults to keep the session alive
        if RequestManager.shared.loadCookiesFromUserDefaults() {
            RequestManager.shared.validateLoggedInStatus(onSuccess: {
                RequestManager.shared.refreshCookies()
                completionHandler(.newData)
            }) { err in
                UserDefaults.standard.set(nil, forKey: RequestManager.savedCookiesKey)
                completionHandler(.failed)
            }
        } else {
            completionHandler(.noData)
        }
    }

    func logout() {
        RequestManager.shared.reset()
        SakaiService.shared.reset()
        let rootController = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController
        rootController?.dismiss(animated: false, completion: nil)
        rootController?.selectedIndex = 0
        let navigationControllers = rootController?.viewControllers as? [UINavigationController]
        navigationControllers?.forEach { nav in
            nav.popToRootViewController(animated: false)
        }
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        guard
            let navController = storyboard.instantiateViewController(withIdentifier: "loginNavigation")
                as? UINavigationController
            else {
                return
        }
        guard
            let loginController = navController.viewControllers.first as? LoginController
            else {
                return
        }
        loginController.onLogin = {
            DispatchQueue.main.async {
                rootController?.dismiss(animated: true, completion: nil)
                // Reload the HomeController because the source of truth
                // needs to be reset in the app
                let action = ReloadActions.reloadHome.rawValue
                NotificationCenter.default.post(
                    name: NSNotification.Name(rawValue: action),
                    object: nil,
                    userInfo: nil
                )
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
            rootController?.present(navController, animated: true, completion: nil)
        })
    }

    private func clearDocumentsDirectory() {
        do {
            guard
                let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
                else {
                    return
            }
            let documentDirectory = try FileManager.default.contentsOfDirectory(atPath: documentsUrl.path)
            try documentDirectory.forEach { file in
                let fileUrl = documentsUrl.appendingPathComponent(file)
                try FileManager.default.removeItem(atPath: fileUrl.path)
            }
        } catch let err {
            // TODO handle appropriately
            print(err)
            return
        }
    }
}

