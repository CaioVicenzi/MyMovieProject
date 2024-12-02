import SwiftUI

struct MovieDetailView: View {
    @StateObject private var vm: MovieDetailViewModel
    
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
            Task {
                await vm.fetchComments()
                await vm.fetchLikes()
                await vm.fetchDetailMovie()
            }
        }
        .overlay {
            if vm.waiting {
                ProgressView()
            }
        }
        .allowsHitTesting(!vm.waiting)
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
                } else {
                    ProgressView()
                }
            }
    }
    
    private var likeButton: some View {
        Button {
            vm.likeButtonPressed()
        } label: {
            VStack {
                Image(systemName: vm.didUserLiked ? "heart.fill" : "heart")
                    .foregroundColor(.red)
                Text(vm.likes.description)
                    .foregroundColor(.white)
            }
        }
        .disabled(vm.waiting)
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
                    Image(systemName: "chevron.right")
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
                            await vm.saveComment()
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
