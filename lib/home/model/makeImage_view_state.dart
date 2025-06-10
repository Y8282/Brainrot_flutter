class MakeimageViewState {
  final bool isLoading;
  final String? imageUrl;
  final String? errorMessage;

  const MakeimageViewState({
    this.isLoading = false,
    this.imageUrl,
    this.errorMessage,
  });

  MakeimageViewState copyWith({
    bool? isLoading,
    String? imageUrl,
    String? errorMessage,
  }) {
    return MakeimageViewState(
      isLoading: isLoading ?? this.isLoading,
      imageUrl: imageUrl ?? this.imageUrl,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
