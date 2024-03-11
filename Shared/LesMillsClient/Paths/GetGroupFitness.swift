import Foundation
import Get

struct GroupFitnessData: Hashable, Codable {
    let serviceId: String // 4
    let name: String // BodyAttack
    let description: String // Sports-inspired high-energy training.
    let url: String // https://www.lesmills.co.nz/group-fitness/classes/bodyattack
    
    enum CodingKeys: String, CodingKey {
        case serviceId = "crmLesMillsService"
        case name = "@urlName"
        case description = "metaDescription"
        case url = "classUrl"
    }
}

struct GroupFitnessItem: Hashable, Codable {
    let ProductPage: GroupFitnessData
}

extension Paths {
    static func getGroupFitness() -> Request<[GroupFitnessItem]> {
        Request(
            path: "/LesMillsData/GetGroupFitness",
            method: "GET",
            id: "GetGroupFitness"
        )
    }
}
