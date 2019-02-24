THEOS_DEVICE_IP = 0
THEOS_DEVICE_PORT = 2222
TARGET = iphone:11.2:6.0
ARCHS = arm64 armv7s armv7
LDFLAGS = -lobjc
CFLAGS = -include macros.h

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SuperUser
$(TWEAK_NAME)_FRAMEWORKS = UIKit,Foundation,SpringBoard
$(TWEAK_NAME)_LIBRARIES = rocketbootstrap DarwinNotifCenter
$(TWEAK_NAME)_PRIVATE_FRAMEWORKS = AppSupport
$(TWEAK_NAME)_FILES = $(wildcard SuperSUiOS/*.m) $(wildcard Extensions/*.m) Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	@echo "Reminder: You MUST restart SpringBoard after installing this tweak. Otherwise the observer will not be registered and apps that setuid() in runtime might crash."
	install.exec "killall -9 SpringBoard || true"

SUBPROJECTS += prefs
include $(THEOS_MAKE_PATH)/aggregate.mk
