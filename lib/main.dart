
import 'package:flutter/material.dart';
// ============================================================
// ЦВЕТА
// ============================================================
class AppColors {
  static const background = Color(0xFF17161B);
  static const card = Color(0xFF232228);
  static const orange = Color(0xFFFF5A36);
  static const white = Color(0xFFFFFFFF);
  static const textGray = Color(0xFFA5A3AB);
  static const dotInactive = Color(0xFF4A4950);
  static const iconCircleBg = Color(0x59000000); // black 35% opacity
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Roboto',
        brightness: Brightness.dark,
      ),
      home: const ProductDetailScreen(),
    );
  }
}

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Заменитб:
  // 'assets/images/headphones_1.png'
  final List<String> _images = const [
    'https://images.unsplash.com/photo-1546435770-a3e426bf472b?w=800&q=80',
    'https://images.unsplash.com/photo-1583394838336-acd977736f90?w=800&q=80',
    'https://images.unsplash.com/photo-1487215078519-e21cc028cb29?w=800&q=80',
    'https://images.unsplash.com/photo-1524678606370-a47ad25cb82a?w=800&q=80',
    'https://images.unsplash.com/photo-1545127398-14699f92334b?w=800&q=80',
  ];

  bool _isFavorite = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildImageGallery(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitle(),
                  const SizedBox(height: 8),
                  _buildPriceRow(),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Описание'),
                  const SizedBox(height: 12),
                  _buildDescriptionCard(),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Продавец'),
                  const SizedBox(height: 12),
                  _buildSellerCard(),
                  const SizedBox(height: 20),
                  _buildContactButton(),
                  const SizedBox(height: 16),
                  Center(child: _buildReportButton()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // ГАЛЕРЕЯ ИЗРБРАЖЕНИЙ  ИНДИКАТОРЫ  КНОПКИ СВЕРХУ
  // ------------------------------------------------------------
  Widget _buildImageGallery(BuildContext context) {
    return SizedBox(
      height: 320,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Свайпаемые фото товара
            PageView.builder(
              controller: _pageController,
              itemCount: _images.length,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              itemBuilder: (context, index) {
                return Image.network(
                  _images[index],
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      color: AppColors.card,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.orange,
                          strokeWidth: 2,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: AppColors.card,
                  ),
                );
              },
            ),

            //  назад / избранное / поделиться
            Positioned(
              top: MediaQuery.of(context).padding.top + 8,
              left: 16,
              right: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _CircleIconButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    hasBackground: false,
                    onTap: () => Navigator.of(context).maybePop(),
                  ),
                  Row(
                    children: [
                      _CircleIconButton(
                        icon: _isFavorite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        onTap: () {
                          setState(() => _isFavorite = !_isFavorite);
                        },
                      ),
                      const SizedBox(width: 10),
                      _CircleIconButton(
                        icon: Icons.ios_share_rounded,
                        onTap: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Точки-индикаторы страниц
            Positioned(
              bottom: 14,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_images.length, (index) {
                  final isActive = index == _currentPage;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActive ? AppColors.orange : AppColors.dotInactive,
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // ЗАГОЛОВОК ТОВАРА
  // ------------------------------------------------------------
  Widget _buildTitle() {
    return const Text(
      'Наушники Beats by Dre',
      style: TextStyle(
        color: AppColors.white,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  // ------------------------------------------------------------
  // ЦЕНА
  // ------------------------------------------------------------
  Widget _buildPriceRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        const Text(
          '400 000 ₩',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: 10),
        const Text(
          'Договорная',
          style: TextStyle(
            color: AppColors.orange,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // ЗАГОЛОВОК
  // ------------------------------------------------------------
  Widget _buildSectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.white,
        fontSize: 17,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  // ------------------------------------------------------------
  // ОПИСАНИЕ ТОВАРА
  // ------------------------------------------------------------
  Widget _buildDescriptionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Text(
        'Эти наушники — верный спутник в мире звука и стиля. С их '
        'элегантным дизайном и превосходным качеством звучания вы '
        'погружаетесь в музыкальный опыт нового уровня. Наушники '
        'идеально сбалансированы между комфортом и функциональностью, '
        'обеспечивая чистоту звука и ясные высокие частоты. Идеальный '
        'выбор для тех, кто ценит каждую ноту и стремится к идеальному '
        'звучанию в любой обстановке.',
        style: TextStyle(
          color: AppColors.textGray,
          fontSize: 14,
          height: 1.5,
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // КАРТАЧКА ПРОДАВЦА
  // ------------------------------------------------------------
  Widget _buildSellerCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.dotInactive,
            backgroundImage: NetworkImage(
              'https://images.unsplash.com/photo-1633332755192-727a05c4013d?w=200&q=80',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Иванов Иван',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: const [
                    Icon(Icons.star_rounded, color: AppColors.orange, size: 16),
                    SizedBox(width: 4),
                    Text(
                      'Отзывы ',
                      style: TextStyle(color: AppColors.textGray, fontSize: 13),
                    ),
                    Text(
                      '(20)',
                      style: TextStyle(color: AppColors.textGray, fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textGray,
            size: 24,
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // КНОПКА СВЯЗТЬСЯ С ПРОДАВЦОМ
  // ------------------------------------------------------------
  Widget _buildContactButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.orange,
          foregroundColor: AppColors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Text(
          'Связаться с продавцом',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // КНОПКА ПОЖАЛОВАТЬСЯ
  // ------------------------------------------------------------
  Widget _buildReportButton() {
    return TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(
        backgroundColor: AppColors.card,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text(
            'Пожаловаться',
            style: TextStyle(
              color: AppColors.orange,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 6),
          Icon(Icons.warning_amber_rounded, color: AppColors.orange, size: 16),
        ],
      ),
    );
  }
}

// ============================================================
// КРУГЛАЯ ИКОНКАКНОПКА НАЗАД  ИЗБРАННОЕ  ПОДЕЛИТБЯ
// ============================================================
class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool hasBackground;

  const _CircleIconButton({
    required this.icon,
    required this.onTap,
    this.hasBackground = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: 38,
        height: 38,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: hasBackground ? AppColors.iconCircleBg : Colors.transparent,
        ),
        child: Icon(icon, color: AppColors.white, size: 18),
      ),
    );
  }
}