//
//  OpenAiService.swift
//  EmeraldJewels
//
//  Created by Navpreet Kaur on 09/10/24.
//



import Foundation

class OpenAIService {
    private let apiKey = "" // key removed for security purposes

    private let openAIURL =  "https://api.openai.com/v1/chat/completions"
    
    
    func sendMessageToOpenAI(message: String, completion: @escaping (String?) -> Void) {
        guard let url = URL(string: openAIURL) else {
            completion(nil)
            return
        }
        
        // Prepare the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Prepare the body of the request

        let parameters: [String: Any] = [
            "model": "gpt-4o",  // OpenAI model
            "messages": [
                ["role": "system", "content": "You are an AI assistant that recommends matching jewellery according to the outfit worn . You should also identify if the person is male or female and then recommend jewellery. If you cannot identify then recommend jewellery for both male and female separately . You name is Pixi"], // System prompt
                ["role": "user", "content": message]  // User message
            ]
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            request.httpBody = jsonData
        } catch {
            completion(nil)
            return
        }
        
        // Perform the request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion(nil)
                return
            }
            
            // Parse the response
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let choices = json["choices"] as? [[String: Any]],
                   let messageContent = choices.first?["message"] as? [String: Any],
                   let content = messageContent["content"] as? String {
                    completion(content)
                    
                } else {
                    completion(nil)
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
                completion(nil)
            }
        }
        
        task.resume() // Start the network request
        
    }
}


