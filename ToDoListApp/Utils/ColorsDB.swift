import SwiftUI

struct ColorsDB {
    
    static let colorManager:ColorsDB = ColorsDB()
    
    var buttonColor = Color(#colorLiteral(red: 0.3688242137, green: 0.01902992651, blue: 0.1999672949, alpha: 1))
    var tabIconColor = Color(#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1))
    
    var boxColorLightMode = LinearGradient(
        gradient: Gradient(colors: [Color(#colorLiteral(red: 0.07092166692, green: 0.1866259277, blue: 0.2399283648, alpha: 1)), Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing)
    
    var boxColorDarkMode = LinearGradient(
        gradient: Gradient(colors: [Color(#colorLiteral(red: 0.2668099701, green: 0.7786713243, blue: 1, alpha: 1)), Color(#colorLiteral(red: 0.8657304645, green: 0.8657304645, blue: 0.8657304645, alpha: 1))]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing)
    
    var buttonColotNotAnimated = Color(#colorLiteral(red: 0.3236978054, green: 0.1063579395, blue: 0.574860394, alpha: 1))
    var backgroundColor = LinearGradient(
        gradient: Gradient(colors: [Color(#colorLiteral(red: 0.1904447377, green: 0.115080364, blue: 0.2382679284, alpha: 1)), Color(#colorLiteral(red: 1, green: 0.5212053061, blue: 1, alpha: 1))]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing)

    var bgColorItemList = LinearGradient(
        gradient: Gradient(colors: [Color.blue, Color(#colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1))]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing)

    var strokeColorDescriptionField = LinearGradient(
        gradient: Gradient(colors: [Color.blue, Color(#colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1))]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing)

    var listItemColor = LinearGradient(
        gradient: Gradient(colors: [Color(#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)), Color(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1))]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing)
}


func randomColorChooser() -> Color {

    let allColors: [Color] = [Color.gray, Color.green, .blue, .red, .black, .cyan, .indigo, .orange, .purple, .pink, .mint]
    let randomIndex = Int(arc4random_uniform(UInt32(allColors.count)))
    return allColors[randomIndex]
}


func colorForType(_ type: String) -> some View {

    switch type {
    case "Personal":
        return Image(systemName: "person.fill").foregroundColor(.blue)
    case "Work":
        return Image(systemName: "bag.fill").foregroundColor(.purple)
    case "Meeting":
        return Image(systemName: "person.3.fill").foregroundColor(Color(uiColor: UIColor.brown))
    case "Sports":
        return Image(systemName: "figure.soccer").foregroundColor(Color(uiColor: UIColor.magenta))
    case "Shopping":
        return Image(systemName: "cart.fill").foregroundColor(Color(uiColor: UIColor.red))
    case "Misc":
        return Image(systemName: "hand.thumbsup.fill").foregroundColor(.orange)
    default:
        return Image(systemName: "hand.thumbsup").foregroundColor(.orange)
    }

}
