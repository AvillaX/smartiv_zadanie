import 'package:flutter/material.dart';

class ExpandableContentWidget extends StatefulWidget {
  final Widget child;
  final double collapsedHeight;

  const ExpandableContentWidget({
    super.key,
    required this.child,
    this.collapsedHeight = 500.0,
  });

  @override
  State<ExpandableContentWidget> createState() => _ExpandableContentWidgetState();
}

class _ExpandableContentWidgetState extends State<ExpandableContentWidget> with SingleTickerProviderStateMixin {
  final GlobalKey _contentKey = GlobalKey();
  bool _expanded = false;
  bool _overflows = false;
  Size _latestSize = Size.zero;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => _checkForOverflow());
  }

  void _checkForOverflow() {
    final RenderBox? renderBox = _contentKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final contentHeight = renderBox.size.height;

      if (_latestSize.height != contentHeight) {
        _latestSize = renderBox.size;
        setState(() {
          _overflows = contentHeight > widget.collapsedHeight;
        });
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => _checkForOverflow());
  }

  void _toggleExpansion() {
    setState(() {
      _expanded = !_expanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Column(
        children: [
          Stack(
            children: [
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.linear,
                alignment: Alignment.topCenter,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  constraints: BoxConstraints(
                    maxHeight: _expanded ? double.infinity : widget.collapsedHeight,
                  ),
                  child: ClipRect(
                    child: SingleChildScrollView(
                      physics: NeverScrollableScrollPhysics(),
                      child: Container(
                        key: _contentKey,
                        child: widget.child,
                      ),
                    ),
                  ),
                ),
              ),
              if (!_expanded) _bottomBlur(),
            ],
          ),
          if (_overflows) _bottomButton(),
        ],
      ),
    );
  }

  Widget _bottomBlur() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 100,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white10,
              Colors.white,
            ],
          ),
        ),
        child: SizedBox.shrink(),
      ),
    );
  }

  Widget _bottomButton() {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.all(10),
      child: ElevatedButton(
        onPressed: _toggleExpansion,
        child: Text(_expanded ? 'Zwiń' : "Rozwiń"),
      ),
    );
  }
}
