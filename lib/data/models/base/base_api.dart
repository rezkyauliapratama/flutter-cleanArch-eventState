abstract class BaseApi<T> {
  final String statusMessage;
  final bool success;
  final int statusCode;

  BaseApi({this.statusMessage, this.success, this.statusCode});
}
