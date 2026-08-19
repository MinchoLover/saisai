import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/saisai_bottom_nav.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('마이')),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: AppTheme.line)),
              child: const Row(
                children: [
                  CircleAvatar(
                      radius: 32,
                      backgroundColor: AppTheme.mint,
                      child: Text('🧭', style: TextStyle(fontSize: 30))),
                  SizedBox(width: 15),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text('찹츄',
                            style: TextStyle(
                                fontSize: 19, fontWeight: FontWeight.w900)),
                        SizedBox(height: 4),
                        Text('chapchuuu@handong.ac.kr',
                            style: TextStyle(color: AppTheme.muted))
                      ])),
                  Text('수정',
                      style: TextStyle(
                          color: AppTheme.primary,
                          fontWeight: FontWeight.w700)),
                ],
              ),
            ),
            const SizedBox(height: 22),
            _MenuCard(
              icon: Icons.route_rounded,
              title: '경로 기록',
              subtitle: '지금까지 만든 코스와 저장한 장소',
              trailing: '3개',
              onTap: () => context.go('/history'),
            ),
            const SizedBox(height: 10),
            _MenuCard(
                icon: Icons.notifications_none_rounded,
                title: '앱 설정',
                subtitle: '알림 · 위치 권한',
                onTap: () {}),
            const SizedBox(height: 10),
            _MenuCard(
                icon: Icons.policy_outlined,
                title: '약관 및 정책',
                subtitle: '개인정보 처리방침',
                onTap: () {}),
            const SizedBox(height: 10),
            _MenuCard(
                icon: Icons.headset_mic_outlined,
                title: '고객센터',
                subtitle: '평일 10:00 – 18:00',
                trailing: '010-7518-7017',
                onTap: () {}),
            const SizedBox(height: 28),
            OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(54),
                    side: const BorderSide(color: AppTheme.line)),
                child: const Text('로그아웃',
                    style: TextStyle(color: AppTheme.muted))),
          ],
        ),
        bottomNavigationBar: const SaisaiBottomNav(index: 2),
      );
}

class _MenuCard extends StatelessWidget {
  const _MenuCard(
      {required this.icon,
      required this.title,
      required this.subtitle,
      required this.onTap,
      this.trailing});
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final String? trailing;

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Container(
            padding: const EdgeInsets.all(17),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppTheme.line)),
            child: Row(
              children: [
                Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                        color: AppTheme.mint,
                        borderRadius: BorderRadius.circular(12)),
                    child: Icon(icon, color: AppTheme.primary)),
                const SizedBox(width: 13),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text(title,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 3),
                      Text(subtitle,
                          style: const TextStyle(
                              color: AppTheme.muted, fontSize: 13))
                    ])),
                if (trailing != null)
                  Text(trailing!, style: const TextStyle(color: AppTheme.muted))
                else
                  const Icon(Icons.chevron_right_rounded,
                      color: AppTheme.muted),
              ],
            ),
          ),
        ),
      );
}
