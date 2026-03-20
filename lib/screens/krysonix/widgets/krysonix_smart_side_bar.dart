import 'package:flutter/material.dart';

class SmartSidebar extends StatefulWidget {
  final Widget child; // main screen content
  final List<Widget> sidebarItems;

  const SmartSidebar({
    super.key,
    required this.child,
    required this.sidebarItems,
  });

  @override
  _SmartSidebarState createState() => _SmartSidebarState();
}

class _SmartSidebarState extends State<SmartSidebar> {
  bool isOpen = false;
  final double collapsedWidth = 20;
  final double expandedWidth = 100;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main screen
        widget.child,

        // Overlay when sidebar is open
        if (isOpen)
          Positioned.fill(
            child: GestureDetector(
              onTap: () => setState(() => isOpen = false),
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),

        // Sidebar
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          right: isOpen ? 0 : -expandedWidth + collapsedWidth,
          top: 100, // 👈 makes sidebar full height
          child: GestureDetector(
            behavior: HitTestBehavior.translucent, // 👈 ensures collapsed strip is tappable
            onHorizontalDragUpdate: (details) {
              if (details.delta.dx > 5) {
                setState(() => isOpen = true);
              } else if (details.delta.dx < -5) {
                setState(() => isOpen = false);
              }
            },
            onTap: ()=> setState(() => isOpen = !isOpen),
            child: Container(
              width: expandedWidth,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.9),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.sidebarItems,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
