import 'package:flutter/material.dart';
import 'package:rimac_app/config/config.dart';

class MeScreen extends StatelessWidget {
  const MeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppTheme.white,
      body: Stack(
        children: [
          Positioned(
            top: -100,
            right: -100,
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

          // 2. Contenido Principal
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                // Título
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    'Seguros para ti',
                    style: textTheme.headlineLarge?.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                      fontSize: 28,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const _CategorySelector(),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 16,
                    ),
                    children: [
                      _buildInsuranceItem(
                        context,
                        imageUrl:
                            'https://images.unsplash.com/photo-1449965408869-eaa3f722e40d?q=80&w=200&auto=format&fit=crop', // Auto
                        badgeText: 'Hasta 35% dscto.',
                        title: 'Seguro Vehicular',
                        subtitle: 'El #1 del mercado',
                      ),
                      _buildDivider(),

                      _buildInsuranceItem(
                        context,
                        imageUrl:
                            'https://images.unsplash.com/photo-1549317661-bd32c8ce0db2?q=80&w=200&auto=format&fit=crop', // Pareja en auto/soat
                        badgeText: 'Desde S/35',
                        title: 'SOAT',
                        subtitle: 'Te ofrecemos\nmáxima protección',
                      ),
                      _buildDivider(),

                      _buildInsuranceItem(
                        context,
                        imageUrl:
                            'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?q=80&w=200&auto=format&fit=crop', // Playa
                        badgeText: 'Hasta 20% dscto.',
                        title: 'Seguro de Viajes',
                        subtitle: 'Disfruta tu viaje sin\npreocupaciones',
                      ),
                      _buildDivider(),

                      _buildInsuranceItem(
                        context,
                        imageUrl:
                            'https://images.unsplash.com/photo-1511895426328-dc8714191300?q=80&w=200&auto=format&fit=crop', // Familia
                        badgeText: 'Vale de S/100 sin sorteos',
                        title: 'Seguro Vida Ahorro\ncon devolución',
                        subtitle: 'Hasta 200% de tus\naportes devueltos',
                      ),
                      _buildDivider(),

                      _buildInsuranceItem(
                        context,
                        imageUrl:
                            'https://images.unsplash.com/photo-1576091160399-112ba8d25d1d?q=80&w=200&auto=format&fit=crop', // Salud
                        badgeText: 'Hasta 20% Dscto',
                        title: 'Seguro Salud',
                        subtitle: 'Atiéndete en más de\n300 clínicas',
                      ),
                      // Espacio extra para el scroll
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 24.0),
      child: Divider(height: 1, color: AppTheme.mediumGray),
    );
  }

  Widget _buildInsuranceItem(
    BuildContext context, {
    required String imageUrl,
    required String badgeText,
    required String title,
    required String subtitle,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: () {},
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
              color: AppTheme.mediumGray,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Badge Rosa
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.vibrantPink,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    badgeText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppTheme.darkBgPrimary,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppTheme.darkGray,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 24.0, left: 8.0),
            child: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black),
          ),
        ],
      ),
    );
  }
}

class _CategorySelector extends StatelessWidget {
  const _CategorySelector();

  @override
  Widget build(BuildContext context) {
    final categories = [
      "Todos",
      "Vehículos",
      "Viajes",
      "Vida",
      "Salud",
      "Vida Inversión",
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        children: categories.map((category) {
          final isSelected = category == "Todos";
          return Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: _buildChip(context, category, isSelected),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildChip(BuildContext context, String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF11142D) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected ? const Color(0xFF11142D) : AppTheme.darkBgPrimary,
          width: 1.5,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : AppTheme.darkBgPrimary,
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
      ),
    );
  }
}
