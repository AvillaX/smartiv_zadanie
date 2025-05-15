import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:zadanie/expandable_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: HomeScreen()),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<dynamic> contentItems = const [
    '<h1>Tytuł H1</h1><p>To jest paragraf tekstu z <strong>pogrubieniem</strong>.</p>',
    'https://placehold.co/600x400/png',
    '<ol><li>Element 1</li><li>Element 2</li></ol>',
    'https://placehold.co/300x200/png',
    'https://placehold.co/300x200/png',
    '<p>Kolejny długi tekst, który może spowodować przekroczenie wysokości...</p>',
  ];

  Widget _buildItem(BuildContext context, dynamic item) {
    if (item is String) {
      if ((item.startsWith('http://') || item.startsWith('https://'))) {
        return Image.network(
          item,
          fit: BoxFit.fitWidth,
          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },
        );
      } else {
        return HtmlWidget(item);
      }
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rozwijana zawartosc'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: ExpandableContentWidget(
            child: Column(
              children: contentItems.map((item) => _buildItem(context, item)).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
