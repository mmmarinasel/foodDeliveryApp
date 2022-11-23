import Foundation

class ProfileModel {
    private var saveManager: ISaveManager?
    
    public init() {
        self.saveManager = SaveProfileDataManager()
    }
    
    public func save(profileData: ProfileData, _ completion: @escaping ([Error]) -> Void) {
        self.saveManager?.save(profileData: profileData, completion)
    }
    
    public func load(_ completion: @escaping (ProfileData) -> Void) {
        self.saveManager?.load(completion)
    }
}
