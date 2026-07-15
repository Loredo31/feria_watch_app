// import 'package:flutter/material.dart';

// class SafeScroll extends StatelessWidget {
//   final Widget child;
//   final double topSpacing;
//   final double bottomSpacing;
//   final double horizontalSpacing;
//   final ScrollController? controller;

//   const SafeScroll({
//     super.key, 
//     required this.child, 
//     this.topSpacing = 0.12, 
//     this.bottomSpacing = 0.12, 
//     this.horizontalSpacing = 0.09, 
//     this.controller,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.sizeOf(context);

//     return SingleChildScrollView(
//       controller: controller,
//       physics: const BouncingScrollPhysics(),
//       padding: EdgeInsets.only(
//         top: size.height * topSpacing,
//         bottom: size.height * bottomSpacing,
//         left: size.width * horizontalSpacing,
//         right: size.width * horizontalSpacing,
//       ),
//       child: child,
//     );
//   }
// }






import 'package:flutter/material.dart';

class SafeScroll extends StatelessWidget {
  /// Inset lateral estándar (9% del ancho de pantalla) usado como
  /// referencia por otros widgets que necesitan el mismo margen seguro
  /// pero no pueden usar SafeScroll directamente (p. ej. overlays flotantes).
  static const double defaultInset = 0.09;

  final Widget child;
  final double topSpacing;
  final double bottomSpacing;
  final double horizontalSpacing;
  final ScrollController? controller;

  const SafeScroll({
    super.key, 
    required this.child, 
    this.topSpacing = 0.12, 
    this.bottomSpacing = 0.12, 
    this.horizontalSpacing = defaultInset, 
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return SingleChildScrollView(
      controller: controller,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.only(
        top: size.height * topSpacing,
        bottom: size.height * bottomSpacing,
        left: size.width * horizontalSpacing,
        right: size.width * horizontalSpacing,
      ),
      child: child,
    );
  }
}