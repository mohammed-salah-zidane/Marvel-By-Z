//
//  NavigationManager.swift
//  Marvel
//
//  Created by prog_zidane on 12/1/19.
//  Copyright © 2019 prog_zidane. All rights reserved.
//

import Foundation
import UIKit

struct NavigationManager{
    //MARK:- Navigate to home screen
    static func navigateToHomeScreen(_ viewController:UIViewController){
        guard let homeVC = Commons.mainStoryBoard.instantiateViewController(withIdentifier: "home") as? UINavigationController else {return}
        viewController.present(homeVC, animated: true ,completion: nil)
    }
    //MARK:- Navigate to character details
    static func navigateToCharacterDetails(id:Int?,character:MarvelCharacter?,image:UIImage?,_ viewController:UIViewController,isFromSearch:Bool){
        guard let characterDetailsVc = Commons.mainStoryBoard.instantiateViewController(withIdentifier: "details") as? CharacterDetialsViewController else {return}
        characterDetailsVc.characterImage = image
        characterDetailsVc.id = id
        characterDetailsVc.character = character
        characterDetailsVc.isFromSearch = isFromSearch
        viewController.navigationController?.pushViewController(characterDetailsVc, animated: true)
    }
}
