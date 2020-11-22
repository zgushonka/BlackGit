import Foundation

struct Repository {
    let id: Int
    let name: String
    let details: String?
    let ownerImageURL: URL?
}

extension Repository: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        details = try? values.decode(String.self, forKey: .details)

        let owner = try values.nestedContainer(keyedBy: OwnerKeys.self, forKey: .owner)
        ownerImageURL = try? owner.decode(URL.self, forKey: .avatarUrl)
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case details = "description"
        case owner
    }

    enum OwnerKeys: String, CodingKey {
        case avatarUrl = "avatar_url"
    }
}
