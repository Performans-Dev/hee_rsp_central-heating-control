## Color System


### Color List (for card bg)
```dart
static List<String> colorList = [
    '',
    '#FF5733', // Orange
    '#33FF57', // Green
    '#3357FF', // Blue
    '#FF33A1', // Pink
    '#FFDB33', // Yellow
    '#33FFF5', // Cyan
    '#B833FF', // Purple
    '#A1FF33', // Lime
];
```

### Color enum

```dart
enum ColorEnum {
  none(''),
  orange('#FF5733'),
  green('#33FF57'),
  blue('#3357FF'),
  pink('#FF33A1'),
  yellow('#FFDB33'),
  cyan('#33FFF5'),
  purple('#B833FF'),
  lime('#A1FF33');

  const ColorEnum(this.value);
  final String value;
}
```

### Color Util
```dart
static Color hexToColor(BuildContext context, String hex) {
return hex.isEmpty
    ? Theme.of(context).canvasColor
    : Color(int.parse(hex.substring(1, 7), radix: 16) + 0xFF000000);
}
```

### Color Usage
```dart
Color color = hexToColor(context, e).withValues(alpha: 0.3);
```
