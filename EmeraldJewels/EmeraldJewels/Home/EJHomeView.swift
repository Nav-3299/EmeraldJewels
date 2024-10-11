//
//  EJHomeView.swift
//  EmeraldJewels
//
//  Created by Navpreet Kaur on 09/10/24.
//

import SwiftUI


struct EJHomeView: View {
    
    @State var gotoEJChatScreen = false
    @State var gotoEJDescriptionScreen = false
    @State var gotoSettingsPage = false
    @State var currentJewellery : JewelleryProduct!
    // Instantiate the ViewModel
       @ObservedObject var viewModel = JewelleryViewModel()
    var body: some View {
        NavigationStack{
            ZStack{
                VStack{
                    EJUtility.shared.getLogoView()

                    JewelleryImages
                    
                    AIButton
                }
                
                // Gear button placed on the top trailing edge
                VStack {
                    HStack {
                        Spacer() // Push the button to the trailing edge
                        
                        Button {
                            gotoSettingsPage = true
                        } label: {
                            Image(systemName: "gear")
                                .font(.system(size: 24))
                                .padding()
                        }
                        .foregroundStyle(.white)
                    }
                    Spacer() // Push the button to the top
                }

                
            }
            .background(EJUtility.shared.getTheme())
            .navigationDestination(isPresented: $gotoEJChatScreen) {
                EJChatView()
            }
            .navigationDestination(isPresented: $gotoEJDescriptionScreen) {
                EJDescriptionView(jewelleryProduct: $currentJewellery)
            }
            .navigationDestination(isPresented: $gotoSettingsPage) {
                EJSettingsView()
            }
        }
    }
}

#Preview {
    EJHomeView()
}


extension EJHomeView{
  
    
    private var JewelleryImages : some View{
        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
        ]
         return ScrollView{
             LazyVGrid(columns: columns ,spacing: 10 , content: {
                 
                 ForEach(viewModel.jewelleryProducts , id: \.id) { jewellery in
                     Button {
                         //open description Screen
                         currentJewellery = jewellery
                         gotoEJDescriptionScreen.toggle()
                         
                     } label: {
                         Image(jewellery.imageUrl ?? "")
                             .resizable()
                             .clipShape(RoundedRectangle(cornerRadius: 20))
                             .padding()
                             .frame(width: 200 , height: 200)
                             .overlay {
                                 VStack {
                                     Spacer()
                                     Text("\(jewellery.currency ?? "")" + "\(jewellery.price ?? 0)")
                                         .font(.footnote)
                                         .foregroundColor(.white)
                                         .padding(4)
                                         .background(Color.black.opacity(0.6))
                                         .cornerRadius(5)
                                 }
                                 .padding(.bottom, -10)
                                 .padding(.trailing, 8)
                             }
                     }

                     
                   
                 }
                 
                 
//                 ForEach(viewModel.jewelleryProducts) { _ in
//                     
//                     //MARK: - Rounded Rectangle
//                     RoundedRectangle(cornerRadius: 25)
//                         .foregroundStyle(Color(red: Double.random(in: 0...1), green: Double.random(in: 0...1), blue: Double.random(in: 0...1)))
//                         .frame(width: 100, height: 100)
//                 }
                    
                })
                
            
        }
         .padding()
    
    }
    
    private var AIButton : some View{
   
        Button {
            gotoEJChatScreen.toggle()
        } label: {
            Capsule()
            
                .frame(maxWidth: .infinity, maxHeight: 50)
                .frame(alignment: .bottom)
                .padding()
                .foregroundStyle(.purple)
                .overlay {
                    Text("Hi , I am Pixi !")
                        .foregroundStyle(.white)
                        .font(.headline)
                        .fontWeight(.bold)
                }
               
        }
        

    }
    
}
