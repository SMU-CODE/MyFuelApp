class ApiHttpStatus {
  // 2xx: Success
  static const int ok = 200;
  static const int created = 201;
  static const int accepted = 202;
  static const int noContent = 204;

  // 3xx: Redirection
  static const int movedPermanently = 301;
  static const int found = 302;
  static const int seeOther = 303;
  static const int notModified = 304;
  static const int temporaryRedirect = 307;
  static const int permanentRedirect = 308;

  // 4xx: Client Errors
  static const int badRequest = 400;
  static const int unauthorized = 401;
  static const int forbidden = 403;
  static const int notFound = 404;
  static const int methodNotAllowed = 405;
    static const int requestTimeout = 408;
  static const int conflict = 409;
  static const int unprocessableEntity = 422;
  static const int tooManyRequests = 429;
  static const int clientClosedRequest = 499; 

  // 5xx: Server Errors
  static const int internalServerError = 500;
  static const int notImplemented = 501;
  static const int badGateway = 502;
  static const int serviceUnavailable = 503;
  static const int gatewayTimeout = 504;

  /// Returns the standard reason phrase for a status code
  static String getReasonPhrase(int statusCode) {
    switch (statusCode) {
      case ok:
        return 'OK';
      case created:
        return 'Created';
      case accepted:
        return 'Accepted';
      case noContent:
        return 'No Content';
      case movedPermanently:
        return 'Moved Permanently';
      case found:
        return 'Found';
      case seeOther:
        return 'See Other';
      case notModified:
        return 'Not Modified';
      case temporaryRedirect:
        return 'Temporary Redirect';
      case permanentRedirect:
        return 'Permanent Redirect';
      case badRequest:
        return 'Bad Request';
      case unauthorized:
        return 'Unauthorized';
      case forbidden:
        return 'Forbidden';
      case notFound:
        return 'Not Found';
      case methodNotAllowed:
        return 'Method Not Allowed';
          case requestTimeout:
        return 'Request Timeout';
      case conflict:
        return 'Conflict';
      case unprocessableEntity:
        return 'Unprocessable Entity';
      case tooManyRequests:
        return 'Too Many Requests';
      case clientClosedRequest:
        return 'Client Closed Request';
      case internalServerError:
        return 'Internal Server Error';
      case notImplemented:
        return 'Not Implemented';
      case badGateway:
        return 'Bad Gateway';
      case serviceUnavailable:
        return 'Service Unavailable';
      case gatewayTimeout:
        return 'Gateway Timeout';
      default:
        return 'Unknown Status Code';
    }
  }
}
