//we need this file so that we can record which images have already got loaded
//in application, so that we don't  need to load images time n' again when a user
//scrolls over the list view

import 'dart:typed_data';

Map<String, Uint8List> imageData = {};
List<String> requestedIndexes = [];