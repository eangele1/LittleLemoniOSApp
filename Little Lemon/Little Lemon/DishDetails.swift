import SwiftUI
import CoreData

struct DishDetails: View {
    var dish: Dish
    @State private var isLoading = true
    
    var body: some View {
        VStack {
            // Display dish image
            AsyncImage(url: URL(string: dish.image ?? "")) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(height: 150)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .onAppear {
                            // Image has loaded
                            isLoading = false
                        }
                case .failure:
                    // Error state image
                    EmptyView()
                case .empty:
                    EmptyView()
                @unknown default:
                    Text("Unknown state")
                }
            }
            .overlay(
                // Show ProgressView while loading
                Group {
                    if isLoading {
                        ProgressView()
                    }
                }
            )
            
            Text("\(dish.title ?? "")")
                .font(.title)
            
            // Display other dish details
            Text("\(dish.itemDescription ?? "No Description")")
            Text("$\(dish.price ?? "")")
            Text("Category: \(dish.category ?? "No Category")")
            
            // Add more details as needed
        }
        .padding()
    }
}
