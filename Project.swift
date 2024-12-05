import ProjectDescription

let project = Project(
    name: "CorkTale",
    packages: [
    ],
    targets: [
        .target(
            name: "CorkTale",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.CorkTale",
            deploymentTargets: .iOS("16.0"),
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            sources: ["CorkTale/App/Sources/**"],
            resources: ["CorkTale/App/Resources/**"],
            dependencies: [
                .external(name: "ComposableArchitecture"),
                .target(name: "Presentation")
            ]
        ),
        .target(
            name: "Presentation",
            destinations: .iOS,
            product: .framework,
            bundleId: "io.tuist.CorkTale.Presentation",
            deploymentTargets: .iOS("16.0"),
            sources: ["CorkTale/Presentation/**"],
            dependencies: [
                .external(name: "Moya"),
                .target(name: "Domain")
            ]
        ),
        .target(
            name: "Domain",
            destinations: .iOS,
            product: .framework,
            bundleId: "io.tuist.CorkTale.Domain",
            deploymentTargets: .iOS("16.0"),
            sources: ["CorkTale/Domain/**"],
            dependencies: [
                .external(name: "Moya"),
                .target(name: "Data")
            ]
        ),
        .target(
            name: "Data",
            destinations: .iOS,
            product: .framework,
            bundleId: "io.tuist.CorkTale.Data",
            deploymentTargets: .iOS("16.0"),
            sources: ["CorkTale/Data/**"],
            dependencies: [
                .external(name: "Moya")
            ]
        ),
        .target(
            name: "CorkTaleTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.CorkTaleTests",
            infoPlist: .default,
            sources: ["CorkTale/Tests/**"],
            resources: [],
            dependencies: [.target(name: "CorkTale")]
        ),
    ]
)

public enum Module: String, CaseIterable {
    case app = "App"
    case data = "Data"
    case core = "Core"
    case designSystem = "DesignSystem"
    case domain = "Domain"
    case feature = "Feature"
    
    public var name: String {
        return self.rawValue
    }
    
    public var destinations: Destinations {
        return .iOS
    }
    
    public var product: Product {
        return .app
    }
    
    public var bundleId: String {
        return ""
    }
}
