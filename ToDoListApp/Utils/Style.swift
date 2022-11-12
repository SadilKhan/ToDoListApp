import SwiftUI


// Toggle Button Style
struct CheckToggleStyle: ToggleStyle {
    @State var toggleCondition: Bool
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
            toggleCondition = configuration.isOn
        } label: {
            Label {
                configuration.label
            } icon: {
                Image(systemName: toggleCondition ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(toggleCondition ? .purple : Color(uiColor: UIColor.magenta))
                    .accessibilityLabel(Text(toggleCondition ? "Checked" : "Unchecked"))
                    .imageScale(.large)
            }
        }
            .buttonStyle(.plain)
    }
}
