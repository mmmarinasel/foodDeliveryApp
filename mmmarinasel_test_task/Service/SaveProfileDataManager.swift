import Foundation
import UIKit

protocol ISaveManager {
    func save(profileData: ProfileData, _ completion: @escaping ([Error]) -> Void)
    func load(_ completion: @escaping (ProfileData) -> Void)
    
    func saveImage(image: UIImage)
    func loadImage() -> UIImage?
}

class SaveProfileDataManager: ISaveManager {

    let queue: DispatchQueue
    let imgQueue: DispatchQueue
    
    let fileName: String = "ProfileData.json"
    let imgFileName: String = "ProfileImage"
    
    init() {
        self.queue = DispatchQueue(label: "ProfileInfo",
                                   qos: .userInitiated,
                                   attributes: .concurrent)
        self.imgQueue = DispatchQueue(label: "ImgDownloader",
                                      qos: .userInitiated,
                                      attributes: .concurrent)
    }
    
    func save(profileData: ProfileData, _ completion: @escaping ([Error]) -> Void) {
        self.queue.async {
            var jsonString: String = ""
            do {
                let jsonData = try JSONEncoder().encode(profileData)
                jsonString = String(data: jsonData, encoding: .utf8) ?? "{}"
                print(jsonString)
            } catch {
                print(error.localizedDescription)
                return
            }
            if let documentDirectory = FileManager.default.urls(for: .documentDirectory,
                                                                in: .userDomainMask).first {
                let pathWithFilename = documentDirectory.appending(path: self.fileName)
                do {
                    try jsonString.write(to: pathWithFilename,
                                      atomically: true,
                                      encoding: .utf8)
                    print("saved to: \(documentDirectory)")
                    completion([])
                } catch {
                    print(error.localizedDescription)
                    var err = [Error]()
                    err.append(error)
                    completion(err)
                }
            }
        }
    }
    
    func load(_ completion: @escaping (ProfileData) -> Void) {
        self.queue.async {
            var jsonString: String = ""
            if let documentDirectory = FileManager.default.urls(for: .documentDirectory,
                                                                in: .userDomainMask).first {
                let pathWithFilename = documentDirectory.appendingPathComponent(self.fileName)
                do {
                    jsonString = try String(contentsOf: pathWithFilename, encoding: .utf8)
                } catch {
                    print("load error from: \(documentDirectory)")
                    return
                }
            }
            do {
                let jsonData = Data(jsonString.utf8)
                let decodedData = try JSONDecoder().decode(ProfileData.self, from: jsonData)
                completion(decodedData)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func saveImage(image: UIImage) {
        self.imgQueue.async {
            guard let documentDirectory = FileManager.default.urls(for: .documentDirectory,
                                                                   in: .userDomainMask).first
            else { return }
            let fileURL = documentDirectory.appending(path: self.imgFileName)
            guard let data = image.jpegData(compressionQuality: 1) else { return }
            
            if FileManager.default.fileExists(atPath: fileURL.path()) {
                do {
                    try FileManager.default.removeItem(atPath: fileURL.path())
                    print("Removed old image")
                } catch let removeError {
                    print("couldn't remove file at path", removeError)
                }
            }
            do {
                try data.write(to: fileURL)
            } catch let error {
                print("error saving file with error", error)
            }
        }
    }
    
    func loadImage() -> UIImage? {
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory,
                                                        userDomainMask,
                                                        true)
        if let dirPath = paths.first {
            let imageUrl = URL(filePath: dirPath).appendingPathComponent(self.imgFileName)
            let image = UIImage(contentsOfFile: imageUrl.path)
            return image
        }
        return nil
    }
}
