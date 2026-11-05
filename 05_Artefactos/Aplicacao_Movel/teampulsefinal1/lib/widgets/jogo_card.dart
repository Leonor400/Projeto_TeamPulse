import 'package:flutter/material.dart';
import '../models/jogo.dart';

class JogoCard extends StatelessWidget{
  final Jogo jogo;
  final VoidCallback? onTap; 
  const JogoCard({super.key, required this.jogo, this.onTap,});

@override
  Widget build(BuildContext context) { 
    final bool temResultado = jogo.golosMarcados != null && jogo.golosSofridos != null;
    return Card( color: const Color(0xFF702126), margin: const EdgeInsets.symmetric( horizontal: 16, vertical: 6,),
    child: ListTile( onTap: onTap, leading: const Icon( Icons.sports_soccer, color: Colors.white, ),
    title: Text( 'CFB vs ${jogo.adversario}', style: const TextStyle( color: Colors.white, fontWeight: FontWeight.bold,),),
    subtitle: Text( '${jogo.data} | ${jogo.hora} | ${jogo.local}', style: const TextStyle(color: Colors.white70),),
    trailing: temResultado? Text( '${jogo.golosMarcados} - ${jogo.golosSofridos}', style: const TextStyle( color: Colors.white,fontWeight: FontWeight.bold, fontSize: 18,),)
    : const Icon( Icons.chevron_right, color: Colors.white70,),),);}}