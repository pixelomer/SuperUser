# SuperUser

SuperSU-like tweak for jailbroken iOS devices.

## Progress

- [x] Decide how to communicate between SpringBoard and apps (CFNotificationCenter)
- [x] Prepare the idea and make a simple example
- [x] PoC is ready (0.0.1-72+debug)
- [x] Start rewriting from scratch for end-users
- [x] Prepare the notification center class (Ready but won't be used)
- [x] Prepare the client app class
- [x] Prepare the server class for SpringBoard
- [x] Setup the communication between these two classes
- [ ] Decide how to save the whitelisted and blacklisted apps
- [ ] Prepare a preference bundle
- [ ] Remove debugging stuff
- [ ] Release a beta

## Plans

- [ ] Hook to "su" executable to get root priveleges from a terminal with user password
- [ ] Run the server of the client app in a background thread to be able to pause the app's main thread while still receiving notifications.