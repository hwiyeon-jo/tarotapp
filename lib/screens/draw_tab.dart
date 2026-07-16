import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../widgets/mystic_background.dart';
import '../models/card_model.dart';

// [DrawTab 위젯: 원본 그대로 유지]
class DrawTab extends StatelessWidget {
  final String birthday;
  const DrawTab({Key? key, required this.birthday}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MysticBackground(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("운명의 길을 잇는 \n타로 점성술", style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: Colors.white, height: 1.2)),
              const SizedBox(height: 40),
              _buildMenuCard(context, "🌟 소울카드", "생년월일 수리학 기반 나의 타고난 기질 종합 리딩", 1, Icons.auto_awesome),
              const SizedBox(height: 24),
              _buildMenuCard(context, "🔮 오늘의 운세", "선택한 기분 & 관심사 조합 데일리 스페셜 운세", 2, Icons.bubble_chart),
              const SizedBox(height: 24),
              _buildMenuCard(context, "🃏 메이저 아르카나", "22장의 메이저 카드 중 매일 나를 이끄는 가이드 1장", 3, Icons.filter_none),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, String title, String subtitle, int mode, IconData icon) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => TarotFlipScreen(title: title, drawMode: mode, birthday: birthday)));
      },
      borderRadius: BorderRadius.circular(28),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.08), borderRadius: BorderRadius.circular(28), border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 15, offset: const Offset(0, 8))]),
        child: Row(
          children: [
            Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(16)), child: Icon(icon, color: const Color(0xFFFFE082), size: 28)),
            const SizedBox(width: 20),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)), const SizedBox(height: 6), Text(subtitle, style: const TextStyle(fontSize: 13, color: Colors.white60, height: 1.4))])),
            Icon(Icons.chevron_right, color: Colors.white.withOpacity(0.5)),
          ],
        ),
      ),
    );
  }
}

class TarotFlipScreen extends StatefulWidget {
  final String title;
  final int drawMode;
  final String birthday;
  const TarotFlipScreen({Key? key, required this.title, required this.drawMode, required this.birthday}) : super(key: key);

  @override
  _TarotFlipScreenState createState() => _TarotFlipScreenState();
}

class _TarotFlipScreenState extends State<TarotFlipScreen> with TickerProviderStateMixin {
  late AnimationController _flipController;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isFlipped = false;
  TarotCard? _resultCard;
  String _selectedMood = "평온함";
  String _selectedTopic = "종합운";
  final List<String> _moods = ["평온함", "불안함", "지침/피로", "설렘/기대", "의욕상실"];
  final List<String> _topics = ["종합운", "애정/인연", "금전/재물", "학업/커리어", "대인관계"];
  final List<String> _luckyColors = ["미드나잇 블루", "로즈 골드", "솔라 옐로우", "포레스트 그린", "딥 퍼플", "크리스탈 실버"];
  final List<String> _keywords = ["확장과 성장", "감정의 정화", "새로운 터닝포인트", "집중과 몰입", "유연한 타협", "주관의 수호"];

