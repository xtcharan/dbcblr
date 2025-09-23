import 'package:flutter/material.dart';
import '../../../shared/models/user.dart';
import '../../../shared/widgets/shimmer_wrapper.dart';
import '../../../shared/utils/toast.dart';
import '../../../shared/models/badge.dart' as models; // for latest 3 badges

class ProfileHeaderSection extends StatelessWidget {
  const ProfileHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final user = User.fake();
    final houseColor = _houseColor(user.houseId);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: houseColor,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 48, 24, 36),
      child: Column(
        children: [
          // avatar + camera overlay
          Stack(
            children: [
              ShimmerWrapper(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40, color: Colors.grey[400]),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: InkWell(
                  onTap: () => showToast('Change photo coming soon'),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      size: 20,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // name
          Text(
            '${user.firstName} ${user.lastName}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          // house
          Text(
            user.houseId.toUpperCase(),
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          // points row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.star, color: Colors.white, size: 18),
              const SizedBox(width: 6),
              Text(
                '1250 Points',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.95),
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // latest 3 badges
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...models.Badge.fakeList()
                  .take(3)
                  .map((b) => _badgeChip(b, context)),
            ],
          ),
        ],
      ),
    );
  }

  // helpers ------------------------------------------------------------------
  Color _houseColor(String id) => switch (id) {
    'ruby' => Colors.red,
    'sapphire' => Colors.blue,
    'topaz' => Colors.orange,
    'emerald' => Colors.green,
    _ => Colors.indigo,
  };

  Widget _badgeChip(models.Badge badge, BuildContext context) {
    final color = _tierColor(badge.tier);
    return GestureDetector(
      onTap: () => showToast('${badge.title} – tap Achievements for full list'),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          shape: BoxShape.circle,
          border: Border.all(color: color, width: 2),
        ),
        child: Center(
          child: Text(badge.icon, style: const TextStyle(fontSize: 16)),
        ),
      ),
    );
  }

  Color _tierColor(String tier) => switch (tier) {
    'bronze' => Colors.brown,
    'silver' => Colors.grey,
    'gold' => Colors.amber,
    'platinum' => Colors.indigo,
    _ => Colors.blue,
  };
}
