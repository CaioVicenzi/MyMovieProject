import SwiftUI
import SwiftData

struct UserAccountView: View {
    @ObservedObject var vm: UserAccountViewModel
    @Environment(\.modelContext) var modelContext
    
    init() {
        self.vm = UserAccountViewModel()
    }
    
    var body: some View {
        ScrollView {
            VStack (alignment: .leading) {
                Text("Movies that you favorited: ")
                    .font(.headline)
                    .padding(.horizontal)
                List {
                    ForEach (vm.favoritedMoview, id: \.self) { favoriteMovie in
                        Text(favoriteMovie)
                    }
                }
                
                Text("Todos os comentários que você fez: ")
                    .font(.headline)
                    .padding(.horizontal)
                
                ForEach (vm.comments, id: \.id) { comment in
                    RoundedRectangle(cornerRadius: 20)
                        .frame(height: 60)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                        .foregroundStyle(.purple.opacity(0.3))
                        .overlay (alignment: .top) {
                            VStack {
                                HStack {
                                    Text(comment.title)
                                    Spacer()
                                    //Text("25/12/2024")
                                }
                                
                                HStack {
                                    Text(comment.movieTitle)
                                    Spacer()
                                }
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            }
                            .padding()
                            .padding(.horizontal)
                        }
                }
            }
            .overlay(alignment: .center, content: {
                if vm.waiting {
                    ProgressView("Loading")
                }
            })
            .onAppear(perform: {
                vm.config(modelContext: modelContext)
                vm.onAppearView()
            })
            .navigationTitle("Profile")
        }
    }
}

#Preview {
    UserAccountView()
}
