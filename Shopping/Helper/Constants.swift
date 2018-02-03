//
//  Constants.swift
//  Shopping
//
//  Created by Naggar on 11/6/17.
//  Copyright © 2017 Haseboty. All rights reserved.
//

import Foundation


struct Constants {
    
    struct UserData {
        
        static let logged = "logged"
        static let clientID = "clientID"
        static let password = "password"
        static let username = "username"
        static let email = "email"
        static let userID = "userID"
        static let loggedFaceOrGoogle = "loggedFaceOrGoogle"
    }
    
    
    struct StoryBoardID {
        static let ChooseSignUpVC = "ChooseSignUpVC"
        static let loginVC = "loginVC"
        static let signUpVC = "signUpVC"
        static let AddProductVC = "AddProductVC"
        static let PopUpMenuVC = "PopUpMenuVC"
        static let HomeTabBar = "homeTabBar"
        static let productProfileNav = "productProfileNav"
        static let commentNav = "commentNav"
        static let ProfileSettingNav = "ProfileSettingNav"
        static let ItemFavNav = "ItemFavNav"
        static let ClientProfileNav = "ClientProfileNav"
        static let AlertVC = "AlertVC"
        static let FollowersNav = "FollowersNav"
        static let ReviewNav = "ReviewNav"
        static let RateVC = "RateVC"
        static let MessagesNav = "MessagesNav"
        static let UpdateProductNav = "UpdateProductNav"
        static let tChooseXXXXVC = "ChooseXXXXVC"
        static let FilterNav = "FilterNav"
    }
    
    struct Services {
        static let baseURL = "http://haseboty.com/shopping/webservice/"
        static let imagePath = "http://haseboty.com/shopping/shopping/public/website/product_images/"
        /// Take { username , password }
        static let login = baseURL + "login.php"
        /// Take { username , email , password }
        static let signUp = baseURL + "sinup.php"
        /// Take { email }
        static let forgetPassword = baseURL + "forgetpassword.php"
        /// Take { id_client , title , description(Optional) , id_category1 , id_category2 , id_category3 ?? 2 , price , swap , id_brand , id_size , id_condition_state , id_city , id_government , id_color1 , id_color2 , img (Up to 5 images) }
        static let addProduct = baseURL + "addProduct.php"
        /// Without anyThing
        static let productContentData = baseURL + "productContentData.php"
        static let uploadImage = imagePath + "uploadAndroid.php"
        
        /// Take { user_id , limit }
        static let getAllProduct = baseURL + "productsLimit.php"
        
        /// Take { id_client , id_product , state }
        static let updateLove = baseURL + "addOrRemoveFavoutate.php"
        
        /// Take { id_client , id ( ProductID ) }
        static let productDetails = baseURL + "productProfileData.php"
        
        /// Take { id_product }
        static let updateView = baseURL + "addProductView.php"
        
        /// Take { id_client , limit , user_id }
        static let clientProducts = baseURL + "productsByClientId.php"
        
        /// Take { limit , user_id , id_category1 , id_category2 , id_category3 }
        static let similarProducts = baseURL + "productsByBrandIdLimit.php"
        
        /// Take { id ( commentID ) }
        static let deleteComment = baseURL + "deleteComment.php"
        
        /// Take { comment , id_client , id_product }
        static let postComments = baseURL + "addComment.php"
        
        /// Take { id_product }
        static let getComments = baseURL + "productComments.php"
        
        /// { id ( userID who will login ) }
        static let editClientData = baseURL + "editClientData.php"
        
        /// { id ( who loggin in ) , username , name , password , email , logo , phone , about }
        static let updateClient = baseURL + "updateClient.php"
        
        /// Take { limit , id_client }
        static let productClientLove = baseURL + "productClientLove.php"
        
        /// Take { limit , text , user_id }
        static let productSearch = baseURL + "productSearch.php"
        
        /// Take { id , id_followers }
        static let clientData = baseURL + "clientData.php"
        
        /// Take { id_follower , id_client , state }
        static let updateFollow = baseURL + "addFollow.php"
        
        /// Take { id , id_follower ( user who logged in ) }
        static let clientFollowers = baseURL + "clientFollowers.php"
        
        /// Take { id , id_follower ( user who logged in ) }
        static let clientFollowing = baseURL + "clientFollowing.php"
        
        /// Take { id_client }
        static let clientReviewData = baseURL + "clientReviewData.php"
        
        /// Take { id ( Comment ID ) }
        static let deleteReview = baseURL + "deleteReview.php"
        
        /// Take { data ( commentText.getText().toString() ) , id_client , rate , id_rate_client }
        static let addReview = baseURL + "addReview.php"
        
        /// Take { id ( user who signed in ) }
        static let inboxMessages = baseURL + "clientChatList.php"
        
        /// Take { id_recieve , id_sent ( user who signed in ) }
        static let getChat = baseURL + "clientMessages.php"
        
        /*
        for loop
        if (chatList.getJSONObject(i).getString("seen").equals("1"))
        break;
        else {
        ("id[]", msg_id)
        }
        */
        static let seeMessage = baseURL + "seeMessage.php"
        
    
        /// Take { message , id_recieve , id_sent ( user who sign in ) }
        static let addMessage = baseURL + "addMessage.php"
        
        /// Take { id ( id_product ) }
        static let deleteProduct = baseURL + "deleteProduct.php"
        
        /// Take { id (id_product ) }
        static let editProductData = baseURL + "editProductData.php"
        
        /// TAKE { باراميترز كتير اوى اوى }
        static let updateProduct = baseURL + "updateProduct.php"
        
        // FORUMS
        /// Take { id_kind ( default is -1 ) }
        static let formsAll = baseURL + "formsAll.php"
        
        static let allFormsKind = baseURL + "allFormsKind.php"
        
        /// TAKE { id: id_form }
        static let formsContentById = baseURL + "formsContentById.php"
        
        /// TAKE { comment , id_client , id_form }
        static let addFormsComment = baseURL + "addFormsComment.php"
        
        /// TAKE { id_form }
        static let formsComments = baseURL + "formsComments.php"
        
        static let deleteFormsComment = baseURL + "deleteFormsComment.php"
        
        static let productAllSearch = baseURL + "productAllSearch.php"
    
    }
}
