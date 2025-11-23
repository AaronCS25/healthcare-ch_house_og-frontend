import 'package:flutter/material.dart';
import 'package:rimac_app/config/config.dart';

// --- COPIA LOCAL DEL THEME (Para funcionamiento autónomo) ---

class WelfareScreen extends StatelessWidget {
  const WelfareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final Color estarBienGreen = const Color(0xFF00E676);

    return Scaffold(
      backgroundColor: AppTheme.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Estar Bien',
                    style: textTheme.headlineLarge?.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                      fontSize: 26,
                    ),
                  ),
                  // Logos simulados derecha
                  Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: estarBienGreen,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.sentiment_satisfied_alt,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Texto simulando logo RIMAC
                      const Text(
                        'RIMAC',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  _buildTopTabItem(context, 'Recursos', false),
                  _buildTopTabItem(context, 'Retos', false),
                  _buildTopTabItem(context, 'Metas', true),
                  _buildTopTabItem(context, 'Sincronización', false),
                ],
              ),
            ),
            const Divider(height: 1, color: AppTheme.mediumGray),

            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Título Sección
                      Text(
                        'Elige una meta',
                        style: textTheme.headlineMedium?.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Filtros (Chips)
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildFilterChip(context, 'Todo', true),
                            const SizedBox(width: 12),
                            _buildFilterChip(context, 'Actividad', false),
                            const SizedBox(width: 12),
                            _buildFilterChip(context, 'Nutrición', false),
                            const SizedBox(width: 12),
                            _buildFilterChip(context, 'Sueño', false),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      _buildGoalCard(
                        context,
                        tag: 'NUTRICIÓN',
                        title: 'Bebe más agua y\nmantente hidratado',
                        subtitle: 'Cumplimiento manual',
                        imageUrl:
                            'https://images.unsplash.com/photo-1548839140-29a749e1cf4d?q=80&w=200&auto=format&fit=crop', // Mujer bebiendo agua
                      ),
                      const SizedBox(height: 16),
                      _buildGoalCard(
                        context,
                        tag: 'MINDFULNESS',
                        title: 'Cultiva tu calma\ninterior meditando',
                        subtitle: 'Cumplimiento manual',
                        imageUrl:
                            'https://images.unsplash.com/photo-1506126613408-eca07ce68773?q=80&w=200&auto=format&fit=crop', // Yoga/Meditación
                      ),
                      const SizedBox(height: 16),
                      _buildGoalCard(
                        context,
                        tag: 'ACTIVIDAD',
                        title: 'Ejercítate corriendo',
                        subtitle: 'Cumplimiento automático',
                        imageUrl:
                            'https://images.unsplash.com/photo-1552674605-1e94dd2690f8?q=80&w=200&auto=format&fit=crop', // Corriendo
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopTabItem(BuildContext context, String text, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 24.0),
      padding: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        border: isSelected
            ? const Border(bottom: BorderSide(color: Colors.black, width: 3.0))
            : null,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          color: isSelected ? Colors.black : AppTheme.gray500,
        ),
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? Colors.black : Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.black, width: 1.5),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildGoalCard(
    BuildContext context, {
    required String tag,
    required String title,
    required String subtitle,
    required String imageUrl,
  }) {
    final textTheme = Theme.of(context).textTheme;
    final Color tagPurpleBg = const Color(0xFFFAE8FF);
    final Color tagPurpleText = const Color(0xFFD946EF);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: AppTheme.mediumGray.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          // Imagen Cuadrada
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
              color: AppTheme.mediumGray,
            ),
          ),
          const SizedBox(width: 16),

          // Contenido
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: tagPurpleBg,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    tag,
                    style: TextStyle(
                      color: tagPurpleText,
                      fontWeight: FontWeight.w800,
                      fontSize: 10,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: textTheme.bodySmall?.copyWith(color: AppTheme.gray500),
                ),
              ],
            ),
          ),

          // Botón Flecha
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black, width: 1.5),
            ),
            child: const Icon(
              Icons.arrow_forward,
              size: 16,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