  final List<TarotCard> _soulCards = [
    TarotCard(id: 1, name: 'Soul Flame (소울 플레임)', imagePath: 'assets/soul_card/soul_01_flame.png', meaning: '내면의 열정과 강력한 에너지가 솟구치는 상태를 가리킵니다.'),
    TarotCard(id: 2, name: 'Soul Mirror (소울 미러)', imagePath: 'assets/soul_card/soul_02_mirror.png', meaning: '주변 환경이나 타인의 모습에서 나를 거울처럼 투영해 발견하게 됩니다.'),
    TarotCard(id: 3, name: 'Soul Tree (소울 트리)', imagePath: 'assets/soul_card/soul_03_tree.png', meaning: '안정적인 성장과 축적되는 성과를 상징합니다.'),
    TarotCard(id: 4, name: 'Soul Abyss (소울 어비스)', imagePath: 'assets/soul_card/soul_04_abyss.png', meaning: '깊은 무의식세계와 차분한 영적 성찰의 상태입니다.'),
    TarotCard(id: 5, name: 'Soul Chain (소울 체인)', imagePath: 'assets/soul_card/soul_05_chain.png', meaning: '나를 얽매고 있는 의무감이나 관계망의 균형을 되짚어보세요.'),
    TarotCard(id: 6, name: 'Soul Journey (소울 저니)', imagePath: 'assets/soul_card/soul_06_journey.png', meaning: '새로운 궤도로의 탐색이나 가치관의 이동이 시작됩니다.'),
    TarotCard(id: 7, name: 'Soul Awakening (소울 어웨이큰)', imagePath: 'assets/soul_card/soul_07_awakening.png', meaning: '정신적인 확장과 개벽, 혹은 크나큰 통찰을 발견하게 됩니다.'),
    TarotCard(id: 8, name: 'Soul Balance (소울 밸런스)', imagePath: 'assets/soul_card/soul_08_balance.png', meaning: '감정과 실재, 내외면의 양적 대칭 균형이 평온하게 맞춰집니다.'),
    TarotCard(id: 9, name: 'Soul Return (소울 리턴)', imagePath: 'assets/soul_card/soul_09_return.png', meaning: '과거의 인연이나 익숙한 안식처로 돌아와 에너지를 귀환시킵니다.'),
  ];

