import CoreData
import SwiftUI

struct ToggleButton: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }) {
            Text(title)
                .font(.custom("Karla-Medium", size: 14))
                .padding(4)
                .background(isSelected ? Color.blue : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
    }
}

struct Menu: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var searchText: String = ""
    @State private var selectedCategory: Category?
    
    enum Category: String, CaseIterable {
        case starters = "Starters"
        case mains = "Mains"
        case desserts = "Desserts"
        case drinks = "Drinks"
    }
    
    func buildPredicate() -> NSPredicate {
        if searchText.isEmpty {
            return NSPredicate(value: true)
        } else {
            return NSPredicate(format: "title CONTAINS[cd] %@", searchText)
        }
    }
    func categoryPredicate() -> NSPredicate {
        guard let selectedCategory = selectedCategory else {
            return NSPredicate(value: true)
        }
        return NSPredicate(format: "category == %@", selectedCategory.rawValue.lowercased())
    }
    func buildSortDescriptors() -> [NSSortDescriptor] {
        let sortDescriptor = NSSortDescriptor(
            key: "title", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))
        
        return [sortDescriptor]
    }
    
    func getMenuData() {
        // Clear the database before fetching new data
        // PersistenceController.shared.clear()
        
        let serverURLString =
        "https://raw.githubusercontent.com/Meta-Mobile-Developer-PC/Working-With-Data-API/main/menu.json"
        
        guard let url = URL(string: serverURLString) else {
            print("Invalid URL")
            return
        }
        
        let request = URLRequest(url: url)
        
        // Use URLSession to fetch data
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let menuList = try JSONDecoder().decode(MenuList.self, from: data)
                
                for menuItem in menuList.menu {
                    // Check if a dish with the same title already exists
                    let fetchRequest: NSFetchRequest<Dish> = Dish.fetchRequest()
                    fetchRequest.predicate = NSPredicate(format: "title == %@", menuItem.title)
                    
                    do {
                        let existingDish = try viewContext.fetch(fetchRequest).first
                        
                        if existingDish == nil {
                            // Dish does not exist, create a new one
                            let newDish = Dish(context: viewContext)
                            newDish.title = menuItem.title
                            newDish.image = menuItem.image
                            newDish.price = menuItem.price
                            newDish.itemDescription = menuItem.itemDescription
                            newDish.category = menuItem.category
                        }
                        
                        // Save changes to Core Data
                        viewContext.perform {
                            do {
                                try viewContext.save()
                            } catch let error {
                                print("Error saving context: \(error)")
                            }
                        }
                    } catch {
                        print("Error fetching dish: \(error.localizedDescription)")
                    }
                }
            } catch let decodingError {
                print("Error decoding JSON: \(decodingError.localizedDescription)")
            }
        }.resume()
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 0) {
                NavigationBarView()
                
                Text("Little Lemon")
                    .padding(.leading, 17)
                    .font(.custom("MarkaziText-Medium", size: 50))
                    .foregroundStyle(Color(hex: "F4CE14"))
                
                Text("Chicago")
                    .font(.custom("MarkaziText-Medium", size: 30))
                    .padding(.leading, 17)
                    .foregroundStyle(Color(hex: "FFFFFF"))
                
                HStack {
                    Text(
                        "We are a family-owned Mediterranean restaurant, focused on traditional recipes served with a modern twist."
                    )
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.custom("Karla-Medium", size: 16))
                    .foregroundStyle(Color(hex: "FFFFFF"))
                    .padding(.leading, 17)
                    
                    Image("hero-image")
                        .resizable()
                        .frame(width: 100, height: 120)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.trailing, 15)
                    
                }
                
                TextField("Search", text: $searchText, onEditingChanged: { _ in selectedCategory = nil })
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                VStack(alignment: .leading) {
                    Text("Order for Delivery!")
                        .font(.custom("Karla-Medium", size: 18))
                        .padding(.top, 10)
                        .padding(.leading, 17)
                    
                    HStack {
                        ForEach(Category.allCases, id: \.self) { category in
                            ToggleButton(title: category.rawValue, isSelected: selectedCategory == category) {
                                selectedCategory = category
                            }
                            if category.rawValue != "Drinks" {
                                Spacer()
                            }
                            
                        }
                        
                    }
                    .padding()
                }
                .background(Color(hex: "FFFFFF"))
                
                FetchedObjects(
                    predicate: NSCompoundPredicate(andPredicateWithSubpredicates: [
                        buildPredicate(), categoryPredicate(),
                    ]),
                    sortDescriptors: buildSortDescriptors()
                ) { (dishes: [Dish]) in
                    List {
                        ForEach(dishes, id: \.self) { dish in
                            NavigationLink(destination: DishDetails(dish: dish)) {
                                DishRow(dish: dish)
                            }
                        }
                    }
                }
            }
            .background(Color(hex: "495E57"))
        }
        .onAppear {
            getMenuData()
        }
        
    }
}

struct DishRow: View {
    var dish: Dish
    @State private var isLoading = true
    
    var body: some View {
        HStack {
            // Display title, description, and price
            VStack(alignment: .leading) {
                Text(dish.title ?? "")
                    .font(.custom("Karla-Bold", size: 18))
                Text(dish.itemDescription ?? "No Description")
                    .font(.custom("Karla-Regular", size: 16))
                    .foregroundColor(.gray)
                Text("$" + (dish.price ?? ""))
                    .font(.custom("Karla-Bold", size: 18))
                    .foregroundColor(.blue)
            }
            
            Spacer()
            
            // Display AsyncImage with resized style
            AsyncImage(url: URL(string: dish.image ?? "")) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .onAppear {
                            // Image has loaded
                            isLoading = false
                        }
                case .empty:
                    EmptyView()
                case .failure:
                    // Error state image
                    EmptyView()
                @unknown default:
                    Text("Unknown state")
                }
            }
            .frame(width: 50, height: 50)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                // Show ProgressView while loading
                Group {
                    if isLoading {
                        ProgressView()
                    }
                }
            )
        }
    }
}

