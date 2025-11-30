import 'package:flutter/material.dart';
import '../data/local_branches_repository.dart';
import '../models/branch_models.dart';

class BranchSelectionScreen extends StatefulWidget {
  final Branch current;
  const BranchSelectionScreen({super.key, required this.current});

  @override
  State<BranchSelectionScreen> createState() => _BranchSelectionScreenState();
}

class _BranchSelectionScreenState extends State<BranchSelectionScreen> {
  final _repo = const LocalBranchesRepository();
  late List<Branch> _branches;

  bool _autoNearest = false;

  @override
  void initState() {
    super.initState();
    _branches = _repo.getBranches();
  }

  void _select(Branch b) {
    Navigator.of(context).pop<Branch>(b);
  }

  void _useNearest() {
    if (_branches.isEmpty) return;
    final nearest = _branches.reduce((a, b) => a.distanceKm <= b.distanceKm ? a : b);
    _select(nearest);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    final now = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: Text(isAr ? 'اختيار الفرع' : 'Select branch'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _branches.isEmpty
            ? _EmptyState(isAr: isAr)
            : Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: cs.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: cs.outlineVariant),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.near_me_outlined, color: cs.onSurfaceVariant),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                isAr ? 'اختيار أقرب فرع تلقائياً' : 'Auto-select nearest branch',
                                style: const TextStyle(fontWeight: FontWeight.w900),
                              ),
                            ),
                            Switch(
                              value: _autoNearest,
                              onChanged: (v) => setState(() => _autoNearest = v),
                            ),
                          ],
                        ),
                        if (_autoNearest) ...[
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: FilledButton.icon(
                              onPressed: _useNearest,
                              icon: const Icon(Icons.my_location),
                              label: Text(
                                isAr ? 'استخدم أقرب فرع' : 'Use nearest branch',
                                style: const TextStyle(fontWeight: FontWeight.w900),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  Expanded(
                    child: ListView.separated(
                      itemCount: _branches.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, i) {
                        final b = _branches[i];
                        final selected = b.id == widget.current.id;

                        final open = b.isOpenAt(now);
                        final openText = b.openBadgeText(context, now);

                        return Material(
                          color: cs.surface,
                          borderRadius: BorderRadius.circular(20),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () => _select(b),
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: selected ? cs.primary : cs.outlineVariant,
                                  width: selected ? 2 : 1,
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: cs.surfaceContainerHighest,
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(color: cs.outlineVariant),
                                    ),
                                    child: Icon(Icons.store_mall_directory_outlined,
                                        color: cs.onSurfaceVariant),
                                  ),
                                  const SizedBox(width: 12),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                b.nameFor(context),
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w900,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            if (selected)
                                              Icon(Icons.check_circle, color: cs.primary),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          b.addressFor(context),
                                          style: TextStyle(color: cs.onSurfaceVariant),
                                        ),
                                        const SizedBox(height: 10),

                                        Wrap(
                                          spacing: 8,
                                          runSpacing: 8,
                                          children: [
                                            _pill(
                                              cs,
                                              text: b.distanceText(context),
                                              icon: Icons.place_outlined,
                                            ),
                                            _pill(
                                              cs,
                                              text: '${isAr ? "الساعات" : "Hours"}: ${b.hoursText(context)}',
                                              icon: Icons.access_time,
                                            ),
                                            _pill(
                                              cs,
                                              text: openText,
                                              icon: open
                                                  ? Icons.check_circle_outline
                                                  : Icons.lock_clock_outlined,
                                              bg: open
                                                  ? Colors.green.withOpacity(0.12)
                                                  : cs.surfaceContainerHighest,
                                              fg: open ? Colors.green : cs.onSurfaceVariant,
                                            ),
                                          ],
                                        ),

                                        const SizedBox(height: 12),
                                        SizedBox(
                                          width: double.infinity,
                                          height: 48,
                                          child: FilledButton.tonalIcon(
                                            onPressed: () => _select(b),
                                            icon: const Icon(Icons.check),
                                            label: Text(
                                              isAr ? 'اختيار الفرع' : 'Select branch',
                                              style: const TextStyle(fontWeight: FontWeight.w900),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _pill(
    ColorScheme cs, {
    required String text,
    required IconData icon,
    Color? bg,
    Color? fg,
  }) {
    final _bg = bg ?? cs.surfaceContainerHighest;
    final _fg = fg ?? cs.onSurfaceVariant;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: _fg),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(color: _fg, fontWeight: FontWeight.w800, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool isAr;
  const _EmptyState({required this.isAr});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(Icons.store_outlined, color: cs.onSurfaceVariant),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isAr ? 'ما في فروع حالياً.' : 'No branches available.',
              style: TextStyle(color: cs.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }
}
