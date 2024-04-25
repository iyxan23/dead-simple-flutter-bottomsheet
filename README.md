# Dead Simple Flutter Bottom Sheet

A dead simple flutter bottom sheet created for learning purposes.

This BottomSheet simply uses a `GestureDetector` to detect vertical drag
movements and a simple `AnimationController` to animate the bottom sheet
with some fling animations.

It simply changes the child's height with a SizedBox when the user drags
the bottom sheet, nothing fancy.

It also features a simple fading background color based on the bottom
sheet's state by utilizing a `Stack`.

## Usage

To use this dead simple flutter bottom sheet, use a `Stack` to layer your
content below the bottom sheet. `DeadSimpleBottomSheet` takes up the whole
space, because it needs to cover the entire screen.

Here's an example usage of `DeadSimpleBottomSheet`:

```dart
Stack(
  children: [
    // ... content here ...,
    DeadSimpleBottomSheet(
      expandedHeight: MediaQuery.of(context).size.height * 0.7,
      collapsedHeight: MediaQuery.of(context).size.height * 0.3,
      // child is a builder function, it will be rebuilt every time
      // the bottom sheet moves
      child: () {
        return Text("Hello World!");
      },

      // === Optional fields
      onProgress: (p) {
        // `p` is a double representing the current state of the sheet
        // it ranges from 0 to 1
      },
      // the maximum alpha of the shadow backdrop that appears when the
      // backdrop is expanded. Defaults to 0.5
      maxShadowAlpha: 0.7
    )
  ]
)
```
