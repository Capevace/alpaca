<div align="center">
	<a href="https://mateffy.me/icloud-photos-backup">
		<img src="screenshots/whatsapp-tracker-icon.png" width="200px">
	</a>
	<h1>Alpaca</h1>
	<p>
		Elegant Hacker News client for iOS & macOS (Catalyst) built using SwiftUI.
	</p>
</div>

<br>

## Features
- Browse Hacker News posts (obviously, *duh*)
- Read & browse through comments
- Bookmark your favourite posts
- That's about it...

### Coming soon

- Cache bookmarked posts for offline-reading
- iCloud Sync for bookmarks
- I'll also try to implement some kind of way to post articles & comments to HN, but there's no official API for this so it might be a bit hacky...

## About the project:
> Learning a new technology without building a real-world application is hard. Building a Hacker News client teaches you some of its most important aspects. They provide a great API, that makes it easy to get started with a UI-related project. *Also I just wanted my own Hacker News client but this sounds way cooler*.

## Screenshots
![Screenshot 1](screenshots/whatsapp-tracker-1.png "Screenshot 1")
![Screenshot 1](screenshots/whatsapp-tracker-2.png "Screenshot 2")
![Screenshot 1](screenshots/whatsapp-tracker-3.png "Screenshot 3")

## Some Notes on SwiftUI
While SwiftUI is amazing in its simplicity, I also noticed a few limitations during development.

### API limitations

There aren't too many built-in components as of yet. While it's easy to add a navigation bar or a 1-column table view (as in: a List) to a view, adding a pull-to-refresh type interface is non-trivial.

You either have to utilize hacky additions to the underlying UI components (aka. introspection, see [siteline/SwiftUI-Introspect](https://github.com/siteline/SwiftUI-Introspect)) or rely on UIKit. Want to remove the seperator in a List using something like a `.seperator(.none)` call? Good luck, an API for that doesn't exist yet! Try changing globals instead:

```swift
UITableView.appearance().separatorColor = .clear
```

Thankfully SwiftUI provides a way to inject UIKit components into the SwiftUI view structure by using [UIViewRepresentable](https://developer.apple.com/documentation/swiftui/uiviewrepresentable), which lets you work around the missing pieces. This is a great way to release SwiftUI without it having 100% feature parity with UIKit and a great technical feat in general. 

I'm hoping that Apple is going to fix these API shortcomings in a future version of SwiftUI. Declarative UI code makes buildig iOS apps a lot easier (and may I add: *a lot more fun as well*).

### ~~Error messages~~ ✅ (fixed in Swift 5.2)

Error messages for SwiftUI are not very helpful. Compiler errors pop up in the wrong lines and the messages themselves often don't provide any useful information, so you're stuck removing UI code until it starts working again. 

```swift
error: binary operator '!=' cannot be applied to operands of type 'E' and '_'
  if e != .three {
     ~ ^  ~~~~~~
```

**Update:** *Swift 5.2 was just released and it addresses this issue and fixes these error messages. Here's what they look like now:*

```swift
error: type 'E' has no member 'three'
  if e != .three {
          ~^~~~~
```

Even though I haven't had a chance to check it out yet, this appears to be a major lifesaver for any SwiftUI developer out there! Props to the Swift team! 💚

## Authors
Lukas Mateffy – [@Capevace](https://twitter.com/capevace) – [mateffy.me](https://mateffy.me)

Distributed under the MIT license. See `LICENSE` for more information.
