//
//  EJJson.swift
//  EmeraldJewels
//
//  Created by Navpreet Kaur on 10/10/24.
//

import Foundation

let EJjewelleryProducts = """
[
    {
        "id": 1,
        "name": "Elegant Gold Necklace",
        "description": "18k gold necklace with intricate detailing",
        "price": 1500.00,
        "currency": "USD",
        "imageUrl": "EJ1 0"
    },
     {
       "id": 2,
       "name": "Diamond Stud Earrings",
       "description": "Classic diamond studs in 14k white gold",
       "price": 850.00,
       "currency": "USD",
       "imageUrl": "EJ1 1"
     },
     {
       "id": 3,
       "name": "Sapphire Pendant",
       "description": "Oval sapphire pendant set in sterling silver",
       "price": 450.00,
       "currency": "USD",
       "imageUrl": "EJ1 2"
     },
     {
       "id": 4,
       "name": "Pearl Drop Earrings",
       "description": "Elegant freshwater pearl drop earrings",
       "price": 120.00,
       "currency": "USD",
       "imageUrl": "EJ1 3"
     },
     {
       "id": 5,
       "name": "Ruby Cocktail Ring",
       "description": "Bold ruby ring with gold accents",
       "price": 980.00,
       "currency": "USD",
       "imageUrl": "EJ1 4"
     },
     {
       "id": 6,
       "name": "Gold Bangle Bracelet",
       "description": "Solid gold bangle with minimalist design",
       "price": 400.00,
       "currency": "USD",
       "imageUrl": "EJ1 5"
     },
     {
       "id": 7,
       "name": "Emerald Pendant Necklace",
       "description": "Emerald pendant in 14k yellow gold",
       "price": 1250.00,
       "currency": "USD",
       "imageUrl": "EJ1 7"
     },
     {
       "id": 8,
       "name": "Topaz Drop Earrings",
       "description": "Topaz stones set in sterling silver",
       "price": 300.00,
       "currency": "USD",
       "imageUrl": "EJ1 8"
     },
     {
       "id": 9,
       "name": "Platinum Engagement Ring",
       "description": "Round-cut diamond ring set in platinum",
       "price": 5000.00,
       "currency": "USD",
       "imageUrl": "EJ1 9"
     },
     {
       "id": 10,
       "name": "Amethyst Bracelet",
       "description": "Amethyst and silver chain bracelet",
       "price": 250.00,
       "currency": "USD",
       "imageUrl": "EJ1 10"
     },
     {
       "id": 11,
       "name": "Tanzanite Stud Earrings",
       "description": "Tanzanite earrings in 18k rose gold",
       "price": 780.00,
       "currency": "USD",
       "imageUrl": "EJ1 11"
     },
     {
       "id": 12,
       "name": "Gold Chain Bracelet",
       "description": "Simple 18k gold chain bracelet",
       "price": 320.00,
       "currency": "USD",
       "imageUrl": "EJ1 12"
     },
     {
       "id": 13,
       "name": "Opal Pendant Necklace",
       "description": "Opal pendant with sterling silver chain",
       "price": 600.00,
       "currency": "USD",
       "imageUrl": "EJ1 13"
     },
     {
       "id": 14,
       "name": "Diamond Tennis Bracelet",
       "description": "Diamond bracelet with 18k white gold",
       "price": 3500.00,
       "currency": "USD",
       "imageUrl": "EJ1 14"
     },
     {
       "id": 15,
       "name": "Aquamarine Pendant",
       "description": "Aquamarine stone in 14k gold pendant",
       "price": 420.00,
       "currency": "USD",
       "imageUrl": "EJ1 15"
     },
     {
       "id": 16,
       "name": "Sapphire and Diamond Earrings",
       "description": "Sapphire and diamond combo in white gold",
       "price": 1800.00,
       "currency": "USD",
       "imageUrl": "EJ1 16"
     },
     {
       "id": 17,
       "name": "Vintage Gold Locket",
       "description": "Vintage-style locket in 18k gold",
       "price": 1100.00,
       "currency": "USD",
       "imageUrl": "EJ1 17"
     },
     {
       "id": 18,
       "name": "Silver Cuff Bracelet",
       "description": "Handcrafted sterling silver cuff bracelet",
       "price": 200.00,
       "currency": "USD",
       "imageUrl": "EJ1 18"
     },
     {
       "id": 19,
       "name": "Turquoise Ring",
       "description": "Turquoise stone in sterling silver setting",
       "price": 350.00,
       "currency": "USD",
       "imageUrl": "EJ1 19"
     },
     {
       "id": 20,
       "name": "Garnet Stud Earrings",
       "description": "Garnet stones in 14k yellow gold",
       "price": 280.00,
       "currency": "USD",
       "imageUrl": "EJ1 20"
     }
]
""".data(using: .utf8)!


