import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:search_app_bar/search_bloc.dart';

class SearchWidget extends StatelessWidget implements PreferredSizeWidget {
  final SearchBloc bloc;
  final Color color;
  final VoidCallback onCancelSearch;
  final TextCapitalization textCapitalization;
  final String hintText;

  SearchWidget({
    @required this.bloc,
    @required this.onCancelSearch,
    this.color,
    this.textCapitalization,
    this.hintText,
  });

  @override
  Size get preferredSize => Size.fromHeight(56.0);

  @override
  Widget build(BuildContext context) {
    // to handle notches properly
    return GestureDetector(
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            //_buildBackButton(),
            _buildTextField(),
            _buildClearButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildClearButton() {
    return StreamBuilder<String>(
      stream: bloc.searchQuery,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data?.isEmpty != false)
          return Container();
        return IconButton(
          icon: Icon(
            Icons.close,
            color: color,
          ),
          onPressed: bloc.onClearSearchQuery,
        );
      },
    );
  }

  Widget _buildBackButton() {
    return IconButton(
      icon: Icon(Icons.arrow_back, color: color),
      onPressed: onCancelSearch,
    );
  }

  Widget _buildTextField() {
    return Expanded(
      child: StreamBuilder<String>(
        stream: bloc.searchQuery,
        builder: (context, snapshot) {
          TextEditingController controller = _getController(snapshot);
          return TextField(
            controller: controller,
            autofocus: true,
            style: Theme.of(context).textTheme.headline6.apply(
              color: Colors.white
            ),
            cursorColor: Colors.white,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: Theme.of(context).textTheme.headline6.apply(
                color: Color(0xFFB8CEE3)
              ),
            ),
            textCapitalization: textCapitalization ?? TextCapitalization.none,
            onChanged: bloc.onSearchQueryChanged,
            inputFormatters: [
              TextInputFormatter.withFunction((oldValue, newValue) {
                return newValue.copyWith(text: newValue.text?.toUpperCase());
              })
            ],
          );
        },
      ),
    );
  }

  TextEditingController _getController(AsyncSnapshot<String> snapshot) {
    final controller = TextEditingController();
    controller.value = TextEditingValue(text: snapshot.data ?? '');
    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.text?.length ?? 0),
    );
    return controller;
  }
}
