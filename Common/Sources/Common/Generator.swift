import Foundation

public enum Generate {
    public static func Id(from url: String) -> Int {
        if let idString = URL(string: url)?.lastPathComponent, let id = Int(idString) {
            return id
        }
        return 0
    }

    public static func imageURL(from id: Int) -> URL? {
        let formatId = String(format: "%03d", id)
        let imageUrl = "https://raw.githubusercontent.com/fanzeyi/pokemon.json/master/images/\(formatId).png"
        return URL(string: imageUrl)
    }
    
    public static func generationImageURL(id: Int) -> URL? {
        let formatId = String(format: "%03d", id)
        let imageUrl = "https://raw.githubusercontent.com/fanzeyi/pokemon.json/master/images/\(formatId).png"
        return URL(string: imageUrl)
    }
    
    public static func generationImagePath(from url: URL?) -> String {
        guard let path = url?.path else { return "" }

        return path
    }
}
