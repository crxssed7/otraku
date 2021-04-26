import 'package:flutter/material.dart';
import 'package:otraku/utils/config.dart';
import 'package:otraku/widgets/navigation/nav_bar.dart';
import 'package:otraku/widgets/overlays/toast.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: Config.PHYSICS,
      padding: Config.PADDING,
      children: [
        Center(
          child: ClipRRect(
            borderRadius: Config.BORDER_RADIUS,
            child: Image.asset(
              'assets/icons/about_icon.png',
              fit: BoxFit.contain,
              width: 200,
              height: 200,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Text(
            'Otraku - v. 1.0.5',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        Text(
          'An unofficial AniList app',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.subtitle1,
        ),
        const SizedBox(height: 30),
        Align(
          alignment: Alignment.center,
          child: ElevatedButton(
            child: Text('Discord'),
            onPressed: () {
              try {
                launch('https://discord.gg/YN2QWVbFef');
              } catch (err) {
                Toast.show(context, 'Couldn\'t open link: $err');
              }
            },
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: ElevatedButton(
            child: Text('Privacy Policy'),
            onPressed: () {
              try {
                launch('https://sites.google.com/view/otraku/privacy-policy');
              } catch (err) {
                Toast.show(context, 'Couldn\'t open link: $err');
              }
            },
          ),
        ),
        SizedBox(height: NavBar.offset(context)),
      ],
    );
  }
}
