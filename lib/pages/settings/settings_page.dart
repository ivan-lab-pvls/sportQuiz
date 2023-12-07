import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/svg.dart';
import 'package:football_quiz/core/custom_theme.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: UnconstrainedBox(
            child: SvgPicture.asset('assets/arrow_back.svg'),
          ),
        ),
        title: const Text(
          'NEWS',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 13,
            color: CustomTheme.black,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SettingTile(
                svg: 'assets/check_square.svg',
                txt: 'Privacy Policy',
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HelpDeskView(
                              open: 'https://docs.google.com/document/d/1Va07yfwWoGaS9SheWn4bHUc_NAjeHHSZOS4C2MMGs6k/edit?usp=sharing')));
                },
              ),
              SettingTile(
                svg: 'assets/chat.svg',
                txt: 'Terms of Use',
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HelpDeskView(
                              open: 'https://docs.google.com/document/d/1lmTwH0xM94FclqMC4BLR3PZ3LMldpUYysD60NW8CYWo/edit?usp=sharing')));
                },
              ),
              SettingTile(
                svg: 'assets/bag.svg',
                txt: 'Support',
                onTap: () {
                   Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HelpDeskView(
                              open: 'https://forms.gle/YpbBmNu6ThC27yj79')));
                },
              ),
              SettingTile(
                svg: 'assets/star.svg',
                txt: 'Rate app',
                onTap: () {
                  InAppReview.instance.openStoreListing(
                    appStoreId: '6473917883',
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingTile extends StatelessWidget {
  const SettingTile({
    super.key,
    required this.svg,
    required this.txt,
    required this.onTap,
  });

  final String svg;
  final String txt;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            SvgPicture.asset(svg),
            const SizedBox(width: 24),
            Text(
              txt,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: CustomTheme.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> rtt(SharedPreferences bd) async {
  final rev = InAppReview.instance;
  bool alreadyRated = bd.getBool('isRated') ?? false;
  if (!alreadyRated) {
    if (await rev.isAvailable()) {
      rev.requestReview();
      await bd.setBool('isRated', true);
    }
  }
}

class PtpPage extends StatefulWidget {
  const PtpPage({super.key, required this.tp});
  final String tp;

  @override
  State<PtpPage> createState() => _PtpPageState();
}

class _PtpPageState extends State<PtpPage> {
  var _progress = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            InAppWebView(
              onLoadStop: (controller, url) {
                controller.evaluateJavascript(
                    source:
                        "javascript:(function() { var ele=document.getElementsByClassName('docs-ml-header-item docs-ml-header-drive-link');ele[0].parentNode.removeChild(ele[0]);var footer = document.getelementsbytagname('footer')[0];footer.parentnode.removechild(footer);})()");
              },
              onProgressChanged: (controller, progress) => setState(() {
                _progress = progress;
              }),
              initialUrlRequest: URLRequest(
                url: Uri.parse(widget.tp),
              ),
            ),
            if (_progress != 100)
              Container(
                color: Colors.white,
                child: Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class HelpDeskView extends StatelessWidget {
  final String open;

  const HelpDeskView({super.key, required this.open});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 60, 255, 0),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: InAppWebView(
        initialUrlRequest:
            URLRequest(url: Uri.parse(open)),
      ),
    );
  }
}