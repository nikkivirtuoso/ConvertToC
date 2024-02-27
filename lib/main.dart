import 'package:http/http.dart' as http;

void main() async {
  try {
    // Make HTTP GET request
    String url = "https://reqres.in/api/users/2";
    var response = await http.get(Uri.parse(url));

    // Check if the request was successful (status code 200)
    if (response.statusCode == 200) {
      // Generate C code to print the response
      String cCode = generateCCodeSnippet(url);
      print('Generated C code:');
      print(cCode);
    } else {
      // If the request was not successful, print the status code
      print('Request failed with status: ${response.statusCode}');
    }
  } catch (e) {
    // Handle any errors that occur during the request
    print('Error: $e');
  }
}

String generateCCodeSnippet(String apiUrl) {
  // Escape double quotes in the API URL
  String escapedUrl = apiUrl;

  // Generate C code snippet using libcurl
  return '''
#include <stdio.h>
#include <curl/curl.h>

int main() {
    CURL *curl;
    CURLcode res;

    curl_global_init(CURL_GLOBAL_ALL);
    curl = curl_easy_init();
    if (curl) {
        curl_easy_setopt(curl, CURLOPT_URL, "$escapedUrl");
        res = curl_easy_perform(curl);
        if (res != CURLE_OK) {
            fprintf(stderr, "curl_easy_perform() failed: %s\\n", curl_easy_strerror(res));
        }
        curl_easy_cleanup(curl);
    }
    curl_global_cleanup();
    return 0;
}
''';
}
