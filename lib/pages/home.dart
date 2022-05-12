import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:default_themes/application.dart';
import 'package:default_themes/core/themes/build_context_theme.extension.dart';
import 'package:default_themes/components/alerts/empty.dart';
import 'package:default_themes/components/alerts/date_picker.dart';
import 'package:default_themes/components/alerts/time_picker.dart';
import 'package:default_themes/components/drop_down_button_field.dart';
import 'package:default_themes/components/custom_checkbox.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int? _selectedValue;
  bool _hidePassword = true;
  bool _customCheckBoxValue = true;
  bool _customSwitchValue = true;
  bool? _customTristateCheckBoxValue;

  void _onChangeCustomCheckBox(bool? value) => setState(() => _customCheckBoxValue = value!);

  void _onChangeCustomSwitch(bool? value) => setState(() => _customSwitchValue = value!);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UI Screen'),
        actions: [
          PopupMenuButton<ThemeMode>(
            itemBuilder: (_) => const [
              PopupMenuItem<ThemeMode>(
                value: ThemeMode.system,
                child: Text('Системная тема'),
              ),
              PopupMenuItem<ThemeMode>(
                value: ThemeMode.dark,
                child: Text('Тёмная тема'),
              ),
              PopupMenuItem<ThemeMode>(
                value: ThemeMode.light,
                child: Text('Светлая тема'),
              ),
            ],
            onSelected: (themeMode) => context.read<ApplicationState>().setCurrentTheme(themeMode),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DividerTheme(
                data: context.theme.dividerTheme.copyWith(color: Colors.transparent),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ..._buildAllTexts(),
                    const Divider(),
                    ..._buildSomeButtons(),
                    const Divider(),
                    _buildSelect(),
                    const Divider(),
                    ..._buildSwitches(),
                    const Divider(),
                    _buildUserNameField(),
                    const Divider(),
                    _buildPasswordField(),
                    const Divider(),
                    _buildErrorField(),
                    const Divider(),
                    _buildMultilineField(),
                    const Divider(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildAllTexts() {
    final textTheme = context.theme.textTheme;

    return [
      Text('Headline 1', style: textTheme.headline1),
      Text('Headline 2', style: textTheme.headline2),
      Text('Headline 3', style: textTheme.headline3),
      Text('Headline 4', style: textTheme.headline4),
      Text('Headline 5', style: textTheme.headline5),
      Text('Headline 6', style: textTheme.headline6),
      Text('Subtitle 1', style: textTheme.subtitle1),
      Text('Subtitle 2', style: textTheme.subtitle2),
      Text('Body Text 1', style: textTheme.bodyText1),
      Text('Body Text 2', style: textTheme.bodyText2),
      Text('Caption', style: textTheme.caption),
      Text('Button', style: textTheme.button),
      Text('Overline', style: textTheme.overline),
    ];
  }

  List<Widget> _buildSomeButtons() {
    const String clickMe = 'Нажми на меня!';

    return [
      Row(
        children: [
          TextButton(
            onPressed: () => showEmptyDialog(context),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(clickMe),
            ),
          ),
          const VerticalDivider(),
          const TextButton(
            onPressed: null,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(clickMe),
            ),
          ),
        ],
      ),
      const Divider(),
      Row(
        children: [
          ElevatedButton(
            onPressed: () => showDefaultDatePicker(context),
            child: const Text(clickMe),
          ),
          const VerticalDivider(),
          const ElevatedButton(onPressed: null, child: Text(clickMe)),
        ],
      ),
      const Divider(),
      Row(
        children: [
          OutlinedButton(onPressed: () => showDefaultTimePicker(context), child: const Text(clickMe)),
          const VerticalDivider(),
          const OutlinedButton(
            onPressed: null,
            child: Text(clickMe),
          ),
        ],
      ),
      const Divider(),
      FloatingActionButton(
        onPressed: () {},
        child: const FaIcon(
          const IconData(0x1F6E0, fontFamily: 'FF Mark'),
          color: Colors.black,
        ),
      ),
    ];
  }

  Widget _buildSelect() => DropdownButtonField(
        value: _selectedValue,
        onChanged: (int? value) => setState(() => _selectedValue = value!),
        decoration: const InputDecoration(labelText: 'Выбрать'),
        itemsBuilder: (selectedItem) => const [
          DropdownMenuItem(
            value: 1,
            child: Text('Один'),
          ),
          DropdownMenuItem(
            value: 2,
            child: Text('Два'),
          ),
          DropdownMenuItem(
            value: 3,
            child: Text('Три'),
          ),
          DropdownMenuItem(
            value: 4,
            child: Text('Четыре'),
          ),
        ],
      );

  List<Widget> _buildSwitches() {
    return [
      Row(
        children: [
          CustomCheckbox(
            value: _customCheckBoxValue,
            onChanged: _onChangeCustomCheckBox,
          ),
          const VerticalDivider(),
          Switch(
            value: _customSwitchValue,
            onChanged: _onChangeCustomSwitch,
          ),
          const VerticalDivider(),
          Radio(
            value: 1,
            groupValue: 1,
            onChanged: (value) {},
          ),
        ],
      ),
      Row(
        children: [
          CustomCheckbox(
            value: false,
            onChanged: (value) {},
          ),
          const VerticalDivider(),
          Switch(
            value: false,
            onChanged: (value) {},
          ),
          const VerticalDivider(),
          Radio(
            value: 2,
            groupValue: 1,
            onChanged: (value) {},
          ),
        ],
      ),
      Row(
        children: const [
          CustomCheckbox(
            value: null,
            onChanged: null,
            tristate: false,
          ),
          VerticalDivider(),
          Switch(
            value: true,
            onChanged: null,
          ),
          VerticalDivider(),
          Radio(
            value: 1,
            groupValue: 1,
            onChanged: null,
          ),
        ],
      ),
      Row(
        children: [
          CustomCheckbox(
            value: _customTristateCheckBoxValue,
            onChanged: (v) => setState(() => _customTristateCheckBoxValue = v),
            tristate: true,
          ),
        ],
      ),
    ];
  }

  Widget _buildUserNameField() => TextFormField(
        decoration: const InputDecoration(
          labelText: 'Имя пользователя',
          border: OutlineInputBorder(),
        ),
      );

  Widget _buildPasswordField() => TextFormField(
        obscureText: _hidePassword,
        decoration: InputDecoration(
          labelText: 'Пароль',
          border: const OutlineInputBorder(),
          suffixIcon: IconButton(
            onPressed: () => setState(() => _hidePassword = !_hidePassword),
            icon: Icon(_hidePassword ? Icons.visibility : Icons.visibility_off),
          ),
        ),
      );

  Widget _buildErrorField() => TextFormField(
        validator: (v) => 'Что то не так...',
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: const InputDecoration(
          labelText: 'Поле ошибки',
          border: OutlineInputBorder(),
        ),
      );

  Widget _buildMultilineField() => TextFormField(
        maxLines: null,
        decoration: const InputDecoration(
          labelText: 'Многострочный',
          border: OutlineInputBorder(),
        ),
      );
}
