import Foundation

class UserState: ObservableObject {
    var userId: String = ""
    var username: String = ""
    var userAvatarKey: String {
        userId + ".jpg"
    }
}
