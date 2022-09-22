import Foundation
import UserNotifications

struct NotificationsService {
    
    static func requestAuthorization(completionHandler: @escaping ((Bool, Error?)->Void) ) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            
            switch settings.authorizationStatus {
            case .notDetermined:
                UNUserNotificationCenter.current().requestAuthorization(options:  [.alert, .sound, .badge]) { result, error in
                    DispatchQueue.main.async {
                        completionHandler(result, error)
                    }
                }
                break
            case .denied:
                let error = NSError(domain: "UNAuthorizationStatus.denied",
                                    code: UNAuthorizationStatus.denied.rawValue,
                                    userInfo: [NSLocalizedDescriptionKey: "Вы отключили отправку и прием уведомлений. Для их включения перейдите в системные настойки."])
                DispatchQueue.main.async {
                    completionHandler(false, error)
                }
                break
            case .authorized:
                DispatchQueue.main.async {
                    completionHandler(true, nil)
                }
            default:
                break
            }
        }
    }
    
    static func scheduleNotification(timeInterval: TimeInterval, title: String, body: String, completionHandler: ((Error?) -> Void)? = nil) {
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            DispatchQueue.main.async {
                completionHandler?(error)
            }
        }
    }

    static func scheduleNotification(date: Date, title: String, body: String, completionHandler: ((Error?) -> Void)? = nil) {
        
        let now = Date()
        
        guard now < date else {
            DispatchQueue.main.async {
                let error = NSError(domain: "UNTimeIntervalNotificationTrigger.add",
                                    code: 0,
                                    userInfo: [NSLocalizedDescriptionKey: "Дата отправки уведомления уже прошла"])
                completionHandler?(error)
            }
            return
        }
        let timeInterval = date.timeIntervalSince(now)
        
        Self.scheduleNotification(timeInterval: timeInterval, title: title, body: body, completionHandler: completionHandler)
    }
    
}
