import Foundation

/// Provides no-network recommendations when the AI service is unavailable.
/// Set `fallbackRecommendationService` to `nil` in `ChatViewModel` to disable this fallback.
protocol JewelleryRecommendationFallbackProviding {
    func recommendation(for message: String) -> String?
}

struct LocalJewelleryRecommendationService: JewelleryRecommendationFallbackProviding {
    func recommendation(for message: String) -> String? {
        let normalizedMessage = message.lowercased()
        let mentionsSkinTone = normalizedMessage.contains("skin tone")
            || normalizedMessage.contains("complexion")
            || normalizedMessage.contains("fair")
            || normalizedMessage.contains("fsir")
            || normalizedMessage.contains("wheatish")
            || normalizedMessage.contains("medium")
            || normalizedMessage.contains("dark")
            || normalizedMessage.contains("deep")

        guard mentionsSkinTone else { return nil }

        if normalizedMessage.contains("fair") || normalizedMessage.contains("fsir") {
            return "For a fair skin tone, try yellow gold, rose gold, silver, platinum, pearl white, emerald green, sapphire blue, ruby red, lavender, and soft pink jewellery."
        }
        if normalizedMessage.contains("wheatish") || normalizedMessage.contains("medium") || normalizedMessage.contains("olive") {
            return "For a medium or wheatish skin tone, try yellow gold, antique gold, rose gold, copper, coral, turquoise, emerald green, amber, and warm red jewellery."
        }
        if normalizedMessage.contains("dark") || normalizedMessage.contains("deep") || normalizedMessage.contains("brown") {
            return "For a deep skin tone, try bright yellow gold, rose gold, silver, white gold, pearl white, cobalt blue, emerald green, fuchsia, bright red, and rich purple jewellery."
        }

        return "Tell me whether your skin tone is fair, medium or wheatish, or deep, and I will suggest jewellery colours that may complement it."
    }
}
