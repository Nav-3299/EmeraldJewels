//
//  EJUtility.swift
//  EmeraldJewels
//
//  Created by Navpreet Kaur on 09/10/24.
//

import Foundation
import SwiftUI

 class EJUtility{
    static let shared = EJUtility()
    
    func getTheme() -> some View{
        Image(.background)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .ignoresSafeArea()
    }
     
     func getLogoView() -> some View{
         Image(.logo)
             .resizable()
             .clipShape(Circle())
             .frame(width: 100 , height: 100)
     }
     
     func getAIAvatar() -> some View{
         Image(.aiAvatar)
             .resizable()
             .clipShape(Circle())
             .frame(width: 100 , height: 100)
     }
}
