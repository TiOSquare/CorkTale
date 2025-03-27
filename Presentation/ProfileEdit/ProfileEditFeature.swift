//
//  ProfileEditFeature.swift
//  Presentation
//
//  Created by Finley on 12/13/24.
//


import Domain
import ComposableArchitecture
import UIKit
import Photos

public struct ProfileEditFeature: Reducer {
    
    private enum CancellableID {
        static let profile = "profile"
    }
    
    public enum ImagePickerSource: Equatable {
        case photoLibrary
        case camera
    }
    
    private let profileUseCase: ProfileUseCase
    
    public init(useCase: ProfileUseCase) {
        self.profileUseCase = useCase
    }
    
    @ObservableState
    public struct State: Equatable {
        var profile: Profile?
        var editProfile: ProfileEdit?
        var nickname: String = ""
        var profileImage: String = ""
        var photoPermissionDenied: Bool = false
        var isShowingGuideToEnableLibraryAccess: Bool = false
        var isShowingActionSheet: Bool = false
        var isShowingImagePicker: Bool = false
        var selectedImagePickerSource: ImagePickerSource?
        var errorText: String?
        
        public init() { }
    }
    
    public enum Action: Equatable, BindableAction {
        case viewWillAppear
        case loadProfile(Profile)
        case profileImageButtonTapped(Bool)
        case photoPermissionResult(PHAuthorizationStatus)
        case guideToEnableLibraryAccessConfirm
        case changeToBasicProfileImage
        case imagePickerSourceSelected(ImagePickerSource?)
        case profilePhotoChangeCancelled
        case didSelectedPhoto(UIImage)
        case didCancelImagePicking
        case loadSelectePhoto(String)
        case saveButtonTapped
        case loadErrorText(String)
        
        case binding(BindingAction<State>)
    }
    
    public func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .viewWillAppear:
            state.isShowingActionSheet = false
            state.isShowingImagePicker = false
            return self.reqProfileLoad(useCase: self.profileUseCase)
        case .loadProfile(let user):
            state.profile = user
            return .none
        case .profileImageButtonTapped(let permission):
            if permission {
                state.isShowingGuideToEnableLibraryAccess = true
                return .none
            } else {
                return self.requestPhotoPermission()
            }
        case .photoPermissionResult(let status):
            switch status {
                case .authorized, .limited:
                    state.isShowingActionSheet = true
                    state.photoPermissionDenied = false
                case .denied, .restricted:
                    state.photoPermissionDenied = true
                default:
                    break
                }
            return .none
        case .guideToEnableLibraryAccessConfirm:
            state.isShowingGuideToEnableLibraryAccess = false
            return .none
        case .changeToBasicProfileImage:
            return .none
        case .imagePickerSourceSelected(let source):
            state.isShowingActionSheet = false
            if let source = source {
                state.selectedImagePickerSource = source
                state.isShowingImagePicker = true
            } else {
                state.profileImage = ""
            }
            return .none
        case .profilePhotoChangeCancelled:
            state.isShowingActionSheet = false
            return .none
        case .didSelectedPhoto(let image):
            state.isShowingImagePicker = false
            return self.didSelectedPhoto(image: image)
        case .didCancelImagePicking:
            state.isShowingImagePicker = false
            return .none
        case .loadSelectePhoto(let imageData):
            state.profileImage = imageData
            return .none
        case .saveButtonTapped:
            //TODO: 수정된 프로필정보 서버전송
            return .none
        case .loadErrorText(let error):
            state.errorText = error
            return .none
            
        case .binding(\.nickname):
            return .none
        case .binding(\.isShowingGuideToEnableLibraryAccess):
            return .none
        case .binding(\.isShowingImagePicker):
            return .none
        case .binding(\.isShowingActionSheet):
            return .none
            
        default:
            return .none
        }
    }
}

extension ProfileEditFeature {

    private func reqProfileLoad(useCase: ProfileUseCase) -> Effect<Action> {
        return .run { send in
            do {
                let profile = try await useCase.getProfile()
                await send(.loadProfile(profile))
            } catch {
                await send(.loadErrorText(error.localizedDescription))
            }
        }
        .cancellable(id: CancellableID.profile, cancelInFlight: true)
    }
    
    private func requestPhotoPermission() -> Effect<Action> {
        .run { send in
            let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
            if status == .notDetermined {
                let newStatus = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
                await send(.photoPermissionResult(newStatus))
            } else {
                await send(.photoPermissionResult(status))
            }
        }
    }
    
    func reqProfilePatch(state: State, useCase: ProfileUseCase) -> Effect<Action> {
        return .run { send in
            do {
                let profileState = ProfileEdit(nickname: state.nickname, profileImage: state.profileImage)
                let profile = try await useCase.updateProfile(profile: profileState)
                await send(.loadProfile(profile))
            } catch {
                await send(.loadErrorText(error.localizedDescription))
            }
        }
        .cancellable(id: CancellableID.profile, cancelInFlight: true)
    }
    
    func didSelectedPhoto(image: UIImage) -> Effect<Action> {
        return .run { send in
            if let imageData = image.jpegData(compressionQuality: 0.8) {
                let base64String = imageData.base64EncodedString()
                await send(.loadSelectePhoto(base64String))
            }
        }
    }
}
