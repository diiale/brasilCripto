import 'package:flutter/material.dart';
import '../../core/utils/formatters.dart';
import '../../domain/entities/coin.dart';
import 'change_badge.dart';

class CoinListTile extends StatelessWidget {
  final Coin coin;
  final VoidCallback? onTap;
  final VoidCallback? onFavorite;
  final bool showFavoriteAction;
  final bool isFavorite;

  final Widget? trailingAction;

  const CoinListTile({
    super.key,
    required this.coin,
    this.onTap,
    this.onFavorite,
    this.showFavoriteAction = true,
    this.isFavorite = false,
    this.trailingAction, // NOVO
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      elevation: 0,
      color: cs.surfaceContainerHighest.withOpacity(.35),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Hero(
                tag: 'coin:${coin.id}',
                child: CircleAvatar(
                  radius: 22,
                  backgroundColor: cs.surfaceVariant,
                  backgroundImage: NetworkImage(coin.imageUrl),
                  onBackgroundImageError: (_, __) {},
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${coin.name} (${coin.symbol})',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 10,
                      runSpacing: 6,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text('Preço: ${BrFormat.moeda(coin.price)}'),
                        Text('MC: ${BrFormat.moedaCompact(coin.marketCap)}'),
                        Text('Vol: ${BrFormat.moedaCompact(coin.volume24h)}'),

                        if (trailingAction != null)
                          trailingAction!
                        else if (showFavoriteAction)
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 220),
                            transitionBuilder: (child, anim) =>
                                FadeTransition(opacity: anim, child: ScaleTransition(scale: anim, child: child)),
                            child: isFavorite
                                ? FilledButton.icon(
                              key: const ValueKey('fav-on'),
                              onPressed: () async {
                                final confirmed = await showDialog<bool>(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text('Remover dos favoritos?'),
                                    content: Text('Deseja remover ${coin.name} da sua lista de favoritos?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.of(ctx).pop(false),
                                        child: const Text('Cancelar'),
                                      ),
                                      FilledButton(
                                        onPressed: () => Navigator.of(ctx).pop(true),
                                        child: const Text('Remover'),
                                      ),
                                    ],
                                  ),
                                );
                                if (confirmed == true) {
                                  onFavorite?.call();
                                }
                              },
                              style: FilledButton.styleFrom(
                                minimumSize: const Size(0, 36),
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              ),
                              icon: const Icon(Icons.check, size: 18),
                              label: const Text('Favorito'),
                            )
                                : OutlinedButton(
                              key: const ValueKey('fav-off'),
                              onPressed: () {
                                onFavorite?.call();
                              },
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size(0, 50),
                                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                              ),
                              child: const Text('Adicionar aos Favoritos'),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ChangeBadge(value: coin.change24h),
                  const SizedBox(height: 6),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
