import SwiftUI

struct Home: View {
    
    let persistence = PersistenceController.shared
    
    var body: some View {
        TabView {
            ZStack {
                Menu().environment(\.managedObjectContext, persistence.container.viewContext)
            }
            
            .tabItem {
                Label("Menu", systemImage: "list.dash")
            }
            
            UserProfile()
            .tabItem {
                Label("Profile", systemImage: "square.and.pencil")
            }
        }.navigationBarBackButtonHidden(true)
    }
}
