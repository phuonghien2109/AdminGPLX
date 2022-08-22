import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:testweb2/helper/constants.dart';
import 'package:testweb2/helper/traffic_signs.dart';
import 'package:testweb2/provider/quiz_provider.dart';
import 'package:testweb2/screens/traffic_signs/update_traffic.dart';

class SearchTraffic extends StatefulWidget {
  const SearchTraffic({Key? key}) : super(key: key);

  @override
  _SearchTrafficState createState() => _SearchTrafficState();
}

TextEditingController controller = TextEditingController();
late List<BienBao> _bienbao;

class _SearchTrafficState extends State<SearchTraffic> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<QuizProvider>();
    _bienbao = provider.bienbao;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: kColor,
        title: const Text('Tìm kiếm biển báo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: TypeAheadField<BienBao>(
          textFieldConfiguration: TextFieldConfiguration(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
              hintText: 'Tìm kiếm ...',
            ),
            controller: controller,
          ),
          suggestionsCallback: UserData.getSuggestions,
          itemBuilder: (context, BienBao suggestion) {
            final user = suggestion;
            return ListTile(
              leading: Image.network(
                user.img,
                fit: BoxFit.cover,
              ),
              title: Text(user.title),
              subtitle: Text(
                user.subtitle,
                maxLines: 1,
              ),
            );
          },
          noItemsFoundBuilder: (context) => SizedBox(
            height: 50,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 15, 0, 0),
              child: const Text(
                'Không tìm thấy',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
          onSuggestionSelected: (BienBao suggestion) {
            setState(() {
              final user = suggestion;
              MainNoti(user: user);
              controller = TextEditingController();
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(20.0)), //this right here
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)),
                        height: MediaQuery.of(context).size.height * 0.9,
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: UpdateTrafficSigns(
                          bienbao: user,
                        ),
                      ),
                    );
                  });
            });
          },
        ),
      ),
    );
  }
}

class MainNoti extends ChangeNotifier {
  final BienBao user;

  MainNoti({
    required this.user,
  });

  @override
  notifyListeners();
}

class UserData {
  static final List<BienBao> users = List.generate(
    6,
    (index) => BienBao(
        title: _bienbao[index].title,
        subtitle: _bienbao[index].subtitle,
        img: _bienbao[index].img,
        id: _bienbao[index].id),
  );

  static List<BienBao> getSuggestions(String query) =>
      List.of(users).where((user) {
        final userLower = user.title.toLowerCase();
        final queryLower = query.toLowerCase();

        return userLower.contains(queryLower);
      }).toList();
}
