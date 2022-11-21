import Foundation

protocol ISaveData {
    func saveToJson()
    func getDocumentDirectory(_ jsonStr: String)
}

class SaveProfileDataManager: ISaveData {
    
    private var profileData: ProfileData
    let fileName: String = "ProfileData.json"
    
    public init(data: ProfileData) {
        self.profileData = data
    }
    
    func saveToJson() {
        var jsonString: String = ""
        do {
            let jsonData = try JSONEncoder().encode(self.profileData)
            jsonString = String(data: jsonData, encoding: .utf8) ?? "{}"
            print(jsonString)
        } catch {
            print(error.localizedDescription)
            return
        }
        getDocumentDirectory(jsonString)
    }
    
    func getDocumentDirectory(_ jsonStr: String) {
        if let documentDirectory = FileManager.default.urls(for: .documentDirectory,
                                                            in: .userDomainMask).first {
            let pathWithFilename = documentDirectory.appending(path: self.fileName)
            do {
                try jsonStr.write(to: pathWithFilename,
                                  atomically: true,
                                  encoding: .utf8)
                print("saved to: \(documentDirectory)")
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
