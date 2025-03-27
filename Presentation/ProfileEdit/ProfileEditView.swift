//
//  SwiftUIView.swift
//  Presentation
//
//  Created by Finley on 12/13/24.
//

import SwiftUI
import PhotosUI
import ComposableArchitecture

struct ProfileEditView: View {
    @Bindable var store: StoreOf<ProfileEditFeature>
    
    var body: some View {
        VStack(spacing: 20) {
            Button(action: {
                store.send(.profileImageButtonTapped(store.photoPermissionDenied))
            }) {
                if let imageData = store.profileImageData,
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "person.circle")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                }
            }
            .actionSheet(isPresented: $store.isShowingActionSheet) {
                ActionSheet(title: Text("프로필사진 변경"), buttons: [
                    .default(Text("라이브러리에서 선택")) {
                        store.send(.imagePickerSourceSelected(.photoLibrary))
                    },
                    .default(Text("사진 찍기")) {
                        store.send(.imagePickerSourceSelected(.camera))
                    },
                    .destructive(Text("기본 이미지로 변경")) {
                        store.send(.imagePickerSourceSelected(nil))
                    },
                    .cancel() {
                        store.send(.profilePhotoChangeCancelled)
                    }
                ])
            }
            .sheet(isPresented: $store.isShowingImagePicker, onDismiss: {
                store.send(.didCancelImagePicking)
            }) {
                if let source = store.selectedImagePickerSource {
                    ImagePicker(
                        sourceType: source == .camera ? .camera : .photoLibrary,
                        onImagePicked: { image in
                            store.send(.didSelectedPhoto(image))
                        },
                        onCancel: {
                            store.send(.didCancelImagePicking)
                        }
                    )
                }
            }
            .alert("접근권한", isPresented: $store.isShowingGuideToEnableLibraryAccess) {
                Button("확인", role: .cancel) {
                    store.send(.guideToEnableLibraryAccessConfirm)
                }
            } message: {
                Text("사진 라이브러리 및 카메라 사용을 위해 설정>앱>카메라/사진 접근권한을 허용해주세요")
            }
            HStack {
                Text("Nickname")
                    .padding(.horizontal, 20)
                TextField("Enter nickname", text: $store.nickname)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal,20)
            }
            Button(action: {
                store.send(.saveButtonTapped)
            }) {
                Text("Save")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding(.top, 16)
                    .padding(.horizontal, 20)
            }
        }
    }
}
