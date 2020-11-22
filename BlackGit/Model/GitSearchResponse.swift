import Foundation

struct GitSearchResponse {
    let totalCount: Int
    let items: [Repository]
}

extension GitSearchResponse: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        totalCount = try values.decode(Int.self, forKey: .totalCount)

        let items = try? values.decode([Repository].self, forKey: .items)
        self.items = items ?? []
    }

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case items
    }
}
