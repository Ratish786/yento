import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Exploredialog extends StatefulWidget {
  const Exploredialog({super.key});

  @override
  State<Exploredialog> createState() => _ExploredialogState();
}

class _ExploredialogState extends State<Exploredialog> {
  final List<String> _categories = [
    'Restaurants',
    'Bars',
    'Cafes',
    'Activities',
    'Parks',
    'Museums',
    'Shopping',
  ];

  int _selectedCategoryIndex = 0;
  double _radiusMiles = 20;

  bool _showResults = false;
  int _nearbyResults = 0;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Container(
        height: height * 0.9,
        width: width * 0.9,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF334155) : Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            // ================= HEADER =================
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(
                          Icons.flash_on_outlined,
                          color: Color(0xff3B82F6),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'Explore Nearby',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(
                      Icons.close,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 1,
              color: isDark ? Colors.grey[700] : Colors.grey[300],
            ),

            // ================= BODY =================
            Expanded(
              child: Container(
                color: isDark ? const Color(0xFF1E293B) : const Color(0xfff4f4f5),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: _showResults
                      ? _buildResultContainer(isDark)
                      : _buildSearchBody(isDark),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- Search body (categories + radius + button) ----------
  Widget _buildSearchBody(bool isDark) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildCategoriesCard(isDark),
          const SizedBox(height: 16),
          _buildRadiusCard(isDark),
          const SizedBox(height: 24),
          _buildUseLocationButton(isDark),
        ],
      ),
    );
  }

  // ---------- Categories Card ----------
  Widget _buildCategoriesCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF334155) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: isDark
            ? null
            : [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What are you looking for?',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(_categories.length, (index) {
              final isSelected = _selectedCategoryIndex == index;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCategoryIndex = index;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xff3B82F6)
                        : (isDark
                        ? const Color(0xFF475569)
                        : const Color(0xffe5e7eb)),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Text(
                    _categories[index],
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : (isDark ? Colors.grey[300] : const Color(0xff111827)),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // ---------- Radius Card ----------
  Widget _buildRadiusCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF334155) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: isDark
            ? null
            : [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + current value
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Search Radius',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              Text(
                '${_radiusMiles.round()} miles',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff3B82F6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Slider
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xff3B82F6),
              inactiveTrackColor: isDark
                  ? const Color(0xFF475569)
                  : const Color(0xffe5e7eb),
              thumbColor: const Color(0xff3B82F6),
              overlayColor: const Color(0xff3B82F6).withOpacity(0.1),
            ),
            child: Slider(
              min: 1,
              max: 20,
              value: _radiusMiles,
              onChanged: (value) {
                setState(() {
                  _radiusMiles = value;
                });
              },
            ),
          ),

          // Min / Max labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '1 mi',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.grey[500] : const Color(0xff9ca3af),
                ),
              ),
              Text(
                '20 mi',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.grey[500] : const Color(0xff9ca3af),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------- Use My Location Button ----------
  Widget _buildUseLocationButton(bool isDark) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: isDark
              ? const Color(0xff3B82F6)
              : const Color(0xff020617),
          foregroundColor: Colors.white,
          elevation: isDark ? 0 : 6,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        icon: const Icon(Icons.location_on_outlined),
        label: const Text(
          'Use My Location',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        onPressed: () async {
          // TODO: handle location permission + fetching real results
          setState(() {
            _nearbyResults = 0;
            _showResults = true;
          });
        },
      ),
    );
  }

  // ---------- Result Container (shown after tapping Use My Location) ----------
  Widget _buildResultContainer(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$_nearbyResults Result Nearby',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _showResults = false;
                });
              },
              child: const Text(
                'Change search',
                style: TextStyle(color: Color(0xff3B82F6)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Center(
            child: Text(
              'No places found. Try increasing the radius.',
              style: TextStyle(
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}