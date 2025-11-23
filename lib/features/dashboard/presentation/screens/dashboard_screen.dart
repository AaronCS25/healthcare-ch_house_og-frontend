import 'package:flutter/material.dart';
import 'package:rimac_app/config/config.dart' show AppTheme;

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    const Color linkBlue = Color(0xFF4F46E5);

    return Scaffold(
      backgroundColor: AppTheme.white,
      body: Stack(
        children: [
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppTheme.vibrantPink.withValues(alpha: 0.15),
                    AppTheme.white.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 16.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.person_outline,
                          size: 28,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 110,
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildPromoCard(
                          context,
                          icon: Icons.casino_outlined,
                          text:
                              '¡Gana cada mes\ngirando la ruleta de la\nsuerte!',
                          width: 260,
                        ),
                        const SizedBox(width: 16),
                        _buildPromoCard(
                          context,
                          icon: Icons.local_offer_outlined,
                          text: 'Descuentos exclusivos\npara ti',
                          width: 200,
                          isPartial: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Seguros',
                          style: textTheme.headlineMedium?.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                            fontSize: 22,
                          ),
                        ),
                        Text(
                          'Ver todos',
                          style: textTheme.labelLarge?.copyWith(
                            color: linkBlue,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: _buildMainInsuranceCard(context),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24.0),
                    width: double.infinity,
                    height: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F3FF),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.mediumGray),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'cuidafarma',
                                  style: TextStyle(
                                    color: Color(0xFF5B6BC0),
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                RichText(
                                  text: const TextSpan(
                                    style: TextStyle(
                                      fontFamily: 'Geist',
                                      color: linkBlue,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'Hasta ',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      TextSpan(
                                        text: '25%',
                                        style: TextStyle(
                                          fontSize: 32,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '\ndscto.\nen nuestros productos',
                                        style: TextStyle(
                                          fontSize: 10,
                                          height: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        Expanded(
                          flex: 3,
                          child: Image.network(
                            'https://images.unsplash.com/photo-1620916566398-39f1143ab7be?q=80&w=300&auto=format&fit=crop',
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(right: 16.0),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(
                      'Asistencias',
                      style: textTheme.headlineMedium?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: 22,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildAssistanceItem(
                          context,
                          icon: Icons.local_hospital_outlined,
                          label: 'Buscador\nde clínicas',
                          isSearch: true,
                        ),
                        _buildAssistanceItem(
                          context,
                          icon: Icons.videocam_outlined,
                          label: 'Atención\nmédica virtual',
                          isSearch: false,
                        ),
                        _buildAssistanceItem(
                          context,
                          icon: Icons.home_outlined,
                          label: 'Médico a\ndomicilio',
                          isSearch: false,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoCard(
    BuildContext context, {
    required IconData icon,
    required String text,
    required double width,
    bool isPartial = false,
  }) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.mediumGray),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: Icon(icon, color: Colors.black87, size: 32),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    text,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      height: 1.2,
                      color: Colors.black,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (!isPartial)
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: Colors.black,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainInsuranceCard(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    const Color linkBlue = Color(0xFF4F46E5);
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(color: linkBlue.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Seguro EPS',
                  style: textTheme.titleLarge?.copyWith(
                    color: AppTheme.darkGray,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 16),
                _buildInfoText('Titular: ', 'Arteaga Montes Stuart Diego'),
                const SizedBox(height: 6),
                _buildInfoText('Contratante: ', 'Dec Services S.a.c.'),
              ],
            ),
          ),

          const Column(
            children: [
              SizedBox(height: 8),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(Icons.person_outline, size: 40, color: Colors.black),
                  Positioned(
                    bottom: 0,
                    right: -4,
                    child: Icon(
                      Icons.favorite,
                      size: 18,
                      color: AppTheme.rimacRed,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoText(String label, String value) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 13,
          height: 1.4,
          color: AppTheme.darkGray,
        ),
        children: [
          TextSpan(
            text: label,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          TextSpan(
            text: value,
            style: const TextStyle(fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }

  Widget _buildAssistanceItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required bool isSearch,
  }) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppTheme.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(icon, size: 36, color: AppTheme.darkBgPrimary),

              if (isSearch)
                Positioned(
                  bottom: 18,
                  right: 18,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.search,
                      size: 14,
                      color: AppTheme.rimacRed,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Colors.black,
            height: 1.2,
          ),
        ),
      ],
    );
  }
}
