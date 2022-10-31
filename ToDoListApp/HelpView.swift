import SwiftUI

struct HelpView:View{
    var body: some View{
        VStack{
            HStack{
                Image(systemName: "plus")
                    .fontWeight(.semibold)
                Text(" Add a new Item")
                Spacer()
            }
            .padding(.horizontal,10)
            Spacer()
        }
    }
}


struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView()
    }
}
