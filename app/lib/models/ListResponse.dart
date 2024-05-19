class ListResponse<T> {
  final int count;
  final String? next;
  final String? previous;
  final List<T> results;

  ListResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory ListResponse.fromJson(
      Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    return ListResponse<T>(
      count: int.parse(json['count'].toString()), // Parse count as an integer
      next: json['next'],
      previous: json['previous'],
      results:
          (json['results'] as List).map((item) => fromJsonT(item)).toList(),
    );
  }
}
