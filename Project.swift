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
            dependencies: [
                .external(name: "Moya"),
                .external(name: "ComposableArchitecture"),
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
