//
//  ReviewItemGenerator.swift
//  canvpn
//
//  Created by Can Babaoğlu on 30.01.2024.
//

import Foundation

class ReviewItemGenerator {
    class func getRandomReviews() -> [ReviewItem] {
        let reviews: [ReviewItem] = [
            ReviewItem(index: 0,
                       point: "3", name: "SarahJohnson", city: "Toronto, Canada",
                       text: "Decent app, but the lack of servers in Canada is a drawback. The connection speed is alright, but it could be better. Hoping for improvements."),
            ReviewItem(index: 1,
                       point: "4", name: "SophieWilliams", city: "Paris, France",
                       text: "This app is a game-changer for me. It allows me to access content from all over the world, and the speed is usually great. There have been a couple of slow moments, but they're rare. Overall, a solid choice for VPN."),
            ReviewItem(index: 2,
                       point: "5", name: "JohnDoe", city: "San Francisco, USA",
                       text: "I can't say enough good things about this app. It's incredibly reliable and fast. I use it for both work and personal browsing, and it never lets me down. Highly recommended!"),
            ReviewItem(index: 3,
                       point: "4", name: "Sophia93Brown", city: "London, UK",
                       text: "I've been using this VPN for a few months now, and it's been a good experience overall. It provides a secure connection, and I appreciate the option to choose different server locations. The only downside is that occasionally the connection speed can drop, but it usually picks up again. It's a solid VPN service for the price."),
            ReviewItem(index: 4,
                       point: "5", name: "marksmith5", city: "Paris, France",
                       text: "This is hands down the best privacy app I've ever used. The user interface is clean and easy to navigate. The connection is lightning fast, and I love the fact that it allows me to access blocked content. I would highly recommend this app to anyone looking for a reliable VPN service."),
            ReviewItem(index: 5,
                       point: "5", name: "Sophie Brown", city: "London, UK",
                       text: "Decent app, but the connection can be slow at times. Great for secure browsing. Fast connections."),
            ReviewItem(index: 6,
                       point: "5", name: "أميرة", city: "القاهرة, مصر",
                       text: "تطبيق جيد لكن التواصل أحيانًا يكون غير مستقر."),
            ReviewItem(index: 7,
                       point: "5", name: "王五", city: "广州, 中国",
                       text: "很棒的应用，速度快，推荐使用。"),
            ReviewItem(index: 8,
                       point: "5", name: "张三", city: "上海, 中国",
                       text: "非常好的应用，速度快，稳定性好。"),
            ReviewItem(index: 9,
                       point: "4", name: "John Chieftain", city: "New York, USA",
                       text: "Great app for browsing anonymously. Would love to see more servers in the USA."),
            ReviewItem(index: 10,
                       point: "5", name: "maria1995", city: "Madrid, Spain",
                       text: "Muy buena aplicación para navegar de forma anónima."),
            ReviewItem(index: 11,
                       point: "5", name: "PaulW", city: "Vienna, Austria",
                       text: "Sehr gute App für sicheres Surfen."),
            ReviewItem(index: 12,
                       point: "4", name: "DavidSmith", city: "Berlin, Germany",
                       text: "Gute App, aber manchmal ist die Verbindung unzuverlässig."),
            ReviewItem(index: 13,
                       point: "5", name: "moyrafan", city: "Finland",
                       text: "Very nice application"),
            ReviewItem(index: 14,
                       point: "5", name: "Boris4316", city: "Tallinn, Estonia", text: "Review 69"),
            ReviewItem(index: 15,
                       point: "4", name: "zeliş123", city: "Türkiye",
                       text: "The free locations work faster than I expected and the name of the app is so cute, loved it. However, can you add new gaming servers for the players on the iPad?"),
            ReviewItem(index: 16,
                       point: "4", name: "Xin72313", city: "China",
                       text: "Good app!!"),
            ReviewItem(index: 17,
                       point: "4", name: "Muhammed87", city: "Saudi Arabia",
                       text: "sometimes connection slow but generally very good!"),
            ReviewItem(index: 18,
                       point: "5", name: "ecemm19", city: "Germany",
                       text: "i like fast connection, could you add more free location."),
            ReviewItem(index: 19,
                       point: "5", name: "Chefteam", city: "Istanbul, Turkey",
                       text: "İstediğim konumu seçip kolay ve hızlı bir şekilde kullanıyorum. Basit arayüzler için de geliştirici ekibe teşekkür ediyorum."),
        ]
        
        let shuffledReviews = reviews.shuffled()
        let first10Reviews = Array(shuffledReviews.prefix(10))
        return first10Reviews
    }
}
