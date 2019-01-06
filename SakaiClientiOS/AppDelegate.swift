//
//  AppDelegate.swift
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions
        launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UIApplication.shared.setMinimumBackgroundFetchInterval(900)
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

    }

    func applicationWillEnterForeground(_ application: UIApplication) {

    }

    func applicationDidBecomeActive(_ application: UIApplication) {
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
        // Called when the application is about to terminate. Save data if
        // appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication,
                     supportedInterfaceOrientationsFor window: UIWindow?)
        -> UIInterfaceOrientationMask {
            if let _ = self.topViewControllerForRoot(window?.rootViewController) as? Rotatable {
                return .allButUpsideDown
            }
            // Only allow portrait (standard behaviour)
            return .portrait
    }

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
                fatalError("Unresolved error \(error), \(error.userInfo)")
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
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
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
            let navController = storyboard
                .instantiateViewController(withIdentifier: "loginNavigation")
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
}

