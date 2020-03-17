//
//  CharacterListViewModel.swift
//  MarvelMVC
//
//  Created by dludlow7 on 03/02/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation
import UIKit

/* I commented about { get set } elsewhere but here it's a bit too much
 Try thinking of the protocol as the interface, then think what does the user of this protocol really need to know.
 It needs to prompt the view model to fetch characters.
 It needs to know when characters have been fetched so it can reload the view (closure or delegate)
 It probably needs to see chracters but not set them. 
 */
protocol CharacterListViewModelProtocol {
    var characters: [Character] { get set }
    var dataService: CharacterDataServiceProtocol { get set }
    var imageDataService: CharacterImageDataServiceProtocolV2 { get set }
}

class CharacterListViewModel: CharacterListViewModelProtocol {

    var characters: [Character]
    var dataService: CharacterDataServiceProtocol
    var imageDataService: CharacterImageDataServiceProtocolV2

    init(characters: [Character] = [Character](),
         dataController: CharacterDataServiceProtocol = CharacterDataService(),
         imageDataController: CharacterImageDataServiceProtocolV2 = CharacterImageDataServiceV2()) {

        self.characters = characters
        self.dataService = dataController
        self.imageDataService = imageDataController
    }
}
