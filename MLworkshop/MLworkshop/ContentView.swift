//
//  ContentView.swift
//  MLworkshop
//
//  Created by wahaj on 11/05/2022.
//
import CoreML
import Vision
import SwiftUI

struct ContentView: View {
    @State private var photo: Data?
    @State private var animal: String = ""
    @State private var shouldPresentPhotoPicker: Bool = false
    @State private var error: Bool = false
    @State private var isLoading: Bool = false
    
    var body: some View {
        ZStack(alignment: .center){
            
            VStack{
                
                HStack{
                    Text("Machine Learning")
                        .font(.system(size: 32, weight: .bold))
                    Spacer()
                    if photo != nil{
                        Button(action: {
                            withAnimation{ self.photo = nil ; self.animal = ""}
                        }
                               , label: {
                            Image(systemName: "gobackward")
                                .font(.system(size: 25, weight: .semibold, design: .rounded))
                                .foregroundColor(.green)
                        }
                        )
                    }
                }
                .padding()
                .padding(.vertical,20)
                
                VStack(alignment: .center, spacing: -30){
                    if photo == nil {
                        Button(action: {
                            shouldPresentPhotoPicker.toggle()
                        }, label: {
                            ZStack{
                                
                                Image("Blackblurebackground")
                                    .resizable()
                                    .scaledToFit()
                                    .opacity(0.8)
                                    .frame(width: 343)
                                
                                VStack{
                                    Image(systemName: "plus")
                                        .font(.system(size: 45, weight: .semibold, design: .rounded))
                                        .foregroundColor(.green)
                                        .padding()
                                    Text("Upload animal photo")
                                        .font(.system(size: 25, weight: .semibold, design: .rounded))
                                        .foregroundColor(.white)
                                        .padding()
                                }
                                
                            }})
                        .fullScreenCover(isPresented: $shouldPresentPhotoPicker){
                            PhotoPickerView(photoData: $photo)
                        }
                        .padding(.horizontal)
                        .padding(.top, 50)
                        
                    } else {
                        if let Img = UIImage(data: photo!){
                            
                            Image(uiImage: Img)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 343, height: 343)
                                .clipShape(RoundedRectangle(cornerRadius:17,style: .circular))
                                .padding(.top, 50)
                        }
                    }
                    if animal == ""{
                        Button(action: {
                            if photo != nil{
                                withAnimation{ isLoading = true ;
                                    predictAnimal()
                                }
                            }
                            
                        }, label: {Text("Predict")
                                .font(.system(size: 17, weight: .semibold, design: .rounded)).foregroundColor(self.photo == nil ? .gray : .green)
                                .padding(10)
                                .frame(width:245)
                            
                            
                        })
                        
                        .buttonStyle(.bordered)
                        .padding(.top, 140)
                    } else {
                        
                        if !error {
                            VStack(alignment: .leading){
                                HStack{
                                    Text(self.animal == "" ?"" :"The animal is : \(animalType(string: animal))")
                                        .font(.title2)
                                        .bold()
                                    Spacer()
                                }
                                Text(animal)
                            }.padding(25)
                                .background((Color("color")).opacity(0.8).blur(radius: 5))
                            Spacer()
                        }
                        
                    }
                    Spacer()
                    
                    
                    
                }
            }.alert(isPresented: $error){
                Alert(
                    title: Text("Predection Error !"),
                    message: Text("The photo has uploaded is not an animal"),
                    
                    primaryButton: .destructive(
                        Text("Select other photo"),
                        
                        action: { withAnimation{ photo = nil
                            
                        }}
                    ),
                    secondaryButton: .cancel()
                )
            }
            
            if isLoading{
                VStack{
                    ActivityIndicatorView()
                    
                    Text("Predicting...")
                        .bold()
                        .foregroundColor(.green)
                }
                .frame(width: 150, height: 155)
                .background(Color(.black).opacity(0.8))
                
                .cornerRadius(16)
            }
            
        }
    }
    
    func animalType(string: String) -> String{
        return string.components(separatedBy: ", ")[0]
    }
    
    func predictAnimal(){
        
        do {
            let config = MLModelConfiguration()
            config.computeUnits = .cpuOnly
            
            //          let Model = try AAClassifier(configuration: config)
            let Model = try SqueezeNet(configuration: config)
            
            if let data = self.photo,
               let image = UIImage.init(data: data),
               let resizedImage = image.resizeImageTo(size:CGSize(width: 227, height: 227)),
               let bufferImage = resizedImage.convertToBuffer(){
                
                print("✓ Photo done")
                let prediction = try Model.prediction(image: bufferImage)
                print("✓ Prediction done")
                
                
                self.animal = prediction.classLabel
                print("the prediction is: \(self.animal)".uppercased())
                isLoading = false
            }
            
        } catch {
            self.error = true
            print("something went wrong! \n \(error.localizedDescription) \n \n More Info: \n \(error)")
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
        
    }
}
