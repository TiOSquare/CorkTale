import ProjectDescription

let targets = ModuleType.allCases.map { $0.target() }

let project = Project(
    name: "CorkTale",
    packages: [
    ],
    settings: .settings(
        configurations: [
            .debug(name: "Debug", xcconfig: "Configs/Debug.xcconfig"),
            .release(name: "Release", xcconfig: "Configs/Release.xcconfig")
        ],
        defaultSettings: .essential
    ),
    targets: targets
)

enum ModuleType: String, CaseIterable {
    case app = "App"
    case presentation = "Presentation"
    case domain = "Domain"
    case data = "Data"
    case shared = "Shared"
    case appTests = "AppTests"
    
    private static let baseBundleId: String = "io.tuist.CorkTale"
    
    var name: String {
        return self.rawValue
    }
    
    var destinations: Destinations {
        switch self {
        default:
            return .iOS
        }
    }
    
    var product: Product {
        switch self {
        case .app:
            return .app
            
        case .appTests:
            return .unitTests
            
        default:
            return .framework
        }
    }
    
    var bundleId: String {
        switch self {
        case .app:
            return ModuleType.baseBundleId
            
        case .appTests:
            return ModuleType.baseBundleId + "Tests"
            
        default:
            return ModuleType.baseBundleId + "." + self.rawValue
        }
    }
    
    var deploymentTargets: ProjectDescription.DeploymentTargets {
        switch self {
        default:
            return .iOS("17.0")
        }
    }
    
    var hasResources: Bool {
        switch self {
        case .app, .shared:
            return true
            
        default:
            return false
        }
    }
    
    var sources: SourceFilesList {
        let sufix = hasResources ? "/Sources/**" : "/**"
        
        switch self {
        case .appTests:
            return ["Tests/**"]
            
        default:
            return ["\(self.name)\(sufix)"]
        }
    }
    
    var infoPlist: InfoPlist {
        switch self {
        case .app: return .extendingDefault(with: [
            "NSCameraUsageDescription": "This app requires access to the camera to take photos.",
            "NSLocationWhenInUseUsageDescription": "This app requires!!",
            "UIApplicationSceneManifest": [
                "UIApplicationSupportsMultipleScenes": false,
                "UISceneConfigurations": [
                    "UIWindowSceneSessionRoleApplication": [
                        [
                            "UISceneConfigurationName": "Default Configuration",
                        ]
                    ]
                ]
            ],
            "UILaunchStoryboardName": "LaunchScreen",
            "BASE_URL": "$(BASE_URL)"
        ])
            
        default:
            return .default
        }
    }
    
    var resources: ResourceFileElements? {
        guard hasResources else { return nil }
        
        let resources = self.name + "/Resources/**"
        return ["\(resources)"]
    }
    
    var targetDependencies: [TargetDependency] {
        switch self {
        case .app:
            return [
                .target(name: ModuleType.presentation.name),
                .target(name: ModuleType.domain.name),
                .target(name: ModuleType.data.name),
                .target(name: ModuleType.shared.name)
            ]
            
        case .presentation:
            return [
                .external(name: "ComposableArchitecture"),
                .target(name: ModuleType.domain.name),
                .target(name: ModuleType.shared.name)
            ]
            
        case .domain:
            return [
            ]
            
        case .data:
            return [
                .external(name: "CombineMoya"),
                .target(name: ModuleType.domain.name),
                .target(name: ModuleType.shared.name)
            ]
            
        case .shared:
            return [
            ]
            
        case .appTests:
            return [
                .target(name: ModuleType.app.name)
            ]
        }
    }
    
    func target() -> Target {
        return .target(
            name: self.name,
            destinations: self.destinations,
            product: self.product,
            bundleId: self.bundleId,
            deploymentTargets: self.deploymentTargets,
            infoPlist: self.infoPlist,
            sources: self.sources,
            resources: self.resources,
            dependencies: self.targetDependencies
        )
    }
}
