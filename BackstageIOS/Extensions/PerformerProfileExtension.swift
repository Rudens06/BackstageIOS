//
//  PerformerProfileExtension.swift
//  BackstageIOS
//
//  Created by Reinis Rudens on 17/05/2025.
//

import Foundation

extension PerformerProfile {
    static var previewProfile: PerformerProfile {
        PerformerProfile(
            id: "12fwsd3",
            userId: "user456",
            name: "Nova Koma",
            description: "Lokāka latviešu garāžroka grupa",
            memberCount: 4,
            genres: ["Garāžroks", "Alternatīvais Roks", "R"],
            contactEmail: "nova@koma.com",
            contactPhone: "+37126453685",
            createdAt: Date().timeIntervalSince1970 - 86400,
            updatedAt: Date().timeIntervalSince1970
        )
    }
}
