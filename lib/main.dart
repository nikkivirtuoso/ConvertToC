import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'API Code Snippet Generator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _apiLinkController = TextEditingController();
  String _codeSnippet = '';
  String _selectedLanguage = 'C';

  @override
  void dispose() {
    _apiLinkController.dispose();
    super.dispose();
  }

  void _generateCodeSnippet() {
    String apiLink = _apiLinkController.text.trim();
    if (apiLink.isNotEmpty) {
      if (_selectedLanguage == 'C') {
        // Generate C code snippet
        setState(() {
          _codeSnippet = generateCCodeSnippet(apiLink);
        });
      } else if (_selectedLanguage == 'Ruby (Faraday)') {
        // Generate Ruby code snippet
        setState(() {
          _codeSnippet = generateRubyCodeSnippet(apiLink);
        });
      } else if (_selectedLanguage == 'Rust (curl-rust)') {
        setState(() {
          _codeSnippet = generateRustCurlRustCodeSnippet(apiLink);
        });
      } else if (_selectedLanguage == 'Rust (reqwest)') {
        setState(() {
          _codeSnippet = generateRustReqwestCodeSnippet(apiLink);
        });
      } else if (_selectedLanguage == 'Rust (Hyper)') {
        setState(() {
          _codeSnippet = generateRustHyperCodeSnippet(apiLink);
        });
      } else if (_selectedLanguage == 'Ruby (Net::Http)') {
        setState(() {
          _codeSnippet = generateRubyNetHttpCodeSnippet(apiLink);
        });
      } else if (_selectedLanguage == 'R (Crul)') {
        setState(() {
          _codeSnippet = generateRCrulSnippet(apiLink);
        });
      } else if (_selectedLanguage == 'R (Httr)') {
        setState(() {
          _codeSnippet = generateRHttrSnippet(apiLink);
        });
      }
    }
  }

  void _copyCodeToClipboard() {
    Clipboard.setData(ClipboardData(text: _codeSnippet)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Code copied to clipboard'),
      ));
    });
  }

  String generateRHttrSnippet(String apiUrl) {
    String escapedUrl = apiUrl.replaceAll('"', '\\"');
    return '''
      library(httr)

    url <- "$escapedUrl"
    response <- GET(url)

    if (http_status(response)\$category == "Success") {
      content <- content(response, as = "text")
      cat(content)
    } else {
      cat("Request failed with status:", http_status(response)\$message)
    }
  ''';
  }

  String generateRCrulSnippet(String apiUrl) {
    String escapedUrl = apiUrl.replaceAll('"', '\\"');
    return '''
    library(crul)

    url <- "$escapedUrl"

    req <- crul::HttpClient\$new(url)
    res <- req\$get()

    if (res\$status_code == 200) {
      cat(res\$content)
    } else {
      cat("Request failed with status:", res\$status_code)
    }
    ''';
  }

  String generateRubyNetHttpCodeSnippet(String apiUrl) {
    String escapedUrl = apiUrl.replaceAll('"', '\\"');
    return '''
    require 'net/http'

    url = URI("$escapedUrl")
    http = Net::HTTP.new(url.host, url.port)
    request = Net::HTTP::Get.new(url)
    response = http.request(request)

    puts response.read_body
''';
  }

  String generateRustHyperCodeSnippet(String apiUrl) {
    String escapedUrl = apiUrl.replaceAll('"', '\\"');
    return '''
use std::io::Read;
use hyper::Client;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let client = Client::new();

    let response = client.get("$escapedUrl").await?;
    let mut body = Vec::new();
    response.into_body().read_to_end(&mut body)?;

    println!("{}", String::from_utf8_lossy(&body));
    Ok(())
}
''';
  }

  String generateRustReqwestCodeSnippet(String apiUrl) {
    String escapedUrl = apiUrl.replaceAll('"', '\\"');
    return '''
  use reqwest;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let response = reqwest::get("$escapedUrl")
        .await?
        .text()
        .await?;
    println!("{}", response);
    Ok(())
}
''';
  }

  String generateRustCurlRustCodeSnippet(String apiUrl) {
    String escapedUrl = apiUrl.replaceAll('"', '\\"');

    return '''
    use std::process::Command;

fn main() {
    let output = Command::new("curl")
        .arg("-s")
        .arg("$escapedUrl")
        .output()
        .expect("Failed to execute curl command");

    let response_body = String::from_utf8_lossy(&output.stdout);
    println!("{}", response_body);
}
  ''';
  }

  String generateCCodeSnippet(String apiUrl) {
    String escapedUrl = apiUrl.replaceAll('"', '\\"');
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

  String generateRubyCodeSnippet(String apiUrl) {
    return '''
require 'faraday'

url = '$apiUrl'

response = Faraday.get(url)

if response.status == 200
  # Print the response body
  puts response.body
else
  puts "Request failed with status: \#{response.status}"
end
''';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('API Code Snippet Generator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _apiLinkController,
              decoration: InputDecoration(
                labelText: 'Enter API Link',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedLanguage,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedLanguage = newValue!;
                });
              },
              items: <String>[
                'C',
                'Ruby (Faraday)',
                'Rust (curl-rust)',
                'Rust (reqwest)',
                'Rust (Hyper)',
                'Ruby (Net::Http)',
                'R (Crul)',
                'R (Httr)',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Select Language',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _generateCodeSnippet,
              child: Text('Generate Code Snippet'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _copyCodeToClipboard,
              child: Text('Copy Code'),
            ),
            SizedBox(height: 16),
            Text(
              'Code Snippet:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _codeSnippet,
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
