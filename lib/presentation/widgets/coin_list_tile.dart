import 'package:flutter/material.dart';
import '../../core/utils/formatters.dart' as fmt;
import '../../domain/entities/coin.dart';

class CoinListTile extends StatelessWidget {
  final Coin coin;
  final VoidCallback? onTap;
  final VoidCallback? onFavorite;
  final bool showFavoriteAction;
  final bool isFavorite;

  const CoinListTile({
    super.key,
    required this.coin,
    this.onTap,
    this.onFavorite,
    this.showFavoriteAction = true,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    final changeUp = (coin.change24h) >= 0;
    final changeColor = changeUp ? Colors.green : Colors.red;

    return ListTile(
      leading: Hero(
        tag: 'coin:${coin.id}',
        child: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          backgroundImage: NetworkImage(coin.imageUrl),
          onBackgroundImageError: (_, __) {},
        ),
      ),
      title: Text('${coin.name} (${coin.symbol})'),
      subtitle: Wrap(
        spacing: 8,
        runSpacing: 4,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text('Preço: ${fmt.BrFormat.moeda(coin.price)}'),
          Text('MC: ${fmt.BrFormat.moedaCompact(coin.marketCap)}'),
          Text('Vol: ${fmt.BrFormat.moedaCompact(coin.volume24h)}'),
          Text(
            fmt.BrFormat.percent(coin.change24h),
            style: TextStyle(color: changeColor, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      trailing: showFavoriteAction
          ? _AnimatedFavButton(
        isFavorite: isFavorite,
        onPressed: onFavorite,
      )
          : null,
      onTap: onTap,
    );
  }
}

class _AnimatedFavButton extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback? onPressed;
  const _AnimatedFavButton({required this.isFavorite, this.onPressed});

  @override
  Widget build(BuildContext context) {
    // AnimatedSwitcher troca o ícone com fade + scale
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 220),
      transitionBuilder: (child, anim) {
        return ScaleTransition(scale: CurvedAnimation(parent: anim, curve: Curves.easeOutBack), child: child);
      },
      child: IconButton(
        key: ValueKey(isFavorite),
        onPressed: onPressed,
        tooltip: isFavorite ? 'Remover dos favoritos' : 'Adicionar aos favoritos',
        icon: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          color: isFavorite ? Colors.redAccent : null,
        ),
      ),
    );
  }
}
