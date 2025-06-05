class HomeViewState {
  final bool isLoading;
  final String? imageUrl;
  final String? errorMessage;

  const HomeViewState({
    this.isLoading = false,
    this.imageUrl,
    this.errorMessage,
  });

  HomeViewState copyWith({
    bool? isLoading,
    String? imageUrl,
    String? errorMessage,
  }) {
    return HomeViewState(
      isLoading: isLoading ?? this.isLoading,
      imageUrl: imageUrl ?? this.imageUrl,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
