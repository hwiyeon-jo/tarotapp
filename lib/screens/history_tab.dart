import 'package:flutter/material.dart';
import '../widgets/mystic_background.dart';

class HistoryTab extends StatelessWidget {
  const HistoryTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MysticBackground(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("리딩 성찰 기록", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF290B4E).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE5C158).withOpacity(0.2)),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        title: Text("2026.07.02 - 운명 기록 #${index + 1}", style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: const Padding(
                          padding: EdgeInsets.only(top: 6.0),
                          child: Text("결착 카드: Soul Flame 오리진", style: TextStyle(color: Color(0xFFFFE082))),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, color: Color(0xFFE5C158), size: 14),
                        onTap: () {},
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}