import 'package:flutter/material.dart';

class ConnectionFailedWidget extends StatelessWidget {
  final Function onRetry;

  const ConnectionFailedWidget({Key? key, required this.onRetry})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.signal_wifi_off,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          const Text(
            'Koneksi Gagal',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tidak ada koneksi internet. Periksa kembali koneksi internet Anda.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => onRetry(),
            child: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }
}
