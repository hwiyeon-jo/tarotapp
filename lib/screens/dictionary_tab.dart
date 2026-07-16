import 'package:flutter/material.dart';
import '../widgets/mystic_background.dart';
import '../models/card_model.dart';

class DictionaryTab extends StatefulWidget {
  const DictionaryTab({Key? key}) : super(key: key);

  @override
  _DictionaryTabState createState() => _DictionaryTabState();
}

class _DictionaryTabState extends State<DictionaryTab> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // 1. 소울 아르카나 도감 데이터 풀 (9장 정밀 매핑)
  final List<TarotCard> _soulCards = [
    TarotCard(id: 1, name: 'Soul Flame (소울 플레임)', imagePath: 'assets/soul_card/soul_01_flame.png', meaning: '내면의 열정과 강력한 에너지가 솟구치는 기질'),
    TarotCard(id: 2, name: 'Soul Mirror (소울 미러)', imagePath: 'assets/soul_card/soul_02_mirror.png', meaning: '타인과 세상을 통해 자신을 투영하고 성찰하는 기질'),
    TarotCard(id: 3, name: 'Soul Tree (소울 트리)', imagePath: 'assets/soul_card/soul_03_tree.png', meaning: '안정적인 성장과 축적되는 결실을 만들어내는 기질'),
    TarotCard(id: 4, name: 'Soul Abyss (소울 어비스)', imagePath: 'assets/soul_card/soul_04_abyss.png', meaning: '깊은 무의식세계와 차분한 영적 지혜를 품은 기질'),
    TarotCard(id: 5, name: 'Soul Chain (소울 체인)', imagePath: 'assets/soul_card/soul_05_chain.png', meaning: '책임감과 관계망의 질서 및 균형을 조율하는 기질'),
    TarotCard(id: 6, name: 'Soul Journey (소울 저니)', imagePath: 'assets/soul_card/soul_06_journey.png', meaning: '새로운 가치관을 찾아 끊임없이 탐색하고 이동하는 기질'),
    TarotCard(id: 7, name: 'Soul Awakening (소울 어웨이큰)', imagePath: 'assets/soul_card/soul_07_awakening.png', meaning: '정신적인 확장과 크나큰 깨달음을 갈구하는 기질'),
    TarotCard(id: 8, name: 'Soul Balance (소울 밸런스)', imagePath: 'assets/soul_card/soul_08_balance.png', meaning: '내외면의 대칭과 감정의 조화를 평온하게 유지하는 기질'),
    TarotCard(id: 9, name: 'Soul Return (소울 리턴)', imagePath: 'assets/soul_card/soul_09_return.png', meaning: '과거의 본질적 순수함과 안식처로 에너지를 귀환시키는 기질'),
  ];

  // 2. 메이저 아르카나 도감 데이터 풀 (22장 정밀 매핑)
  final List<TarotCard> _majorCards = [
    TarotCard(id: 10, name: 'The Fool (광대)', imagePath: 'assets/tarot_card/00_the_fool.png', meaning: '순수한 출발, 미지의 여정, 자유로운 영혼'),
    TarotCard(id: 11, name: 'The Magician (마법사)', imagePath: 'assets/tarot_card/01_the_magician.png', meaning: '창조적 기량, 잠재력 발현, 탁월한 재능'),
    TarotCard(id: 12, name: 'The High Priestess (고위 여사제)', imagePath: 'assets/tarot_card/02_the_high_priestess.png', meaning: '내적 직관, 영적 통찰, 정적인 지혜'),
    TarotCard(id: 13, name: 'The Empress (여황제)', imagePath: 'assets/tarot_card/03_the_empress.png', meaning: '풍요로움, 물질적·정신적 안락, 모성적 수용'),
    TarotCard(id: 14, name: 'The Emperor (황제)', imagePath: 'assets/tarot_card/04_the_emperor.png', meaning: '확고한 통제력, 질서 확립, 권위와 수호 의지'),
    TarotCard(id: 15, name: 'The Hierophant (교황)', imagePath: 'assets/tarot_card/05_the_hierophant.png', meaning: '전통적 가르침, 중재와 신뢰, 정신적 멘토링'),
    TarotCard(id: 16, name: 'The Lovers (연인)', imagePath: 'assets/tarot_card/06_the_lovers.png', meaning: '감정의 교감, 아름다운 결합, 상호 협력과 선택'),
    TarotCard(id: 17, name: 'The Chariot (전차)', imagePath: 'assets/tarot_card/07_the_chariot.png', meaning: '맹렬한 진격, 대립 극복, 승리를 향한 의지'),
    TarotCard(id: 18, name: 'Strength (힘)', imagePath: 'assets/tarot_card/08_strength.png', meaning: '내면의 인내, 부드러운 포용력, 고차원적 통제'),
    TarotCard(id: 19, name: 'The Hermit (은둔자)', imagePath: 'assets/tarot_card/09_the_hermit.png', meaning: '고독한 성찰, 진리 탐구, 주관적인 등불'),
    TarotCard(id: 20, name: 'Wheel of Fortune (운명의 수레바퀴)', imagePath: 'assets/tarot_card/10_wheel_of_fortune.png', meaning: '업보의 순환, 불가피한 전환기, 우주의 흐름'),
    TarotCard(id: 21, name: 'Justice (정의)', imagePath: 'assets/tarot_card/11_justice.png', meaning: '공정성, 인과의 원칙, 객관적인 결단'),
    TarotCard(id: 22, name: 'The Hanged Man (매달린 사람)', imagePath: 'assets/tarot_card/12_the_hanged_man.png', meaning: '시각의 전환, 희생과 인내, 유연한 정체기'),
    TarotCard(id: 23, name: 'Death (죽음)', imagePath: 'assets/tarot_card/13_death.png', meaning: '완전한 종결, 새로운 탄생, 차원의 변화'),
    TarotCard(id: 24, name: 'Temperance (절제)', imagePath: 'assets/tarot_card/14_temperance.png', meaning: '기운의 조율, 중용과 연금술적 결합'),
    TarotCard(id: 25, name: 'The Devil (악마)', imagePath: 'assets/tarot_card/15_the_devil.png', meaning: '집착과 유혹, 물질적 속박에 대한 경고'),
    TarotCard(id: 26, name: 'The Tower (탑)', imagePath: 'assets/tarot_card/16_the_tower.png', meaning: '인위적인 붕괴, 참된 진실과의 조우, 급격한 변화'),
    TarotCard(id: 27, name: 'The Star (별)', imagePath: 'assets/tarot_card/17_the_star.png', meaning: '영원한 희망, 아스라한 이상향, 내면의 치유'),
    TarotCard(id: 28, name: 'The Moon (달)', imagePath: 'assets/tarot_card/18_the_moon.png', meaning: '모호함과 불안정, 무의식의 안개 구간 관조'),
    TarotCard(id: 29, name: 'The Sun (태양)', imagePath: 'assets/tarot_card/19_the_sun.png', meaning: '광명과 활력, 명백한 성공, 완전한 안도감'),
    TarotCard(id: 30, name: 'Judgement (심판)', imagePath: 'assets/tarot_card/20_judgement.png', meaning: '부활의 소식, 노력이 가져온 소명과 보상'),
    TarotCard(id: 31, name: 'The World (세계)', imagePath: 'assets/tarot_card/21_the_world.png', meaning: '해피엔딩의 마침표, 완전한 통합과 피날레'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MysticBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text("영혼의 도감", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 22)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: const Color(0xFFE5C158),
            labelColor: const Color(0xFFFFE082),
            unselectedLabelColor: Colors.white54,
            labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            tabs: const [
              Tab(text: "메이저 아르카나"),
              Tab(text: "소울 아르카나"),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildCardGrid(_majorCards),
            _buildCardGrid(_soulCards),
          ],
        ),
      ),
    );
  }

  // 타로 카드 리스트를 그리드 뷰 형태로 빌드하는 재사용 메서드
  Widget _buildCardGrid(List<TarotCard> cards) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: cards.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,           // 화면 가로당 2개씩 카드 배열
        childAspectRatio: 0.62,       // 타로 카드의 표준 세로 비율 유지
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
      ),
      itemBuilder: (context, index) {
        final card = cards[index];
        return GestureDetector(
          onTap: () => _showCardDetailDialog(context, card),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE5C158).withOpacity(0.4), width: 1.5),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 6, offset: const Offset(2, 3)),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // 🖼️ 실제 에셋 루트 경로 반영 이미지 컴포넌트
                  Image.asset(
                    card.imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFF1E0638),
                        child: const Icon(Icons.broken_image, color: Color(0xFFE5C158)),
                      );
                    },
                  ),
                  // 하단 카드명 텍스트 그라데이션 블러 패널
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [Colors.black.withOpacity(0.85), Colors.transparent],
                        ),
                      ),
                      child: Text(
                        card.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFFFFE082),
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // 도감 리스트 내 카드를 터치했을 때 상세 설명 팝업 다이얼로그
  void _showCardDetailDialog(BuildContext context, TarotCard card) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF220A3E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFFE5C158), width: 1.5),
        ),
        title: Text(
          card.name,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Color(0xFFFFE082), fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 140,
              height: 225,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5C158).withOpacity(0.5)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(11),
                child: Image.asset(card.imagePath, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                card.meaning,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
              ),
            ),
          ],
        ),
        actionsPadding: const EdgeInsets.only(bottom: 10, right: 10),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("닫기", style: TextStyle(color: Color(0xFFE5C158), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}