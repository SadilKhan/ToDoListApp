import SwiftUI

struct ColorsDB {

    var bgColorItemList = LinearGradient(
        gradient: Gradient(colors: [Color.blue, Color(#colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1))]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing)

    var strokeColorDescriptionField = LinearGradient(
        gradient: Gradient(colors: [Color.blue, Color(#colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1))]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing)
}


func randomColorChooser() -> Color {

    let allColors: [Color] = [Color.gray, Color.green, .blue, .red, .black, .cyan, .indigo, .orange, .purple, .pink, .mint]
    let randomIndex = Int(arc4random_uniform(UInt32(allColors.count)))
    return allColors[randomIndex]
}


func colorForType(_ type:String) -> Color {
    
    switch type {
    case "Personal":
        return Color.blue
    case "Work":
        return Color.green
    case "Misc":
        return Color.orange
    default:
        return Color.primary
    }
    
}