/*
 {
   "id": 2,
   "name": "Diamond Stud Earrings",
   "description": "Classic diamond studs in 14k white gold",
   "price": 850.00,
   "currency": "USD",
   "imageUrl": "EJ1 1"
 },
 {
   "id": 3,
   "name": "Sapphire Pendant",
   "description": "Oval sapphire pendant set in sterling silver",
   "price": 450.00,
   "currency": "USD",
   "imageUrl": "EJ1 2"
 },
 {
   "id": 4,
   "name": "Pearl Drop Earrings",
   "description": "Elegant freshwater pearl drop earrings",
   "price": 120.00,
   "currency": "USD",
   "imageUrl": "EJ1 3"
 },
 {
   "id": 5,
   "name": "Ruby Cocktail Ring",
   "description": "Bold ruby ring with gold accents",
   "price": 980.00,
   "currency": "USD",
   "imageUrl": "EJ1 4"
 },
 {
   "id": 6,
   "name": "Gold Bangle Bracelet",
   "description": "Solid gold bangle with minimalist design",
   "price": 400.00,
   "currency": "USD",
   "imageUrl": "EJ1 5"
 },
 {
   "id": 7,
   "name": "Emerald Pendant Necklace",
   "description": "Emerald pendant in 14k yellow gold",
   "price": 1250.00,
   "currency": "USD",
   "imageUrl": "EJ1 6"
 },
 {
   "id": 8,
   "name": "Topaz Drop Earrings",
   "description": "Topaz stones set in sterling silver",
   "price": 300.00,
   "currency": "USD",
   "imageUrl": "EJ1 7"
 },
 {
   "id": 9,
   "name": "Platinum Engagement Ring",
   "description": "Round-cut diamond ring set in platinum",
   "price": 5000.00,
   "currency": "USD",
   "imageUrl": "EJ1 8"
 },
 {
   "id": 10,
   "name": "Amethyst Bracelet",
   "description": "Amethyst and silver chain bracelet",
   "price": 250.00,
   "currency": "USD",
   "imageUrl": "EJ1 9"
 },
 {
   "id": 11,
   "name": "Tanzanite Stud Earrings",
   "description": "Tanzanite earrings in 18k rose gold",
   "price": 780.00,
   "currency": "USD",
   "imageUrl": "EJ1 10"
 },
 {
   "id": 12,
   "name": "Gold Chain Bracelet",
   "description": "Simple 18k gold chain bracelet",
   "price": 320.00,
   "currency": "USD",
   "imageUrl": "EJ1 11"
 },
 {
   "id": 13,
   "name": "Opal Pendant Necklace",
   "description": "Opal pendant with sterling silver chain",
   "price": 600.00,
   "currency": "USD",
   "imageUrl": "EJ1 12"
 },
 {
   "id": 14,
   "name": "Diamond Tennis Bracelet",
   "description": "Diamond bracelet with 18k white gold",
   "price": 3500.00,
   "currency": "USD",
   "imageUrl": "EJ1 13"
 },
 {
   "id": 15,
   "name": "Aquamarine Pendant",
   "description": "Aquamarine stone in 14k gold pendant",
   "price": 420.00,
   "currency": "USD",
   "imageUrl": "EJ1 14"
 },
 {
   "id": 16,
   "name": "Sapphire and Diamond Earrings",
   "description": "Sapphire and diamond combo in white gold",
   "price": 1800.00,
   "currency": "USD",
   "imageUrl": "EJ1 15"
 },
 {
   "id": 17,
   "name": "Vintage Gold Locket",
   "description": "Vintage-style locket in 18k gold",
   "price": 1100.00,
   "currency": "USD",
   "imageUrl": "EJ1 16"
 },
 {
   "id": 18,
   "name": "Silver Cuff Bracelet",
   "description": "Handcrafted sterling silver cuff bracelet",
   "price": 200.00,
   "currency": "USD",
   "imageUrl": "EJ1 17"
 },
 {
   "id": 19,
   "name": "Turquoise Ring",
   "description": "Turquoise stone in sterling silver setting",
   "price": 350.00,
   "currency": "USD",
   "imageUrl": "EJ1 18"
 },
 {
   "id": 20,
   "name": "Garnet Stud Earrings",
   "description": "Garnet stones in 14k yellow gold",
   "price": 280.00,
   "currency": "USD",
   "imageUrl": "EJ1 19"
 }
 */
