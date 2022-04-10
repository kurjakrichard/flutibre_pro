class Book {
  final int? id;
  final String title;
  final double seriesIndex;
  final String author_sort;

  Book({
    this.id,
    required this.title,
    required this.seriesIndex,
    required this.author_sort,
  });

  Book.fromMap(Map<String, dynamic> books)
      : id = books["id"],
        title = books["title"],
        seriesIndex = books["series_index"],
        author_sort = books["author_sort"];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'series_index': seriesIndex,
      'author_sort': author_sort,
    };
  }
}