  final List<TarotCard> _majorCards = [
    TarotCard(id: 10, name: 'The Fool (광대)', imagePath: 'assets/tarot_card/00_the_fool.png', meaning: '계획에 얽매이지 마세요. 두려움 없이 첫발을 내딛을 때 새로운 길이 열립니다.'),
    TarotCard(id: 11, name: 'The Magician (마법사)', imagePath: 'assets/tarot_card/01_the_magician.png', meaning: '당신은 이미 모든 도구를 가졌습니다. 생각을 현실로 바꿀 타이밍입니다.'),
    TarotCard(id: 12, name: 'The High Priestess (고위 여사제)', imagePath: 'assets/tarot_card/02_the_high_priestess.png', meaning: '외부의 소음에서 벗어나 내면의 목소리에 귀를 기울이세요.'),
    TarotCard(id: 13, name: 'The Empress (여황제)', imagePath: 'assets/tarot_card/03_the_empress.png', meaning: '당신의 삶에 따뜻하고 풍요로운 에너지가 가득 차오르고 있습니다.'),
    TarotCard(id: 14, name: 'The Emperor (황제)', imagePath: 'assets/tarot_card/04_the_emperor.png', meaning: '혼란 속에서도 확고한 규칙과 중심을 잡아 나아가십시오.'),
    TarotCard(id: 15, name: 'The Hierophant (교황)', imagePath: 'assets/tarot_card/05_the_hierophant.png', meaning: '전통적인 지혜나 신뢰할 수 있는 멘토의 조언을 구하세요.'),
    TarotCard(id: 16, name: 'The Lovers (연인)', imagePath: 'assets/tarot_card/06_the_lovers.png', meaning: '마음이 이끄는 아름다운 선택을 마주하게 됩니다.'),
    TarotCard(id: 17, name: 'The Chariot (전차)', imagePath: 'assets/tarot_card/07_the_chariot.png', meaning: '장애물이 있어도 굳건한 추진력으로 승리를 쟁취합니다.'),
    TarotCard(id: 18, name: 'Strength (힘)', imagePath: 'assets/tarot_card/08_strength.png', meaning: '부드럽고 끈기 있는 정신적 자제력으로 상황을 다스리세요.'),
    TarotCard(id: 19, name: 'The Hermit (은둔자)', imagePath: 'assets/tarot_card/09_the_hermit.png', meaning: '잠시 멈추어 고독한 성찰의 시간을 가져보세요.'),
    TarotCard(id: 20, name: 'Wheel of Fortune (운명의 수레바퀴)', imagePath: 'assets/tarot_card/10_wheel_of_fortune.png', meaning: '운명의 흐름이 큰 변화를 향해 움직이고 있습니다.'),
    TarotCard(id: 21, name: 'Justice (정의)', imagePath: 'assets/tarot_card/11_justice.png', meaning: '감정에 치우치지 않는 냉철하고 공정한 판단이 중요합니다.'),
    TarotCard(id: 22, name: 'The Hanged Man (매달린 사람)', imagePath: 'assets/tarot_card/12_the_hanged_man.png', meaning: '지금은 관점을 바꾸어 세상을 바라볼 때입니다.'),
    TarotCard(id: 23, name: 'Death (죽음)', imagePath: 'assets/tarot_card/13_death.png', meaning: '낡은 궤도가 끝나고 완전히 새로운 시작이 다가옵니다.'),
    TarotCard(id: 24, name: 'Temperance (절제)', imagePath: 'assets/tarot_card/14_temperance.png', meaning: '서로 다른 기운들을 유연하게 조율하고 통합하십시오.'),
    TarotCard(id: 25, name: 'The Devil (악마)', imagePath: 'assets/tarot_card/15_the_devil.png', meaning: '당신을 옭아매는 집착이나 습관을 경계하십시오.'),
    TarotCard(id: 26, name: 'The Tower (탑)', imagePath: 'assets/tarot_card/16_the_tower.png', meaning: '갑작스러운 변화가 올 수 있지만 이는 재시작의 기회입니다.'),
    TarotCard(id: 27, name: 'The Star (별)', imagePath: 'assets/tarot_card/17_the_star.png', meaning: '어두운 밤하늘 속 희망의 별빛이 당신을 비춥니다.'),
    TarotCard(id: 28, name: 'The Moon (달)', imagePath: 'assets/tarot_card/18_the_moon.png', meaning: '불안함에 속지 말고 직관을 믿으며 밤길을 가세요.'),
    TarotCard(id: 29, name: 'The Sun (태양)', imagePath: 'assets/tarot_card/19_the_sun.png', meaning: '모든 안개가 걷히고 최고의 행복이 쏟아지는 날입니다.'),
    TarotCard(id: 30, name: 'Judgement (심판)', imagePath: 'assets/tarot_card/20_judgement.png', meaning: '과거의 노력에 대한 보상과 새로운 소식이 들려옵니다.'),
    TarotCard(id: 31, name: 'The World (세계)', imagePath: 'assets/tarot_card/21_the_world.png', meaning: '완벽한 조화와 함께 하나의 여정이 아름답게 마무리됩니다.'),
  ];

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);
    if (widget.drawMode == 2) _resultCard = _soulCards[Random().nextInt(_soulCards.length)];
  }

  Map<String, String> _getFortuneData(TarotCard card) {
    final r = Random(card.id + _selectedMood.hashCode + _selectedTopic.hashCode);
    return {
      "fortune": ["${card.name}의 기운이 ${_selectedTopic} 운기를 환하게 밝힙니다.", "오늘은 ${_selectedTopic} 분야에서 ${_selectedMood}한 에너지가 긍정적인 변곡점을 만듭니다.", "이 카드는 ${_selectedTopic} 문제의 해답을 제시하는 당신의 길잡이입니다."][r.nextInt(3)],
      "advice": ["직관을 따라 움직이세요. 그것이 최선의 선택입니다.", "잠시 멈추어 주위를 살피는 것이 성취를 앞당깁니다.", "내면의 목소리에 집중하십시오. 이미 답을 알고 있습니다."][r.nextInt(3)],
      "caution": ["성급한 판단은 오히려 기회를 멀어지게 합니다.", "타인의 시선보다 당신 자신의 중심을 지키는 하루가 되세요.", "지나친 열정보다는 차분한 조율이 필요한 시점입니다."][r.nextInt(3)],
    };
  }

  void _updateResultCard() {
    if (_isFlipped) return;
    _audioPlayer.play(AssetSource('sounds/card_get.mp3'));
    setState(() => _resultCard = _soulCards[Random().nextInt(_soulCards.length)]);
  }

  int _calculateSoulNumber(String birth) {
    int sum = 0;
    for (int i = 0; i < birth.length; i++) sum += int.tryParse(birth[i]) ?? 0;
    while (sum > 9) {
      int temp = 0;
      for (int i = 0; i < sum.toString().length; i++) temp += int.parse(sum.toString()[i]);
      sum = temp;
    }
    return sum == 0 ? 1 : sum;
  }

  void _executeDraw() {
    if (_isFlipped) return;
    _audioPlayer.play(AssetSource('sounds/card_draw.mp3'));
    setState(() {
      if (widget.drawMode == 1) _resultCard = _soulCards.firstWhere((c) => c.id == _calculateSoulNumber(widget.birthday));
      else if (widget.drawMode == 2) {}
      else _resultCard = _majorCards[Random().nextInt(_majorCards.length)];
      _isFlipped = true;
    });
    _flipController.forward();
  }

  @override
  void dispose() { _audioPlayer.dispose(); _flipController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title), backgroundColor: Colors.transparent, elevation: 0),
      extendBodyBehindAppBar: true,
      body: MysticBackground(
        child: SingleChildScrollView(padding: const EdgeInsets.only(top: 100, bottom: 40), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          if (widget.drawMode == 2 && !_isFlipped) ...[
            _buildSelectionSection("현재 내면의 기분 상태", _moods, _selectedMood, (val) { setState(() => _selectedMood = val); _updateResultCard(); }),
            const SizedBox(height: 15),
            _buildSelectionSection("조율을 원하는 관심 분야", _topics, _selectedTopic, (val) { setState(() => _selectedTopic = val); _updateResultCard(); }),
            const SizedBox(height: 35),
          ],
          SizedBox(height: 400, child: Stack(alignment: Alignment.center, children: [
            Positioned(top: 20, child: _buildStackDecoration(0.85, 0.2)),
            Positioned(top: 10, child: _buildStackDecoration(0.92, 0.5)),
            // [모드 2일 때만 슬라이딩 효과 적용]
            widget.drawMode == 2 && !_isFlipped
                ? AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (child, animation) => SlideTransition(position: Tween<Offset>(begin: const Offset(1.0, 0), end: Offset.zero).animate(animation), child: child),
              child: _buildFlipAnimation(ValueKey(_resultCard?.id)),
            )
                : _buildFlipAnimation(const ValueKey("fixed")),
          ])),
          const SizedBox(height: 35),
          if (!_isFlipped) ElevatedButton(onPressed: _executeDraw, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE5C158), foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))), child: const Text("운명의 주파수 동기화 및 오픈", style: TextStyle(fontWeight: FontWeight.bold)))
          else Padding(padding: const EdgeInsets.symmetric(horizontal: 24), child: _buildResultPanel())
        ])),
      ),
    );
  }

  // [카드 뒤집기 애니메이션 위젯 분리]
  Widget _buildFlipAnimation(Key key) {
    return AnimatedBuilder(
        key: key,
        animation: _flipController,
        builder: (ctx, child) {
          final angle = _flipController.value * pi;
          return Transform(transform: Matrix4.identity()..setEntry(3, 2, 0.001)..rotateY(angle), alignment: Alignment.center, child: angle < pi / 2 ? _buildCardBack() : Transform(transform: Matrix4.identity()..rotateY(pi), alignment: Alignment.center, child: _buildCardFront()));
        }
    );
  }

  Widget _buildResultPanel() {
    if (_resultCard == null) return const SizedBox();
    final rand = Random(_resultCard!.id);
    final fortune = _getFortuneData(_resultCard!);

    if (widget.drawMode == 1) {
      return Column(children: [const Text("🧬 당신의 타고난 수리 영혼 각인", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFE5C158))), const SizedBox(height: 16), _buildResultRow("🔮 나의 대표 카드", _resultCard!.name), _buildResultRow("👤 성격", "${_resultCard!.name} 기질의 소유자는 본질적으로 자아 신념이 굳건하며, 정서적 통찰력이 뛰어납니다."), _buildResultRow("💪 강점", "어떤 상황에서도 무너지지 않고 에너지를 내면에서 순환 및 자가 치유하는 힘이 강력합니다."), _buildResultRow("🩸 약점", "깊은 생각 탓에 간혹 실행 단계가 지체되거나, 타인에게 심리적 벽을 세우기 쉽습니다."), _buildResultRow("🎯 삶의 과제", "본인의 이상과 영적 파동을 현실 세계의 구체적인 성과와 균형 있게 접지시키는 것."), _buildResultRow("❤️ 연애 성향", "단순한 끌림을 넘어 깊은 영혼의 교감과 정신적 대화가 통하는 소울메이트를 지향합니다."), _buildResultRow("💼 직업 성향", "정해진 틀에 갇힌 단순 업무보다 창의적 독립성이나 깊은 사색을 필요로 하는 전문직에 적합."), _buildResultRow("🌱 성장 포인트", "혼자만의 세계에서 한 걸음 나와, 세상의 대중적 파동과 유연하게 소통하는 빈도를 넓히세요.")]);
    } else if (widget.drawMode == 2) {
      return Column(children: [Text("🔮 오늘의 셔플 매칭: ${_resultCard!.name}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFFFE082))), const SizedBox(height: 16), _buildResultRow("☀️ 오늘의 운세", fortune["fortune"]!), _buildResultRow("💡 오늘의 조언", fortune["advice"]!), _buildResultRow("⚠️ 조심할 점", fortune["caution"]!), _buildResultRow("🔑 키워드", _keywords[rand.nextInt(_keywords.length)]), _buildResultRow("🎨 행운의 색", _luckyColors[rand.nextInt(_luckyColors.length)])]);
    } else {
      return Column(children: [const Text("🃏 오늘 당신의 아르카나 메이저 가이드", style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Color(0xFFFFE082))), const SizedBox(height: 16), _buildResultRow("🎴 오늘의 카드", _resultCard!.name), _buildResultRow("📖 핵심 메시지", _resultCard!.meaning), _buildResultRow("✨ 우주의 직관", "이 카드는 당신이 현재의 궤도에서 가장 필요한 에너지를 상징합니다."), _buildResultRow("🏃 실천 가이드", "이 카드의 에너지를 활용하려면, 오늘 일과 중 가장 직관적으로 느껴지는 일을 먼저 처리하십시오.")]);
    }
  }

  Widget _buildResultRow(String label, String content) => Container(width: double.infinity, margin: const EdgeInsets.symmetric(vertical: 6), padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: const Color(0xFF1E0638).withOpacity(0.6), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white12)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFFE082), fontSize: 15)), const SizedBox(height: 6), Text(content, style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5))]));
  Widget _buildSelectionSection(String label, List<String> items, String currentSelected, ValueChanged<String> onSelected) => Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(color: Color(0xFFE5C158), fontWeight: FontWeight.bold, fontSize: 14)), const SizedBox(height: 8), Wrap(spacing: 8, children: items.map((item) { final isSelected = item == currentSelected; return ChoiceChip(label: Text(item, style: TextStyle(color: isSelected ? Colors.black : Colors.white, fontSize: 13)), selected: isSelected, selectedColor: const Color(0xFFE5C158), backgroundColor: Colors.white10, onSelected: (selected) { if (selected) onSelected(item); }); }).toList())]));
  Widget _buildStackDecoration(double s, double o) => Transform.scale(scale: s, child: Opacity(opacity: o, child: Container(width: 230, height: 375, decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(20)))));
  Widget _buildCardFront() => Container(width: 230, height: 375, decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFE5C158), width: 3)), child: ClipRRect(borderRadius: BorderRadius.circular(17), child: _resultCard != null ? Image.asset(_resultCard!.imagePath, fit: BoxFit.cover) : Container(color: Colors.grey)));
  Widget _buildCardBack() => Container(width: 230, height: 375, decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)), child: ClipRRect(borderRadius: BorderRadius.circular(20), child: Image.asset('assets/images/card_back_design.png', fit: BoxFit.cover)));
}