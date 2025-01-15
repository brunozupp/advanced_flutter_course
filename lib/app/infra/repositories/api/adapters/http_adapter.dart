import 'dart:convert';

import 'package:advanced_flutter_course/app/infra/repositories/api/clients/http_get_client.dart';
import 'package:dartx/dartx.dart';
import 'package:http/http.dart';

import '../../../../domain/entities/domain_error.dart';
import '../../../types/json_type.dart';

final class HttpAdapter implements HttpGetClient {

  final Client _client;

  const HttpAdapter({
    required Client client,
  }) : _client = client;

  @override
  Future<T?> get<T>({
    required String url,
    Json? headers,
    Map<String, String?>? params,
    Map<String, String>? queryString,
  }) async {

    final uri = _buildUrl(
      url: url,
      params: params,
      queryString: queryString,
    );

    final response = await _client.get(
      uri,
      headers: _buildHeaders(headers),
    );

    return _handleResponse(response);
  }

  Map<String,String> _buildHeaders([Json? headers]) {

    final defaultHeaders = {
      "content-type": "application/json",
      "accept": "application/json",
    };

    return {
      ...defaultHeaders,
      if(headers != null)
        for(final key in headers.keys) key: headers[key].toString(),
    };
  }

  T? _handleResponse<T>(Response response) {

    switch(response.statusCode) {
      /// I don't need this line of code because I already treat
      /// the cases where I don't have any body in my response. And
      /// this rule is the case of 204 (NoContent), that is a positive
      /// response that doesn't have any body.
      /// So the logic will be lead by the standards of the backend.
      /// To this scenario I will let this line here.
      case 204:
        return null;
      case 400:
      case 403:
      case 404:
      case 500:
        throw UnexpectedError();
      case 401:
        throw SessionExpiredError();
    }

    /// To the cases where response from 200 is null
    /// But can be used to cases when the status is 204 (No Content)
    if(response.body.isEmpty) {
      return null;
    }

    final responseDecode = jsonDecode(response.body);

    /// I need to do this because Dart is not good when it comes to
    /// parse values, so I need to specify the type of my list as
    /// I put the type of this method where I am executed it.
    if(T == JsonList) {
      return responseDecode.map<Json>((e) => e as Json).toList();
    }

    return responseDecode;
  }

  Uri _buildUrl({
    required String url,
    Map<String, String?>? params,
    Map<String, String>? queryString,
  }) {

    var urlToFormat = url;

    urlToFormat = params?.keys
      .fold(
        urlToFormat,
        (result, key) =>
            result.replaceFirst(":$key", params[key] ?? ""))
      .removeSuffix("/") ??
    urlToFormat;

    urlToFormat = queryString?.keys
      .fold(
        "$urlToFormat?",
        (result, key) => "$result$key=${queryString[key]}&")
      .removeSuffix("&") ??
    urlToFormat;

    // params?.forEach((key, value) {

    //   if(value == null) {
    //     urlToFormat = urlToFormat.replaceFirst("/:$key", "");
    //   } else {
    //     urlToFormat = urlToFormat.replaceFirst(":$key", value);
    //   }
    // });

    // final queryStringList = queryString?.entries.toList() ?? [];

    // for (var i = 0; i < queryStringList.length; i++) {

    //   if(i == 0) {
    //     urlToFormat += "?";
    //   }

    //   urlToFormat += "${queryStringList[i].key}=${queryStringList[i].value}";

    //   if(i < queryStringList.length - 1) {
    //     urlToFormat += "&";
    //   }
    // }

    return Uri.parse(urlToFormat);
  }
}