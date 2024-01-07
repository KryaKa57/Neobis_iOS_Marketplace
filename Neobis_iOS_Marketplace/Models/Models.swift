//
//  Models.swift
//  Neobis_iOS_Marketplace
//
//  Created by Alisher on 02.01.2024.
//

import Foundation

struct CustomRegister: Codable {
    let username: String
    let email: String
    let password1: String
    let password2: String
}

struct CustomUserDetails: Codable {
    let pk: Int
    let username: String
    let email: String
    let first_name: String?
    let last_name: String?
    let DOB: String?
    let phone_number: String?
    let profile_image: String?
    let token: String
}

struct JWT: Codable {
    let access_token: String
    let refresh_token: String
    let user: UserDetails
}

struct UserDetails: Codable {
    let pk: Int
    let username: String
    let email: String
    let first_name: String?
    let last_name: String?
}

struct Login: Codable {
    let username: String
    let email: String?
    let password: String
}

struct PasswordChange: Codable {
    let new_password1: String
    let new_password2: String
}

struct PasswordReset: Codable {
    let email: String
}

struct ResendEmailVerification: Codable {
    let email: String
}

struct RestAuthDetail: Codable {
    let email: String
}

struct PasswordResetConfirm: Codable {
    let new_password1: String
    let new_password2: String
    let uid: String
    let token: String
}

struct PatchedCustomUserDetails: Codable {
    let pk: Int
    let username: String
    let email: String
    let first_name: String?
    let last_name: String?
    let DOB: String?
    let phone_number: String?
    let profile_image: String?
    let token: String
}

struct PatchedProduct: Codable {
    let id: String
    let readOnly: Bool
    let title: String
    let short_description: String
    let description: String
    let price: Int
    let product_image: String
    let likes: String
    let likes_count: String
}

struct PatchedUserDetails: Codable {
    let pk: Int
    let username: String
    let email: String
    let first_name: String?
    let last_name: String?
}

struct ProductDetails: Codable {
    let title: String
    let short_description: String
    let description: String
    let price: Int
    let product_image: Data?
}

struct Product: Codable {
    let id: Int
    let title: String
    let short_description: String
    let description: String
    let price: Int
    let product_image: String?
    let likes: [Int]
    let likes_count: Int
}

struct Register: Codable {
    let username: String
    let email: String
    let password1: String
    let password2: String
}

struct TokenObtainPair: Codable {
    let username: String
    let password: String
    let access: String
    let refresh: String
}

struct TokenRefresh: Codable {
    let access: String
    let refresh: String
}

struct TokenVerify: Codable {
    let token: String
}

struct VerfiyEmail: Codable {
    let key: String
}
