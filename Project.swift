import ProjectDescription

let project = Project(
    name: "CorkTale",
    targets: [
        .target(
            name: "CorkTale",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.CorkTale",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            sources: ["CorkTale/Sources/**"],
            resources: ["CorkTale/Resources/**"],
            dependencies: []
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
