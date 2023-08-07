import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:path_provider/path_provider.dart';

import 'failed_koneksi.dart';
import 'loading.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Dasadarma',
      debugShowCheckedModeBanner: false,
      home: WebwhatsPage(),
    );
  }
}

const desktopUserAgent =
    "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/101.0.4951.54 Safari/537.36";
const homeUrl = "https://pengmas.binerapps.co.id/";
const peduliStuntingUrl = "https://pengmas.binerapps.co.id/peduli-stunting";
const eAsuhUrl = "https://pengmas.binerapps.co.id/easuh";
const bumilUrl = "https://pengmas.binerapps.co.id/bumil-fit";
const dasawismaUrl = "https://pengmas.binerapps.co.id/dasawisma";

class WebwhatsPage extends StatefulWidget {
  const WebwhatsPage({Key? key}) : super(key: key);

  @override
  State<WebwhatsPage> createState() => _WebwhatsPageState();
}

class _WebwhatsPageState extends State<WebwhatsPage> {
  InAppWebViewController? _webViewController;
  int _currentIndex = 0;

  final List<String> _urls = [
    homeUrl,
    peduliStuntingUrl,
    eAsuhUrl,
    bumilUrl,
    dasawismaUrl
  ];
  bool _isLoading = true;
  bool isConnected = true;

  Future<void> _checkInternetConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    isConnected = connectivityResult != ConnectivityResult.none;
    print(isConnected);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final settings = InAppWebViewSettings(
      userAgent: desktopUserAgent,
      allowFileAccessFromFileURLs: true,
      allowUniversalAccessFromFileURLs: true,
      useOnDownloadStart: true,
      allowsInlineMediaPlayback: true,
    );
    final contextMenu = ContextMenu(
      settings: ContextMenuSettings(hideDefaultSystemContextMenuItems: false),
    );
    return WillPopScope(
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              !_isLoading && !isConnected
                  ? ConnectionFailedWidget(
                      onRetry: () => {_checkInternetConnectivity()},
                    )
                  : InAppWebView(
                      initialUrlRequest:
                          URLRequest(url: WebUri(_urls[_currentIndex])),
                      initialSettings: settings,
                      contextMenu: contextMenu,
                      onLoadStart: (controller, url) {
                        setState(() {
                          final newUrl = url.toString();
                          // Mencari indeks URL yang sesuai dalam daftar _urls
                          final index =
                              _urls.indexWhere((element) => element == newUrl);
                          if (index != -1) {
                            _currentIndex = index;
                          }
                        });
                      },
                      onWebViewCreated: (InAppWebViewController controller) {
                        _webViewController = controller;
                      },
                      onProgressChanged: (controller, progress) {
                        setState(() {
                          _isLoading = progress < 100;
                        });
                      },
                      onPermissionRequest: (controller, request) async =>
                          PermissionResponse(
                        resources: request.resources,
                        action: PermissionResponseAction.GRANT,
                      ),
                      onDownloadStartRequest: (controller, url) async {
                        await FlutterDownloader.enqueue(
                          url: url.url.toString(),
                          savedDir: (await getExternalStorageDirectory())!.path,
                          showNotification: true,
                          openFileFromNotification: true,
                        );
                      },
                    ),
              if (_isLoading)
                const Center(
                  child: LoadingWidget(),
                ),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            fixedColor: Colors.black,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
                _checkInternetConnectivity();
              });
              if (_webViewController != null) {
                _webViewController!.loadUrl(
                    urlRequest: URLRequest(url: WebUri(_urls[_currentIndex])));
                print(_webViewController!.loadUrl);
              }
            },
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home, color: Colors.black),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart, color: Colors.black),
                label: 'Stunting',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.baby_changing_station_outlined,
                  color: Colors.black,
                ),
                label: 'E-Asuh',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.pregnant_woman, color: Colors.black),
                label: 'Bumil Fit',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person, color: Colors.black),
                label: 'Dasawisma',
              ),
            ],
          ),
        ),
      ),
      onWillPop: () async {
        if (_webViewController != null) {
          if (await _webViewController!.canGoBack()) {
            _webViewController!.goBack();
            return false;
          }
        }
        return true;
      },
    );
  }
}
