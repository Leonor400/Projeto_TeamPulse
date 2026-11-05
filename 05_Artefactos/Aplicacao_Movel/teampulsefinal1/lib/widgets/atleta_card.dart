import 'package:flutter/material.dart';

import '../models/atleta.dart';

class AtletaCard extends StatelessWidget {
  final Atleta atleta;
  final VoidCallback? onTap;

  const AtletaCard({super.key, required this.atleta, this.onTap});

  @override
  Widget build(BuildContext context) {
    final bool disponivel = atleta.disponivel;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF30090D).withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF8D3038), width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 17),
            child: Row(
              children: [
                Container(
                  width: 45,
                  height: 55,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFF752329),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${atleta.numero}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                const CircleAvatar(
                  radius: 24,
                  backgroundColor: Color(0xFF752329),
                  child: Icon(Icons.person, color: Colors.white, size: 28),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        atleta.nome,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        atleta.posicao,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 6),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: disponivel
                        ? const Color(0xFF124D30)
                        : const Color(0xFF571A24),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 3,
                        backgroundColor: disponivel
                            ? const Color(0xFF4CE39B)
                            : const Color(0xFFFF5965),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        disponivel ? 'Disponível' : 'Lesionada',
                        style: TextStyle(
                          color: disponivel
                              ? const Color(0xFF4CE39B)
                              : const Color(0xFFFF737B),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 6),

                const Icon(
                  Icons.chevron_right,
                  color: Colors.white70,
                  size: 23,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
