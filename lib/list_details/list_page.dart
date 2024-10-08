import 'package:dragon_ball_characters_list/list_details/character.dart';
import 'package:dragon_ball_characters_list/list_details/details_page.dart';
import 'package:flutter/material.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  ListPageState createState() => ListPageState();
}

class ListPageState extends State<ListPage> {
  PageController? _controller;

  _goToDetail(Character character) {
    final page = DetailPage(character: character);
    Navigator.of(context).push(
      PageRouteBuilder<Null>(
        pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return AnimatedBuilder(
              animation: animation,
              builder: (BuildContext context, Widget? child) {
                return Opacity(
                  opacity: animation.value,
                  child: page,
                );
              });
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  _pageListener() {
    setState(() {});
  }

  @override
  void initState() {
    _controller = PageController(viewportFraction: 0.6);
    _controller!.addListener(_pageListener);
    super.initState();
  }

  @override
  void dispose() {
    _controller!.removeListener(_pageListener);
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Dragon Ball Z"),
        // elevation: 2.0,
        // backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: PageView.builder(
          scrollDirection: Axis.vertical,
          controller: _controller,
          itemCount: characters.length,
          itemBuilder: (context, index) {
            double? currentPage = 0;
            try {
              currentPage = _controller!.page;
            } catch (_) {}

            final num resizeFactor =
                (1 - (((currentPage! - index).abs() * 0.3).clamp(0.0, 1.0)));
            final currentCharacter = characters[index];
            return ListItem(
              character: currentCharacter,
              resizeFactor: resizeFactor as double,
              onTap: () => _goToDetail(currentCharacter),
            );
          }),
    );
  }
}

class ListItem extends StatelessWidget {
  final Character character;
  final double resizeFactor;
  final VoidCallback onTap;

  const ListItem({
    super.key,
    required this.character,
    required this.resizeFactor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height * 0.4;
    double width = MediaQuery.of(context).size.width * 0.85;
    return InkWell(
      onTap: onTap,
      child: Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: width * resizeFactor,
          height: height * resizeFactor,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                top: height / 4,
                bottom: 0,
                child: Hero(
                  tag: "background_${character.title}",
                  child: Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(character.color!),
                            Colors.white,
                          ],
                          stops: const [
                            0.4,
                            1.0,
                          ],
                        ),
                      ),
                      child: Container(
                        alignment: Alignment.bottomLeft,
                        margin: const EdgeInsets.only(
                          left: 20,
                          bottom: 10,
                        ),
                        child: Text(
                          character.title!,
                          style: TextStyle(
                            fontSize: 24 * resizeFactor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Hero(
                  tag: "image_${character.title}",
                  child: Image.asset(
                    character.avatar!,
                    width: width / 2,
                    height: height,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
