class ApiResponse<T> {
  final T? result;
  final String? error;

  ApiResponse({this.result, this.error});
}
