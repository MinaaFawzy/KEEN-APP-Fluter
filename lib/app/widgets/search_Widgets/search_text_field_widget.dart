import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keen_official_app/app/providers/search/search_providers.dart';

class SearchTextField extends ConsumerWidget {
  const SearchTextField({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16 , vertical: 8),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 60,
        child: TextFormField(
          //Validate Emails and Phone Numbers , Password
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your value';
            }
            return null;
          },
          onFieldSubmitted: (textSearch){
            ref.read(textSearchValueProvider.notifier).state = textSearch;
            ref.read(isSearchProvider.notifier).state = true;
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          cursorColor: Colors.black,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              filled: true,
              fillColor: Color(0xfff1f1f1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              hintText: 'Search products...',
              suffixIcon: Icon(CupertinoIcons.search),
              hintStyle: TextStyle(color: Colors.grey),
              focusColor: Colors.black
          ),
        ),
      ),
    );
  }
}