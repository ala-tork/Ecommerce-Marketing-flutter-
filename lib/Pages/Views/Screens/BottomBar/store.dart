import 'package:ecommerceversiontwo/LocalProvider.dart';
import 'package:ecommerceversiontwo/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/MyAppBAr.dart';

class Store extends StatefulWidget {
  const Store({Key? key}) : super(key: key);

  @override
  State<Store> createState() => _StoreState();
}

class _StoreState extends State<Store> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LocalProvider>(
      create: (_) => LocalProvider(),
      child: Consumer<LocalProvider>(
        builder: (context, localProvider, _) {
          return MaterialApp(
            locale: localProvider.locale,
            supportedLocales: L10n.all,
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            home: Scaffold(
              appBar: MyAppBar(
                Daimons: 122,
                title: "Add Deals",
              ),
              body: Center(
                child: Text(
                  AppLocalizations.of(context)?.profile ?? "empty",
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}


/* FutureBuilder<void>(
            future: getLikeByIdUserIdAd(),
            builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error fetching categories: ${snapshot.error}'),
                );
              } else {
                return ListView.builder(
                  itemCount: gridMap.length,
                  itemBuilder: (context, index) {
                    final e = gridMap[index];
                    return Text(
                      "${e.likeId}        ${e.nbLike} ",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                );
              }
            }),*/
