//
//  ProfileEditFeature.swift
//  Presentation
//
//  Created by Finley on 12/13/24.
//


import Domain
import ComposableArchitecture
import UIKit

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
        var isShowingActionSheet: Bool = false
        var isShowingImagePicker: Bool = false
        var selectedImagePickerSource: ImagePickerSource?
        var errorText: String?
        
        public init() { }
    }
    
    public enum Action: Equatable, BindableAction {
        case viewWillAppear
        case loadProfile(Profile)
        case profileImageButtonTapped
        case selectedCamera
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
            //TODO: 프로필정보(닉네임, 프로필이미지) 요청
            state.isShowingActionSheet = false
            state.isShowingImagePicker = false
            return self.reqProfileLoad(useCase: self.profileUseCase)
        case .loadProfile(let user):
            state.profile = user
            return .none
        case .profileImageButtonTapped:
            state.isShowingActionSheet = true
            return .none
        case .selectedCamera:
            state.isShowingImagePicker = true
            return .none
        case .changeToBasicProfileImage:
            return .none
        case .imagePickerSourceSelected(let source):
            if let source = source {
                state.selectedImagePickerSource = source
                state.isShowingActionSheet = false
                state.isShowingImagePicker = true
            } else {
                state.isShowingActionSheet = false
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
