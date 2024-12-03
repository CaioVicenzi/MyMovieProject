import SwiftUI

struct MovieDetailView: View {
    @StateObject private var vm: MovieDetailViewModel
    @EnvironmentObject private var loginStateService : LoginStateService
    @Environment(\.modelContext) var modelContext
    
    init(movieID: Int) {
        _vm = StateObject(wrappedValue: MovieDetailViewModel(movieID: movieID))
    }
    
    var body: some View {
        VStack {
            headerView
            
            ScrollView {
                if let movie = vm.movieDetail {
                    VStack(alignment: .leading, spacing: 20) {
                        descriptionSection(movie: movie)
                        genreSection(genres: movie.genres)
                        commentsSection
                    }
                    .padding(.horizontal)
                } else {
                    ProgressView()
                        .padding()
                }
            }
        }
        .ignoresSafeArea()
        .background(Color(.systemBackground))
        .onAppear {
            vm.onLoadingView(modelContext)
        }
        .overlay {
            if vm.waiting {
                ProgressView()
            }
        }
        .allowsHitTesting(!vm.waiting)
        .alert(vm.loginAlertTitle, isPresented: $vm.showAlertLogin) {
            Button("Continue", role: .cancel) {}
            
            Button("Login") {
                vm.loginAlertButtonPressed()
            }
        }
        .fullScreenCover(isPresented: $vm.goLoginView) {
            LoginView()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                favoriteButton
            }
        }
    }
    
    private var headerView: some View {
        RoundedRectangle(cornerRadius: 30)
            .foregroundStyle(Color.darkPurple)
            .frame(height: 260)
            .overlay(alignment: .leading) {
                if let movie = vm.movieDetail {
                    VStack(alignment: .leading, spacing: 10) {
                        Spacer()
                        Text(movie.title)
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.white)
                        
                        HStack {
                            Text("Popularity: \(String(format: "%.2f", movie.voteAverage))")
                                .font(.headline)
                                .foregroundColor(.white)
                            Spacer()
                            likeButton
                        }
                        .padding(.top)
                    }
                    .padding()
                }
            }
    }
    
    private var likeButton: some View {
        VStack {
            Button {
                vm.likeButtonPressed(loginStateService.state)
            } label: {
                Image(systemName: vm.didUserLiked ? "heart.fill" : "heart")
            }
            .disabled(vm.waiting)
            
            Text(vm.likes.description)
                .foregroundColor(.white)
        }
    }
    
    private var favoriteButton: some View {
        VStack {
            Button {
                vm.favoriteButtonPressed()
            } label: {
                Image(systemName: vm.isFavorited == true ? "star.fill" : "star")
            }
            .disabled(vm.waiting)
        }
    }
    
    private func descriptionSection(movie: MovieDetail) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Description")
                .font(.headline)
                .bold()
            Text(movie.overview)
                .foregroundColor(.secondary)
        }
    }
    
    private func genreSection(genres: [Genre]) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Genres")
                .font(.headline)
                .bold()
            ForEach(genres, id: \.name) { genre in
                HStack {
                    Image(systemName: "play.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 10)
                        .foregroundColor(.gray)
                    Text(genre.name)
                }
            }
        }
    }
    
    private var commentsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Comments")
                .font(.headline)
                .bold()
            
            HStack {
                TextField("I liked this movie because...", text: $vm.comment)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                if !vm.comment.isEmpty {
                    Button {
                        Task {
                            await vm.saveComment(self.loginStateService.state)
                        }
                    } label: {
                        Image(systemName: "paperplane.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 30)
                            .foregroundColor(.blue)
                    }
                }
            }
            
            if vm.comments.isEmpty {
                Text("No comments available for this movie yet...")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            } else {
                ForEach(vm.comments, id: \.title) { comment in
                    CommentCard(comment: comment)
                }
            }
        }
    }
}

struct CommentCard: View {
    let comment: Comment
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.gray.opacity(0.2))
            .frame(height: 80)
            .overlay(alignment: .leading) {
                VStack(alignment: .leading, spacing: 5) {
                    Text(comment.username)
                        .bold()
                    Text(comment.title)
                        .foregroundColor(.secondary)
                }
                .padding()
            }
    }
}
