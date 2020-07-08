import 'package:flutter/material.dart';

/// Поле ввода текста для поиска
///
/// Имеет иконку поиска и кнопку очистки поля ввода.
class SearchField extends StatefulWidget {
  final String hint;
  final ValueChanged<String> onChanged;

  const SearchField({Key key, @required this.onChanged, @required this.hint})
      : assert(onChanged != null),
        super(key: key);

  @override
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 56.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  maxLines: 1,
                  autocorrect: false,
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: widget.hint,
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                        fontSize: 14.0, color: const Color(0xFFB9B9B9)),
                  ),
                  onChanged: widget.onChanged,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Icon(Icons.search,
                    color: const Color(0xFF757575), size: 25),
              )
            ],
          ),
        ));
  }
}
