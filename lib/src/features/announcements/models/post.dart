class Post {
  final String id;
  final String userName;
  final String avatarUrl;
  final String imageUrl;
  final String caption;
  final DateTime createdAt;
  final int likeCount;
  final bool isLiked;
  final List<String> comments;

  Post({
    required this.id,
    required this.userName,
    required this.avatarUrl,
    required this.imageUrl,
    required this.caption,
    required this.createdAt,
    required this.likeCount,
    this.isLiked = false,
    required this.comments,
  });

  Post copyWith({
    String? id,
    String? userName,
    String? avatarUrl,
    String? imageUrl,
    String? caption,
    DateTime? createdAt,
    int? likeCount,
    bool? isLiked,
    List<String>? comments,
  }) {
    return Post(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      imageUrl: imageUrl ?? this.imageUrl,
      caption: caption ?? this.caption,
      createdAt: createdAt ?? this.createdAt,
      likeCount: likeCount ?? this.likeCount,
      isLiked: isLiked ?? this.isLiked,
      comments: comments ?? this.comments,
    );
  }

  static List<Post> fakeList() {
    return [
      Post(
        id: '1',
        userName: 'Tech Club',
        avatarUrl: 'https://via.placeholder.com/40',
        imageUrl: 'https://via.placeholder.com/400x300',
        caption: '🚀 Join our upcoming hackathon! Register now for an amazing experience.',
        createdAt: DateTime.now().subtract(Duration(hours: 2)),
        likeCount: 42,
        comments: [
          'Amazing event! Count me in 🔥',
          'When is the registration deadline?',
          'Can\'t wait to participate!'
        ],
      ),
      Post(
        id: '2',
        userName: 'Sports Club',
        avatarUrl: 'https://via.placeholder.com/40',
        imageUrl: 'https://via.placeholder.com/400x300',
        caption: '⚽ Inter-house football tournament starting next week. Get ready to cheer!',
        createdAt: DateTime.now().subtract(Duration(hours: 5)),
        likeCount: 28,
        comments: [
          'Go Blue House! 💙',
          'Excited for the matches!',
        ],
      ),
      Post(
        id: '3',
        userName: 'Music Club',
        avatarUrl: 'https://via.placeholder.com/40',
        imageUrl: 'https://via.placeholder.com/400x300',
        caption: '🎵 Annual concert rehearsals have begun. Join us for an evening of melodies!',
        createdAt: DateTime.now().subtract(Duration(days: 1)),
        likeCount: 56,
        comments: [
          'Love the music club performances!',
          'When is the concert date?',
          'Beautiful voice as always 🎤'
        ],
      ),
      Post(
        id: '4',
        userName: 'Blue House',
        avatarUrl: 'https://via.placeholder.com/40',
        imageUrl: 'https://via.placeholder.com/400x300',
        caption: '🏆 Proud to announce our victory in the debate competition! Team spirit wins! 💙',
        createdAt: DateTime.now().subtract(Duration(days: 2)),
        likeCount: 73,
        comments: [
          'Well deserved victory! 🎉',
          'Blue House rocks!',
          'Congratulations team!'
        ],
      ),
    ];
  }
}