//
//  OpenAiService.swift
//  EmeraldJewels
//
//  Created by Navpreet Kaur on 09/10/24.
//



import Foundation

protocol AIRecommendationServing {
    func sendMessage(_ message: String, completion: @escaping (Result<String, Error>) -> Void)
}

enum AIServiceError: LocalizedError {
    case missingAPIKey
    case invalidResponse
    case api(statusCode: Int, message: String, requestID: String?)

    var errorDescription: String? {
        switch self {
        case .missingAPIKey: return "AI service is not configured. Add OPENAI_API_KEY to the app configuration."
        case .invalidResponse: return "The AI service returned an invalid response."
        case let .api(statusCode, message, requestID):
            let requestReference = requestID.map { " (Request ID: \($0))" } ?? ""
            return "OpenAI error \(statusCode): \(message)\(requestReference)"
        }
    }
}

private struct OpenAIErrorPayload: Decodable {
    struct APIError: Decodable { let message: String }
    let error: APIError
}

final class OpenAIService: AIRecommendationServing {
    private let apiKey: String

    private let openAIURL =  "https://api.openai.com/v1/chat/completions"
    
    init(apiKey: String = Bundle.main.object(forInfoDictionaryKey: "OPENAI_API_KEY") as? String ?? "") {
        self.apiKey = apiKey
    }

    func sendMessage(_ message: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard !apiKey.isEmpty, !apiKey.hasPrefix("$(") else {
            completion(.failure(AIServiceError.missingAPIKey))
            return
        }
        guard let url = URL(string: openAIURL) else {
            completion(.failure(AIServiceError.invalidResponse))
            return
        }
        
        // Prepare the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Prepare the body of the request

        let parameters: [String: Any] = [
            "model": "gpt-4o",
            "messages": [
                ["role": "system", "content": "You are an AI assistant that recommends matching jewellery according to the outfit worn . You should also identify if the person is male or female and then recommend jewellery. If you cannot identify then recommend jewellery for both male and female separately . You name is Pixi"], // System prompt
                ["role": "user", "content": message]  // User message
            ]
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            request.httpBody = jsonData
        } catch {
            completion(.failure(error))
            return
        }
        
        // Perform the request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion(.failure(AIServiceError.invalidResponse))
                return
            }

            let requestID = (response as? HTTPURLResponse)?.value(forHTTPHeaderField: "x-request-id")
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0

            guard (200...299).contains(statusCode) else {
                let message = (try? JSONDecoder().decode(OpenAIErrorPayload.self, from: data).error.message)
                    ?? String(data: data, encoding: .utf8)
                    ?? "The request failed."
                completion(.failure(AIServiceError.api(statusCode: statusCode, message: message, requestID: requestID)))
                return
            }
            
            // Parse the response
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let choices = json["choices"] as? [[String: Any]],
                   let messageContent = choices.first?["message"] as? [String: Any],
                   let content = messageContent["content"] as? String {
                    completion(.success(content))
                    
                } else {
                    completion(.failure(AIServiceError.api(statusCode: statusCode, message: "The response did not contain generated text.", requestID: requestID)))
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        
        task.resume() // Start the network request
        
    }
}
