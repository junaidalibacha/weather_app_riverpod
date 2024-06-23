import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _validateMode = AutovalidateMode.disabled;
  String? _city;

  void _submit() {
    setState(() {
      _validateMode = AutovalidateMode.always;
    });

    final form = _formKey.currentState;

    if (form != null && form.validate()) {
      form.save();
      Navigator.of(context).pop(_city?.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: _validateMode,
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
          ).copyWith(top: 60),
          children: [
            TextFormField(
              autofocus: true,
              style: const TextStyle(fontSize: 18),
              decoration: const InputDecoration(
                labelText: 'City name',
                hintText: 'more than 2 characters',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().length < 2) {
                  return 'City name must be 2 characters long';
                }
                return null;
              },
              onSaved: (value) => _city = value,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              child: const Text("How's weather?"),
            ),
          ],
        ),
      ),
    );
  }
}
