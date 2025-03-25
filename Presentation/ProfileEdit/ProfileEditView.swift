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
        WithPerceptionTracking {
            VStack(spacing: 20) {
                Button(action: {
                    store.send(.profileImageButtonTapped)
                }) {
                    if let data = Data(base64Encoded: store.profileImage),
                       let uiImage = UIImage(data: data) {
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
                .sheet(isPresented: $store.isShowingImagePicker) {
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
}
