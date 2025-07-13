import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../auth/presentation/providers/auth_provider.dart';
import '../../history/presentation/providers/order_history_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final orderStats = ref.watch(orderStatisticsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Profil Saya',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Profile Header
            _buildProfileHeader(authState),
            const SizedBox(height: 24),

            // User Information Section
            _buildUserInformationSection(authState),
            const SizedBox(height: 20),

            // Account Statistics Section
            _buildAccountStatisticsSection(orderStats),
            const SizedBox(height: 20),

            // Quick Actions Section
            _buildQuickActionsSection(context),
            const SizedBox(height: 20),

            // App Information Section
            _buildAppInformationSection(),
            const SizedBox(height: 20),

            // Logout Button
            _buildLogoutButton(context, ref),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(AuthState authState) {
    final user = authState.user;
    final userName = user?.name ?? 'Pengguna';
    final userEmail = user?.email ?? 'email@example.com';

    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Color(0xFFE9ECEF)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Profile Avatar
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFFFF6B35),
                    const Color(0xFFFF6B35).withValues(alpha: 0.8),
                  ],
                ),
                border: Border.all(
                  color: const Color(0xFFFF6B35).withValues(alpha: 0.3),
                  width: 3,
                ),
              ),
              child: const Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 16),

            // User Name
            Text(
              userName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xFF212529),
              ),
            ),
            const SizedBox(height: 4),

            // User Email
            Text(
              userEmail,
              style: const TextStyle(fontSize: 16, color: Color(0xFF6C757D)),
            ),
            const SizedBox(height: 16),

            // Member Since
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F7FF),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFB3D9FF)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star, color: Color(0xFF007BFF), size: 16),
                  const SizedBox(width: 8),
                  Text(
                    'Member sejak ${user?.createdAt.year ?? DateTime.now().year}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF007BFF),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInformationSection(AuthState authState) {
    final user = authState.user;

    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE9ECEF)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6B35),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    'Informasi Pengguna',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF212529),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Name
            _buildInfoRow(
              icon: Icons.person,
              label: 'Nama Lengkap',
              value: user?.name ?? 'Belum diatur',
            ),
            const SizedBox(height: 16),

            // Email
            _buildInfoRow(
              icon: Icons.email,
              label: 'Email',
              value: user?.email ?? 'Belum diatur',
            ),
            const SizedBox(height: 16),

            // Phone Number
            _buildInfoRow(
              icon: Icons.phone,
              label: 'Nomor Telepon',
              value: user?.phoneNumber ?? 'Belum diatur',
            ),
            const SizedBox(height: 16),

            // Member Since
            _buildInfoRow(
              icon: Icons.calendar_today,
              label: 'Bergabung Sejak',
              value:
                  user?.createdAt != null
                      ? '${user!.createdAt.day}/${user.createdAt.month}/${user.createdAt.year}'
                      : 'Tidak diketahui',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountStatisticsSection(Map<String, dynamic> orderStats) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE9ECEF)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6B35),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.bar_chart,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    'Statistik Akun',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF212529),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.restaurant,
                    title: 'Total Pesanan',
                    value: '${orderStats['totalOrders']}',
                    color: const Color(0xFF007BFF),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.check_circle,
                    title: 'Selesai',
                    value: '${orderStats['completedOrders']}',
                    color: const Color(0xFF28A745),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.payment,
                    title: 'Total Belanja',
                    value: 'Rp ${orderStats['totalSpent'].toStringAsFixed(0)}',
                    color: const Color(0xFFFF6B35),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.pending,
                    title: 'Pending',
                    value: '${orderStats['pendingOrders']}',
                    color: const Color(0xFFFFC107),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionsSection(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE9ECEF)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6B35),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.flash_on,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    'Aksi Cepat',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF212529),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Quick Actions Row
            Row(
              children: [
                Expanded(
                  child: _buildQuickActionItem(
                    icon: Icons.history,
                    title: 'Riwayat',
                    subtitle: 'Pesanan',
                    onTap: () {
                      // TODO: Navigate to history
                      _showComingSoonDialog(context, 'Riwayat Pesanan');
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickActionItem(
                    icon: Icons.favorite,
                    title: 'Menu',
                    subtitle: 'Favorit',
                    onTap: () {
                      // TODO: Navigate to favorites
                      _showComingSoonDialog(context, 'Menu Favorit');
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickActionItem(
                    icon: Icons.support_agent,
                    title: 'Bantuan',
                    subtitle: 'Support',
                    onTap: () {
                      // TODO: Navigate to support
                      _showComingSoonDialog(context, 'Bantuan');
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppInformationSection() {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE9ECEF)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6B35),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.info, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    'Informasi Aplikasi',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF212529),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // App Version
            _buildInfoRow(
              icon: Icons.apps,
              label: 'Versi Aplikasi',
              value: '1.0.0',
            ),
            const SizedBox(height: 16),

            // Environment
            _buildInfoRow(
              icon: Icons.computer,
              label: 'Environment',
              value: 'Production',
            ),
            const SizedBox(height: 16),

            // Build Number
            _buildInfoRow(
              icon: Icons.build,
              label: 'Build Number',
              value: '100',
            ),
            const SizedBox(height: 16),

            // Last Updated
            _buildInfoRow(
              icon: Icons.update,
              label: 'Terakhir Update',
              value: 'Juli 2025',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF6C757D)),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF6C757D),
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF212529),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: Color(0xFF6C757D)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE9ECEF)),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B35).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: const Color(0xFFFF6B35), size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF212529),
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 10, color: Color(0xFF6C757D)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () => _showLogoutDialog(context, ref),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFDC3545),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 2,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout, size: 20),
            SizedBox(width: 8),
            Text(
              'Keluar',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  void _showComingSoonDialog(BuildContext context, String feature) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Segera Hadir'),
            content: Text(
              'Fitur $feature akan segera tersedia dalam update mendatang.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Konfirmasi Keluar'),
            content: const Text(
              'Apakah Anda yakin ingin keluar dari aplikasi?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).pop();

                  // Show loading
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder:
                        (context) => const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFFFF6B35),
                          ),
                        ),
                  );

                  try {
                    // Perform logout
                    await ref.read(authProvider.notifier).logout();

                    // Hide loading and navigate to login
                    if (context.mounted) {
                      Navigator.of(context).pop();
                      context.go('/login');
                    }
                  } catch (e) {
                    // Hide loading and show error
                    if (context.mounted) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Gagal keluar: $e'),
                          backgroundColor: const Color(0xFFDC3545),
                        ),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDC3545),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Keluar'),
              ),
            ],
          ),
    );
  }
}
