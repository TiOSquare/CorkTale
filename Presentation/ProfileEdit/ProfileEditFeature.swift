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
import AVFoundation

public class ProfileEditFeature: Reducer {

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
        var profileImageString: String = ""
        var profileImageData: Data?
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
        case photoPermissionResult(album: PHAuthorizationStatus, camera: AVAuthorizationStatus)
        case guideToEnableLibraryAccessConfirm
        case changeToBasicProfileImage
        case imagePickerSourceSelected(ImagePickerSource?)
        case profilePhotoChangeCancelled
        case didSelectedPhoto(UIImage)
        case didCancelImagePicking
        case loadSelectPhoto(String, Data)
        case saveButtonTapped
        case loadErrorText(String)
        
        case binding(BindingAction<State>)
    }
    
    public var body: some ReducerOf<ProfileEditFeature> {
        BindingReducer()

        Reduce { state, action in
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
            case .photoPermissionResult(let albumStatus, let cameraStatus):
                if (albumStatus == .authorized || albumStatus == .limited),
                   cameraStatus == .authorized {
                    state.isShowingActionSheet = true
                    state.photoPermissionDenied = false
                } else {
                    state.photoPermissionDenied = true
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
                    state.profileImageData = nil
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
            case .loadSelectPhoto(let imageString, let imageData):
                state.profileImageString = imageString
                state.profileImageData = imageData
                return .none
            case .saveButtonTapped:
                return self.reqProfilePatch(state: state, useCase: self.profileUseCase)
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
            var albumStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
            var cameraStatus = AVCaptureDevice.authorizationStatus(for: .video)
            
            if albumStatus == .notDetermined {
                albumStatus = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
            }
            
            if cameraStatus == .notDetermined {
                let granted = await AVCaptureDevice.requestAccess(for: .video)
                cameraStatus = granted ? .authorized : .denied
            }
            
            await send(.photoPermissionResult(album: albumStatus, camera: cameraStatus))
        }
    }
    
    func reqProfilePatch(state: State, useCase: ProfileUseCase) -> Effect<Action> {
        return .run { send in
            do {
                let profileState = ProfileEdit(nickname: state.nickname, profileImage: state.profileImageString)
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
                await send(.loadSelectPhoto(base64String, imageData))
            }
        }
    }
}
